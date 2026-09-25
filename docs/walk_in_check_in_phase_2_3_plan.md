# خطة تنفيذ 2.3 — Walk-in & Check-in

> خطة موجهة إلى Gemini وتُنفّذ بعد تثبيت عقود 2.1 و2.2. المطلوب الحفاظ على transaction/state rules الحالية، وعدم نسخ business logic من Laravel إلى Flutter. الاقتراحات في القسم الأخير لا تُنفّذ دون موافقة.

## 1) الهدف ونطاق المرحلة

- إضافة quick actions داخل `ReceptionDashboardScreen`: «حالة فورية Walk-in» و«تسجيل حضور موعد» وفق الصلاحيات.
- Walk-in ينشئ/يختار المريض، يختار الطبيب والخدمة، يجمع أسئلة الطبيب والبيانات الاختيارية، ثم ينشئ Appointment instant + WaitingList item ذريًا.
- Check-in يحول موعدًا مجدولًا مؤهلًا إلى عنصر waiting واحد، مع دعم package session التالية وقابلية إعادة الطلب دون تكرار.
- reuse endpoints الإتاحة/الأيام/الأسئلة مع 2.2، ولا تُنشأ نسخ أخرى منها داخل feature مختلف.
- خارج 2.3: التحصيل والخصومات وتعديل السعر، جدولة كل جلسات الباقة، call doctor/complete/cancel queue، وإعادة الجدولة.
- كل loading Shimmer فقط، بما في البحث والأسئلة والخدمات والإرسال وcheck-in والـrefresh؛ ممنوع كل المؤشرات الدائرية.

## 2) نتائج مراجعة Laravel الحالية

- `ReceptionBookingService::create()` هو المسار الصحيح للـWalk-in: transaction، doctor lock، service availability، daily limit، duplicate phone، questions، package sessions، Appointment + WaitingList + Intake.
- `ReceptionService::checkInAppointment()` يستخدم transaction وlocks، ويرجع نفس active queue item عند تكرار الطلب؛ أي أنه idempotent وظيفيًا.
- الموعد العادي لا يُسجّل حضوره إلا في يومه. الباقة تختار أول session مفتوحة افتراضيًا وتتحقق من الصلاحية والجلسات المتبقية.
- check-in لا يغيّر Appointment إلى status جديدة؛ يبقى `scheduled` حتى الدخول للطبيب، بينما WaitingList يصبح `waiting`.
- Walk-in الحالي يقبل حقول دفع/خصم/سعر وباقات متقدمة، لكن مواصفة 2.3 لا تطلبها؛ لا تعرضها ولا تقبلها في Mobile endpoint لهذه المرحلة.
- `available-slots` و`upcoming-days` تخص الموعد المجدول من 2.2، وليست مطلوبة في instant Walk-in. تُنفذ مرة واحدة كـshared booking APIs.
- أسئلة الاستقبال لا تملك IDs ثابتة وتعتمد على ترتيب القائمة؛ يلزم version/hash لمنع إرسال إجابات على نسخة تغيّرت.
- `RetryInterceptor` في Flutter يعيد حاليًا كل methods عند network errors، بما فيها POST؛ هذا قد يكرر Walk-in وهو خطر يجب إصلاحه قبل إطلاق 2.3.

## 3) قرارات التكامل والمعمارية

- عدّل تقسيم 2.2 إن لم يُنفذ بعد: `features/reception_appointments/` للقائمة/التقويم/actions، و`features/reception_booking/` للـpatient lookup وdoctor/service/questions والـscheduled/walk-in forms.
- `AppointmentFormScreen` و`WalkInFormScreen` يعيشان في `reception_booking` ويشتركان في domain abstractions/widgets فقط داخل نفس feature؛ لا cross-import بين reception_dashboard وappointments وbooking.
- Check-in use case يظل داخل `reception_appointments` لأنه transition على Appointment. Dashboard يفتح `/shell/appointments?date=today&mode=check_in` فقط، ولا يستورد Cubit/Entity من feature المواعيد.
- Dashboard يفتح Walk-in route مستقل full-screen؛ لا تستخدم bottom sheet لنموذج متعدد المراحل. Check-in يتم من appointment cards في وضع check-in، مع confirmation sheet قصيرة.
- shared backend APIs من 2.2 (`form-context`, patient search) هي مصدر خيارات Walk-in أيضًا؛ لا endpoint جديد يعيد نفس البيانات.

## 4) حماية التكرار — شرط مسبق إلزامي

- عدّل `RetryInterceptor` ليعيد تلقائيًا safe/idempotent methods فقط (`GET/HEAD/OPTIONS`)؛ لا retry تلقائيًا لـPOST/PUT/PATCH/DELETE.
- كل Walk-in وCheck-in يرسل `client_request_id` UUID ثابتًا طوال المحاولة. أنشئ tenant table عامة `mobile_idempotency_keys` بمفتاح unique مركب `(actor_id, operation, request_id)` مع `request_hash`, `resource_type`, `resource_id` وtimestamps؛ تصلح أيضًا لإنشاء موعد 2.2.
- داخل نفس transaction اقفل/أنشئ سجل المفتاح: التكرار بنفس hash يعيد نفس resource/response، واستخدام المفتاح نفسه مع payload مختلف يعيد 409. نظّف السجلات بسياسة retention موثقة دون حذف مفاتيح عمليات ما زالت قابلة لإعادة المحاولة.
- Flutter يمنع double tap لكنه لا يُعتبر بديلًا عن server idempotency. Check-in يحتفظ أيضًا بفحص active queue الحالي ويعيد `already_checked_in=true` عند وجود العنصر.

## 5) عقود الـGET APIs المشتركة

كل responses داخل `{success,message,data,errors?}`، snake_case، ورسائل localized بلا raw exceptions.

### 5.1 الأيام القادمة

`GET /api/mobile/reception/upcoming-days?doctor_id={required}`

- المعنى الدقيق: الأيام الـ14 القادمة **المتاحة/غير المتاحة للحجز**، وليس الأيام التي تحتوي حجوزات.
- response: `days[] {date,day_name,day_number,is_today,is_working,is_on_leave,is_full,schedule_mode,requires_time,available_count?}` و`generated_at`.
- doctor يجب أن يكون active داخل tenant. الصلاحية `reception.appointments.create`; هذا endpoint يخدم 2.2 ولا يُستدعى في instant Walk-in.

### 5.2 الأوقات المتاحة

`GET /api/mobile/reception/available-slots?doctor_id={required}&date=YYYY-MM-DD`

- validation للتاريخ والطبيب؛ استخدم `DoctorAvailabilityService` فقط.
- response: `{date,schedule_mode,requires_time,is_working,is_on_leave,daily_limit,booked_count,available_count,slots[],message}`، والـslot `{value,label,end,is_booked}`.
- queue/flexible يعيدان slots فارغة و`requires_time=false`؛ timed يعيد slots المستقبلية فقط. لا يحسب Flutter أي slot أو end time.

### 5.3 أسئلة الطبيب

`GET /api/mobile/reception/doctors/{doctor_id}/questions`

- يتطلب doctor active و`reception.questions.view` عند وجود أسئلة.
- response: `{enabled,questions_version,questions[]}`؛ question `{index,text,type,options,required}`، والأنواع المعتمدة حاليًا `text/choice`.
- `questions_version` hash للـnormalized ordered list، ويُرسل مع POST. إذا تغيرت القائمة قبل submit يعيد السيرفر 409/422 ويطلب refresh بدل ربط الإجابات بأسئلة خاطئة.

## 6) عقد Walk-in API

`POST /api/mobile/reception/walk-in` مع header/payload `client_request_id` ويعيد 201 أول مرة و200 عند replay مطابق.

Payload المعتمد:

```json
{
  "client_request_id": "uuid",
  "patient_id": 12,
  "new_patient": null,
  "doctor_id": 3,
  "service_id": 8,
  "booking_type": "first_visit",
  "priority": "normal",
  "notes": null,
  "questions_version": "sha256",
  "answers": ["...", ["..."]],
  "vital_signs": {"blood_pressure":"120/80","pulse":75,"temperature":37.0,"weight_kg":70,"height_cm":170,"oxygen_level":98,"respiratory_rate":16,"blood_sugar":100}
}
```

- إما `patient_id` أو `new_patient {full_name,phone,gender,age?,address?}` فقط. لا `ignore_duplicate_phone` bypass في الموبايل.
- السيرفر يفرض `booking_mode=instant`, `appointment_date=today`, status/entry_time/created_by، ويستخرج السعر وpackage defaults من Service.
- لا يقبل `service_price`, payment/discount, appointment times, queue position, ticket number, status أو session counts من العميل.
- الخدمة يجب أن تكون active ومتاحة للطبيب، والطبيب active، وdaily queue limit يُعاد فحصه تحت lock.
- `vital_signs` اختيارية ولا تقبل إلا مع `reception.queue.save_vitals`; BMI يحسبه `VitalSignsData` ولا يرسله/يحسبه Flutter.
- الأسئلة مطلوبة فقط عند تفعيلها للطبيب، وتتطلب view + answer permissions. كل العملية rollback إذا فشل مريض/سؤال/package/queue/intake.
- success data: `appointment` summary، `queue_item` باستخدام canonical Reception queue resource، `patient` summary، و`package? {total_sessions,completed_sessions,remaining_sessions,expires_at}`، مع `replayed` boolean.

## 7) عقد Check-in API

`POST /api/mobile/reception/check-in/{appointment_id}` مع `{client_request_id,priority:"normal|urgent|vip"}`؛ `package_session_id` اختياري فقط إذا أضيف اختيار session لاحقًا.

- يتطلب `reception.appointments.check_in`، وAppointment تابع للtenant وغير محذوف.
- العادي: status `scheduled` + appointment_date اليوم. الباقة: غير منتهية، remaining sessions > 0، واختيار أول pending/scheduled session تلقائيًا.
- active queue موجود: 200 بنفس العنصر و`already_checked_in=true`. أول مرة: 201 و`already_checked_in=false`.
- completed/cancelled/in_consultation أو يوم خاطئ أو package منتهية يعيد 409/422 typed field error دون mutation جزئية.
- response data: `{appointment_id,queue_item,already_checked_in,package_session?}`. لا تكتفِ برسالة نجاح لأن Flutter يحتاج تحديث البطاقة والطابور فورًا.
- بعد النجاح يعاد تحميل Dashboard وAppointments selected date؛ لا يعمل Flutter optimistic status transition.

## 8) Laravel — خطوات التنفيذ

1. أضف static GET routes ثم POST routes داخل reception group المحمية بـ`auth:sanctum` و`mobile.tenant`.
2. أنشئ/وسّع `V1/Reception/BookingController` للـdays/slots/questions/walkIn، و`AppointmentController::checkIn`; controllers رفيعة.
3. FormRequests مستقلة لكل endpoint بصلاحيات فعلية في `authorize()`: add_walk_in، check_in، patient lookup/create، questions، save_vitals.
4. أنشئ Resources للـday/slot/question/walk-in result/check-in result، وأعد استخدام backend `ReceptionQueueItemResource` من 2.1 بدل transformer مكرر.
5. أنشئ `MobileReceptionBookingService` orchestration يستدعي الخدمات الحالية ويضيف trusted defaults/idempotency؛ لا ينسخ منطق `ReceptionBookingService`.
6. استخرج validation المشترك بين Web وMobile إلى Requests/DTO/domain service تدريجيًا بدل بقاء rules الطويلة داخل Web controller.
7. أضف question-version validation، tenant-scoped request uniqueness، audit events: `walk_in_created`, `appointment_checked_in` مع actor/entity/context بلا PHI في logs.
8. صحح Retry policy في Flutter قبل تفعيل endpoint، ولا تعتمد على إعادة Dio التلقائية للـPOST.

## 9) Laravel — الاختبارات الإلزامية

- upcoming days: 14 يومًا، doctor/clinic schedules، leave، full queue، timed/queue/flexible، timezone وحدود اليوم.
- slots: past slots، overlap، cancelled لا يحجز slot، inactive/foreign doctor، malformed date، daily limit.
- questions: disabled/global/custom doctor، text/multi-choice، permissions، version mismatch وتغيير الترتيب.
- walk-in: existing/new patient، duplicate phone، service ownership، questions، priorities، optional vitals normalization/BMI، package defaults، daily limit، rollback الكامل.
- idempotency: نفس key+payload يعيد نفس IDs، payload مختلف 409، simultaneous duplicate requests تنشئ Appointment/WaitingList/Patient مرة واحدة.
- check-in: standard today، wrong day، كل invalid statuses، repeated request، simultaneous requests، priority، package next session/expired/exhausted، ولا duplicate queue item.
- 401/403 وtenant isolation وsoft deletes وN+1/query count، ثم تشغيل `ReceptionBookingServiceTest` كاملًا كـregression.

## 10) Flutter — Data/Domain/DI

- `reception_booking`: entities/options/questions/availability، repository/use cases للcontext/patient search/questions/walk-in، و`WalkInCubit` بحالة draft typed.
- `reception_appointments`: أضف `CheckInAppointmentUseCase` وrepository method/state action دون استيراد من dashboard/booking.
- `WalkInRequestDto` ينشئ UUID مرة عند بدء draft ويحافظ عليه بعد timeout/retry حتى النجاح أو تعديل payload جوهري؛ عند reset ينشئ UUID جديدًا.
- Models strict ولا تحول IDs المفقودة إلى 0. Repositories تحول exceptions إلى typed Failures وValidationFailure field errors.
- endpoints في `ReceptionEndpoints`; DI per feature، routes/guards في GoRouter، وكل النصوص في ar/en. لا manual instantiation.

## 11) UX داخل Dashboard وWalk-in

- Dashboard quick-actions card يظهر Walk-in مع add_walk_in، وCheck-in مع check_in + appointments view. touch target 48px وSemantics واضحة.
- Walk-in شاشة كاملة بثلاث مراحل: (1) بحث/إنشاء المريض، (2) الطبيب والخدمة والأولوية، (3) الأسئلة + optional vitals + review.
- patient search debounce وإلغاء الطلب السابق؛ نتائج/empty/error مستقلة. تغيير الطبيب يمسح service/questions غير الصالحة ويحمّل replacements بـShimmer موضعي.
- اختيار الخدمة يعرض السعر/ملخص الباقة read-only. الأولوية تعرض نصًا وأيقونة لا اللون فقط. urgent يحتاج confirmation واضح لأنه يؤثر على ترتيب الطابور.
- vitals داخل expandable section ولا يظهر إلا بالصلاحية؛ الوحدات والحدود localized، وBMI المعاد من السيرفر فقط.
- Review يوضح أن المريض سيضاف للطابور فورًا. submit ثابت أسفل الشاشة، يمنع double tap، ويعرض shimmer داخل مساحة الزر لا spinner.
- success يعرض ticket/status ثم يعود للDashboard ويعمل refresh صامت؛ لا تعرض الهاتف أو PHI في snackbar.

## 12) UX Check-in وحالات التحميل

- Quick Check-in ينقل إلى Appointments اليوم في `mode=check_in`; cards غير المؤهلة تشرح السبب ولا تعرض action وهميًا.
- الضغط يفتح bottom sheet تلخص المريض/الطبيب/الخدمة/الوقت، priority selector، وpackage progress إن وجد؛ تأكيد واحد فقط.
- initial/list/filter loading من 2.2 Shimmer. check-in action يعرض skeleton overlay على البطاقة والزر داخل sheet؛ لا circular indicator.
- success يزيل action ويظهر status «في الانتظار» مع ticket، ثم يحدث dashboard. replay يعتبر نجاحًا ولا يظهر duplicate warning.
- 422/409 يبقي sheet/form وبيانات المستخدم، يترجم الخطأ، ويعرض retry فقط إذا آمن. network uncertainty في Walk-in تستعمل نفس idempotency key.
- pull-to-refresh بـ`RefreshIndicator.noSpinner` + shimmer strip أو implementation مخصص.

## 13) Flutter tests والتحقق

- DTO/model tests: patient alternatives، questions version، answers arrays، vitals، package/queue result، malformed required fields.
- DataSource tests لكل URL/query/body/header/envelope، وعدم retry التلقائي للـPOST.
- Cubit tests: dependent field reset، stale search/question response rejection، draft UUID lifecycle، double submit، validation mapping، replay success.
- check-in tests: initial/repeated/package/error، card action isolation، refresh callbacks وعدم optimistic mutation.
- Widget tests 320px/phone/tablet، RTL/LTR/text scale، permissions، all partial shimmer/error/empty states، وعدم وجود circular/cupertino indicators.
- format + analyze بلا warnings، Laravel mobile/regression tests، Flutter feature tests ثم suite الكامل.

## 14) Definition of Done

- Walk-in ذري وآمن من التكرار، وCheck-in idempotent ولا ينشئ أكثر من queue item/session attendance.
- business rules والسعر والتذكرة والجلسات والإتاحة في Laravel فقط؛ Flutter يعرض state ولا يحسبها.
- صلاحيات وtenant isolation وPHI/audit مطبقة في API وUI، وكل errors localized بلا raw details.
- تكامل واضح مع 2.1/2.2 بلا duplicate endpoints/entities أو cross-feature imports.
- كل loading Shimmer، كل ملف أقل من 200 سطر، ولا hardcoded strings/colors/endpoints/durations أو regressions.

## 15) تحسينات تحتاج موافقة

- منع Walk-in لطبيب في إجازة/خارج ساعات العمل أو السماح به مع override permission + audit؛ النظام الحالي يسمح بالinstant للطبيب النشط دون هذا المنع.
- تنبيه doctor لحظيًا عند urgent walk-in عبر push/in-app event دون PHI على lock screen.
- اختيار package session يدويًا عند check-in بدل أول session متاحة.
- تحصيل السعر/الخصم وإصدار الإيصال داخل Walk-in؛ يحتاج مرحلة مالية وصلاحيات واختبارات refund مستقلة.
- مسح QR لرقم الموعد لتسريع check-in، مع token قصير العمر لا يحتوي patient ID مباشرًا.
