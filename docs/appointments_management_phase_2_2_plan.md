# خطة تنفيذ 2.2 — Appointments Management

> خطة تنفيذ موجهة إلى Gemini داخل `CodraCare` و`medical_erp`. تُنفّذ بعد اكتمال واعتماد 2.1، وبالترتيب التالي: تثبيت قرارات الـdomain وعقد API، ثم Laravel واختباراته، ثم Flutter واختباراته. لا تُنفّذ تحسينات القسم الأخير دون موافقة صاحب المشروع.

> **تكامل 2.3:** قبل التنفيذ راجع `walk_in_check_in_phase_2_3_plan.md`؛ فهو يفصل shared form logic داخل `reception_booking` ويضيف idempotency إلزامية لكل عمليات الإنشاء، ويُعد المرجع الأحدث عند أي تعارض معماري.

## 1) هدف المرحلة وحدودها

- إنشاء `AppointmentsScreen` كتجربة mobile-first تجمع Calendar + قائمة مواعيد اليوم المحدد + فلاتر الطبيب والحالة + pagination.
- إنشاء `AppointmentFormScreen` لحجز **موعد مجدول** لمريض موجود أو تسجيل مريض جديد حسب الصلاحية.
- عرض `AppointmentEntity` بصورة typed تشمل المريض والطبيب والخدمة والتاريخ والوقت ونوع/نمط الحجز والحالة والسعر والجلسات.
- دعم إلغاء الموعد بسبب إلزامي، مع تطبيق state/permission rules من السيرفر.
- لا تشمل 2.2: walk-in/instant queue creation، check-in، إدخال المريض للطبيب، التحصيل والخصومات، تعديل السعر، إعادة الجدولة، أو إدارة جلسات الباقة. هذه flows مستقلة رغم أن القائمة يمكنها عرض سجلاتها الحالية.
- كل loading في الشاشتين Shimmer فقط؛ ممنوع أي circular/cupertino progress indicator، بما فيها refresh وpagination والأزرار والحوارات.

## 2) حقائق اكتشفتها المراجعة ويجب ألا يتجاهلها التنفيذ

- Mobile APIs المذكورة غير موجودة حاليًا، بينما Laravel Web يستخدم `AppointmentRepository`, `ReceptionBookingService`, و`DoctorAvailabilityService`.
- الحالة canonical حاليًا أربع فقط: `scheduled`, `in_consultation`, `completed`, `cancelled`.
- migration `2026_08_31_134600_simplify_booking_statuses.php` حوّل `confirmed` و`checked_in` إلى `scheduled`، و`no_show` إلى `cancelled`.
- route الويب `appointments/{id}/confirm` يشير إلى method غير موجودة في `AppointmentController`; تنفيذها كما هي سيكون خطأ مؤكدًا.
- `Appointment.appointment_time` موجود في `$fillable` لكن لا يوجد له column في migrations؛ القيمة الصحيحة للعرض هي `start_time`، و`appointment_time` في الـAPI يكون alias محسوبًا فقط.
- يوجد مفهومان مختلفان ممنوع دمجهما: `booking_mode` في Appointment (`scheduled/instant`) ونظام حجز الطبيب (`timed/queue/flexible`). سمِّ الثاني في الـAPI وFlutter `schedule_mode`.
- إنشاء الحجز الحالي يطبق transaction + قفل الطبيب + إتاحة الخدمة + daily limit + منع التعارض + أسئلة الاستقبال + إنشاء package sessions. يجب إعادة استخدامه وعدم إعادة كتابة هذه القواعد في controller أو Flutter.
- الـ5 endpoints المقترحة لا تكفي لبناء form صحيح؛ يلزم form-context + patient search، وإلا ستتكرر قواعد الإتاحة والخدمات في الموبايل.

## 3) تصحيح إلزامي لمواصفة confirm

- التوصية المعتمدة للخطة: **لا تنفّذ `POST /appointments/{id}/confirm` في 2.2** ولا تعرض زر Confirm؛ الموعد الجديد يدخل `scheduled` بالفعل ولا توجد حالة انتقال أخرى.
- احذف route الويب الميت أو أضف له deprecation test/تعليق حسب قرار الفريق، لكن لا تعِد حالة `confirmed` القديمة.
- إذا كان المنتج يحتاج «تأكيد هاتفي» لاحقًا، يكون metadata مستقلًا (`confirmed_at`, `confirmed_by`) مع migration وaudit وentity fields، وليس status جديدًا. هذا تحسين يحتاج موافقة منفصلة.

## 4) عقود الـAPI النهائية

كل responses تستخدم envelope المشروع `{success,message,data,errors?}` و`snake_case` فقط.

### 4.1 القائمة

`GET /api/mobile/reception/appointments?date=YYYY-MM-DD&doctor_id=&status=&page=1&per_page=20`

- `date` افتراضيًا تاريخ اليوم حسب tenant/server timezone، `per_page` ضمن `[10,20,30]`، وstatus من الحالات الأربع فقط.
- response data: `items`, و`meta {current_page,last_page,per_page,total,has_more}`, و`applied_filters`.
- الترتيب لليوم المحدد: timed أولًا حسب `start_time`، ثم queue حسب `queue_position`، ثم `id`. لا تعتمد على ترتيب client.

### 4.2 تقويم الشهر

`GET /api/mobile/reception/appointments/calendar-events?month=YYYY-MM&doctor_id=&status=`

- السيرفر يحوّل month إلى أول/آخر يوم ويرفض أي صيغة أخرى بـ422؛ لا يقبل range مفتوحًا.
- response لا يكرر بيانات المرضى: `month` و`days[]` بالشكل `{date,total,status_counts:{scheduled,in_consultation,completed,cancelled}}`، وهو كافٍ لعلامات التقويم وأكثر أمانًا وأخف من أسماء المرضى.
- فلاتر doctor/status في التقويم تطابق فلاتر القائمة حتى لا تختلف العلامات عن اليوم المفتوح.

### 4.3 بيانات الـform والإتاحة — إضافة إلزامية

`GET /api/mobile/reception/appointments/form-context?doctor_id=&date=YYYY-MM-DD`

- يعيد `doctors[]` مع `{id,name,specialization,schedule_mode,requires_time,daily_limit,default_service_id}`.
- عند doctor_id يعيد الخدمات المتاحة له فقط: `{id,name,price,duration_minutes,is_package,total_sessions,validity_days}`، والأسئلة الفعلية المرتبة، وavailability لليوم.
- availability: `{schedule_mode,requires_time,is_working,is_on_leave,slots[],available_count,daily_limit,booked_count,message}`؛ slot هو `{value,label,end,is_booked}`.
- يعيد `booking_types` والقيم الأربع، و`capabilities` للصلاحيات relevant، وserver date/time.
- السعر للعرض فقط؛ Flutter لا يحسب السعر أو end time أو availability.

`GET /api/mobile/reception/appointments/patients/search?q=&page=1`

- minimum query آمن (مثل 2–3 أحرف/أرقام)، limit صغير، ونتائج `{id,patient_code,full_name,phone,gender,age,address}` حسب `reception.patients.lookup`.
- لا يعيد history أو بيانات طبية، ولا يسجل query/phone في logs.

### 4.4 إنشاء الموعد

`POST /api/mobile/reception/appointments` ويعيد 201 و`appointment` serialized بنفس عقد القائمة.

- payload: `patient_id` أو `new_patient {full_name,phone,gender,age?,address?}`، ثم `doctor_id`, `service_id`, `appointment_date`, `appointment_time?`, `booking_type`, `notes?`, `answers?`.
- 2.2 تفرض `booking_mode=scheduled` server-side؛ لا تقبل `instant` من العميل.
- لا يقبل API `service_price`, `end_time`, `queue_position`, `status`, `total_sessions`, أو `created_by` من العميل. يستخرجها السيرفر من service/doctor/context لتجنب tampering.
- timed يتطلب slot، queue/flexible لا يتطلب وقتًا ويحسب queue position؛ يعاد التحقق داخل transaction عند submit حتى لو كان slot ظاهرًا كمتاح.
- package service تنشئ parent appointment وdefault package sessions عبر الخدمة الحالية، بلا دفع وبلا custom schedule في 2.2.
- duplicate phone يعيد 422 مع patient match آمن يسمح للمستخدم باختيار الملف الموجود إذا كان يملك lookup، ولا يوجد bypass من الموبايل.

### 4.5 الإلغاء

`POST /api/mobile/reception/appointments/{id}/cancel` مع `{cancellation_reason}` (2–300 حرف).

- في 2.2 يسمح بإلغاء `scheduled` فقط. `in_consultation/completed/cancelled` يعيد 409/422 برسالة localized وحقل error واضح.
- لو للموعد payment/refund أو active queue/package session متأثرة، لا تنفذ تعديلًا جزئيًا؛ أعد conflict يتطلب flow مالي/تشغيلي مخصص لاحقًا.
- success يعيد appointment المحدث. العملية transaction + lock + audit actor/reason/before/after.

## 5) عقد AppointmentEntity

- `AppointmentEntity`: id، appointmentNumber، `PatientSummaryEntity`، `DoctorSummaryEntity`، `ServiceSummaryEntity?`، appointmentDate، appointmentTime?، startTime?، endTime?، queuePosition?، bookingType، bookingMode، status، servicePrice، notes?، cancellationReason?، totalSessions?، completedSessions?، remainingSessions?، capabilities.
- enums مستقلة: `AppointmentStatus`, `BookingType`, `AppointmentBookingMode`; و`DoctorScheduleMode` للـform فقط. أضف `unknown` للعرض الآمن عند forward compatibility، لكن امنع unknown في requests.
- API field names snake_case؛ money يُنقل كرقم decimal ويُعرض بـ`intl`، ولا تُجرى عليه حسابات في UI.
- capabilities لكل item مثل `can_cancel`; السيرفر هو المصدر النهائي، والـUI لا يستنتجها من اللون أو الحالة فقط.

## 6) Laravel — خطة التنفيذ

1. أضف routes داخل مجموعة reception الحالية المحمية بـ`auth:sanctum` و`mobile.tenant`، مع ترتيب static routes قبل أي `{id}`.
2. أنشئ `app/Http/Controllers/V1/Reception/AppointmentController.php` رفيعًا: index/calendar/context/search/store/cancel فقط.
3. أنشئ FormRequests منفصلة: list filters، calendar query، context query، patient search، store، cancel؛ `authorize()` يفحص صلاحية العملية ولا يكون `true` بلا شرط.
4. أنشئ `AppointmentResource`, summaries، و`AppointmentCollection`; لا ترجع Models مباشرة ولا labels/CSS classes من Laravel.
5. وسّع `AppointmentRepository` باستعلامات mobile typed ومحدودة select/eager-load، daily aggregates، وpagination بلا N+1.
6. أنشئ `ReceptionAppointmentService` كواجهة orchestration للموبايل، ويستدعي `ReceptionBookingService`/`DoctorAvailabilityService` بدل نسخ القواعد.
7. refactor مدروس لـ`ReceptionBookingService` كي يستمد السعر والحقول المحسوبة من models في مسار mobile، مع بقاء web behavior واختباراته دون regression.
8. طبّق صلاحيات: view، create، cancel، patient lookup/create، questions view/answer. إخفاء زر Flutter ليس حماية.
9. استخدم tenant timezone، soft-delete scopes، DB transaction وlockForUpdate عند الإنشاء/الإلغاء، ورسائل عامة بلا raw exception/SQL/PHI.
10. لا تغيّر enum statuses ولا تضف `appointment_time` column؛ Resource يحسب alias من `start_time`.

## 7) Laravel — الاختبارات الإلزامية

- list: default date، كل filter منفردًا ومجتمعًا، sorting، pagination/meta، empty، invalid params، soft deletes.
- calendar: boundaries لكل شهر ومنها leap year، filters، counts، وعدم تسريب أسماء/هواتف.
- context: timed/queue/flexible، إجازة الطبيب، ساعات الطبيب/العيادة، daily limit، slots المحجوزة، service availability، required questions.
- create: existing/new patient permissions، timed success، queue success بلا fake time، conflict race، leave/day limit، invalid service، duplicate phone، questions، package defaults، rollback الكامل عند أي فشل.
- cancel: scheduled success + reason/audit، وكل invalid transition، linked queue/payment/package conflict، idempotency behavior.
- security: 401/403، doctor/patient/service من tenant آخر، query-count/N+1، وعدم إظهار stack trace.
- شغّل `ReceptionBookingServiceTest` كاملًا كـregression بجانب Mobile appointment feature tests.

## 8) Flutter — المعمارية والملفات

- feature مستقل `features/reception_appointments/` بطبقات data/domain/presentation؛ لا يستورد entities أو Cubits من reception_dashboard أو doctor features.
- Domain: entities/enums، `AppointmentFilters`, `AppointmentsPageEntity`, repository abstract، use cases: list/calendar/context/search/create/cancel.
- Data: models strict، request DTOs، remote data source، repository impl، و`ReceptionEndpoints`; required ids لا تتحول إلى صفر عند parse failure.
- Presentation: `AppointmentsCubit` للقائمة/التقويم/الفلاتر/pagination/cancel، و`AppointmentFormCubit` للسياق والبحث والdraft والsubmit؛ لا Cubit ضخم مشترك.
- DI في `reception_appointments_di.dart` ويُستدعى من `app_di.dart`. استبدل appointments Placeholder، وأضف route مستقل `/appointments/new` خارج/فوق shell حسب نمط المشروع.
- guards تفحص account type + role + permission + tenant context. أضف localization كاملة تحت `reception_appointments` في ar/en.
- كل ملف أقل من 200 سطر، وكل constants/colors/spacing/radius/icons/durations من design system.

## 9) AppointmentsScreen — UX وحالات البيانات

- AppBar بعنوان المواعيد + زر إضافة يظهر فقط مع create permission، وdate subtitle مناسب للـlocale.
- Calendar يبدأ week view لخفض استهلاك الشاشة مع زر توسيع month؛ dots/count badge مبنية من calendar summary، واليوم المختار واضح باللون + border/semantics لا اللون فقط.
- Doctor filter وStatus filter كـbottom-sheet dropdowns مناسبة لـ320px، مع زر reset واضح. تغيير الشهر يحمل calendar وحده، وتغيير اليوم يحمل list وحدها.
- قائمة اليوم Cards وليست table: الوقت/رقم الدور، المريض، الطبيب، الخدمة، booking type/status، package progress عند وجوده، والسعر وفق صلاحية العرض.
- action menu يعرض Cancel فقط حين `can_cancel`; confirmation bottom sheet يطلب reason ويشرح أن العملية لا يمكن عكسها من هذه المرحلة.
- initial: calendar/list shimmer مطابق. month/day/filter refresh: shimmer موضعي. pagination: 2–3 card skeletons أسفل القائمة. cancel: shimmer overlay داخل البطاقة وزر dialog skeleton، بلا spinner.
- pull refresh باستخدام `RefreshIndicator.noSpinner` + top shimmer strip، أو بديل مخصص. Background refresh يحتفظ بالبيانات؛ failure يظهر localized banner ولا يمسح القائمة.
- empty states مختلفة: لا مواعيد لهذا اليوم، لا نتائج للفلاتر، الشهر بلا أحداث؛ error initial مع Retry ينتقل إلى shimmer.

## 10) AppointmentFormScreen — User flow

- custom mobile progress header بثلاث مراحل، وليس Material Stepper طويل: (1) المريض، (2) الطبيب/الخدمة/الموعد، (3) الأسئلة والمراجعة.
- المريض: search debounce + cancel previous request، نتائج Shimmer، اختيار موجود؛ أو inline new patient فقط مع create permission. لا تحفظ PHI في logs.
- الجدولة: اختيار الطبيب ثم service المتاحة فقط، booking type، التاريخ؛ timed يعرض slots، queue يعرض رقمًا تقديريًا غير ملزم، flexible يوضح عدم وجود وقت ثابت.
- تغيير الطبيب يمسح service/slot/questions غير الصالحة؛ تغيير التاريخ يمسح slot ويجلب availability مجددًا. كل dependency loading لها skeleton موضعي.
- الأسئلة تظهر فقط لو رجعت من context ومع view/answer permission، وتُرسل بنفس الترتيب لأن schema الحالي لا يملك question IDs.
- Review يعرض السعر من السيرفر read-only، المريض، الطبيب، الخدمة، التاريخ/الوقت، نوع الحجز، ملخص الباقة، والملاحظات قبل submit.
- submit online-only بسبب احتمال slot conflict؛ عند network failure يحتفظ Cubit بالdraft في الذاكرة. لا queue offline تلقائيًا، وأي persistent draft مستقبلًا يجب أن يكون مشفرًا وموسومًا tenant/user ويعيد validation قبل الإرسال.
- نجاح 201: BlocListener يعرض success ثم `pop(true)`؛ الشاشة السابقة تعيد calendar/list لليوم الجديد. 422 يربط field errors بالحقول ويقفز لأول مرحلة بها خطأ؛ conflict يجدد availability دون فقد draft.

## 11) Flutter tests والتحقق

- Model/DTO tests لكل enums/nullables/package/queue records، strict malformed payload، pagination وcalendar summary.
- DataSource tests لكل endpoint/query/body/envelope و422 field mapping؛ Repository/UseCase لكل Failure type.
- AppointmentsCubit: independent calendar/list loads، filters، stale response rejection، pagination dedupe، cancel success/failure، refresh مع stale data.
- FormCubit: dependency resets، debounced patient search، timed/queue/flexible validation، questions، submit double-tap guard، conflict refresh، draft retention.
- Widget tests عند 320px/phone/tablet وRTL/LTR وlarge text، permissions، empty/error/partial loading، cancel sheet، وعدم وجود `CircularProgressIndicator` أو `CupertinoActivityIndicator` في subtree.
- بعد التنفيذ: format، `flutter analyze` بلا warning، Laravel Mobile + regression tests، Flutter feature tests ثم suite المشروع.

## 12) Definition of Done

- العقود الفعلية تطابق الخطة وموثقة باختبارات؛ لا endpoint confirm وهمي ولا status خارج enum.
- business rules في Laravel فقط، وFlutter لا يحسب السعر/end time/availability/queue position أو transition permissions.
- tenant/permission/PHI/audit requirements محققة، ولا توجد writes جزئية أو double submit/race conflict.
- Calendar/list/form responsive ومترجمة وقابلة للوصول، وجميع حالات التحميل Shimmer بلا مؤشر دائري.
- لا hardcoded strings/endpoints/tokens، لا cross-feature imports، لا ملف فوق 200 سطر، ولا regressions في نظام الحجز الحالي.

## 13) تحسينات تحتاج موافقة قبل التنفيذ

- `confirmed_at/confirmed_by` لتسجيل التأكيد الهاتفي دون إعادة status `confirmed`.
- إعادة جدولة الموعد بالسحب من التقويم أو form edit؛ تحتاج endpoint وconflict/audit flow مستقلًا.
- إضافة check-in من بطاقة الموعد ونقله للطابور؛ مكانها مرحلة Queue Management.
- التحصيل/الخصومات/تعديل السعر وجدولة كل جلسات الباقة من الموبايل؛ تحتاج مراجعة مالية وصلاحيات واختبارات إضافية.
- reminders واتصال/WhatsApp بالمريض مع consent وقوالب localized وعدم كشف PHI في lock screen.
