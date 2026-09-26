# خطة تنفيذ 2.5 — Reception Follow-ups

> وثيقة تنفيذ موجهة إلى Gemini وتُنفّذ بعد تثبيت 2.2–2.4 والـAdaptive Sidebar. الالتزام الكامل بـ`.agents/rules/rules.md` إلزامي. الاقتراحات في القسم الأخير لا تُنفّذ دون موافقة.

## 1) الهدف والنطاق

- إنشاء `ReceptionFollowUpsScreen` لعرض الزيارات المكتملة التي طلب الطبيب لها متابعة (`followup_days > 0`) ولم يُنشأ لها موعد متابعة بعد.
- تمكين موظف الاستقبال من فتح تدفق الحجز الحالي بحالة Follow-up وإنشاء موعد واحد مرتبط بالزيارة الأصلية.
- عرض الاستحقاق: متأخر، مستحق اليوم، أو قادم، مع البحث والفلترة والطبيب وpagination.
- خارج النطاق: تعديل تعليمات الطبيب، تشخيص المريض، التواصل التلقائي، التحصيل/الخصم، إلغاء المتابعة نفسها، أو إنشاء زيارة مباشرة.
- كل loading في القائمة والفلاتر والنموذج والـslots والحفظ Shimmer فقط؛ ممنوع `CircularProgressIndicator`, `CupertinoActivityIndicator` و`RefreshIndicator` الافتراضي.

## 2) نتائج مراجعة Laravel الحالية — إصلاحها قبل الموبايل

- المصدر هو `Visit`: الحالة `completed`، و`followup_days > 0`، و`followup_scheduled_at = null`. التاريخ المستهدف = `visit_date + followup_days`.
- النظام الحالي يعرض المريض والطبيب والخدمة وتاريخ الزيارة وفترة المتابعة والتاريخ المقترح وتعليمات الطبيب، مع فلاتر search/doctor/urgency/date.
- `ReceptionFollowUpService::scheduleFollowUp()` يفحص التكرار خارج الـtransaction ولا يقفل الزيارة؛ طلبان متزامنان قد ينشئان موعدين.
- المسار الحالي ينشئ Appointment مباشرة عبر repository، ولذلك يتجاوز إجازة الطبيب، working hours، slot conflict، daily limit وservice availability الموجودة في `ReceptionBookingService`.
- إذا غابت الخدمة يختار أول خدمة نشطة، ويقبل `service_price` من العميل مع default صفر؛ هذا غير آمن وغير صحيح ماليًا.
- فلترة urgency تستخدم صيغة SQLite: `DATE(visit_date, '+' || followup_days || ' days')`، وهي غير portable وقد تفشل على MySQL.
- الترتيب الحالي حسب أحدث زيارة، وليس حسب أقرب/أقدم استحقاق؛ وهذا يخفي الحالات المتأخرة.
- عرض القائمة مسموح حاليًا لمن يملك queue view، والجدولة قد تُسمح بصلاحية add walk-in؛ الصلاحيتان لا تعبّران عن Follow-ups.
- عند إلغاء موعد متابعة من 2.2 لا يتم مسح الربط من الزيارة، فتختفي المتابعة نهائيًا من pending list.
- Web controller يضم raw exception message داخل 500 response؛ لا يُنقل للموبايل ويجب إزالته من Web أيضًا.

## 3) تعريف eligibility ومصدر الحقيقة

- أنشئ domain query واحدة `PendingFollowUpQuery` تستخدمها القائمة، إحصائياتها، و`ReceptionDashboardRepository`; ممنوع تكرار predicate.
- eligibility: زيارة غير محذوفة، `status=completed`، لها patient وdoctor صالحان، `followup_days` بين 1 و365، ولا يوجد `followup_scheduled_at` أو `followup_appointment_id` صالح.
- أضف `followup_due_date` كحقل date مفهرس في visits، يُكتب مركزيًا عند حفظ/إكمال فحص الطبيب، مع migration backfill على دفعات من `visit_date + followup_days`.
- أي تعديل لاحق لـ`visit_date/followup_days` يحدّث due date في نفس domain service. لا تحسب Flutter الاستحقاق ولا تعتمد على توقيت الجهاز.
- استخدم tenant timezone في تعريف “اليوم”، وأعد `due_date`, `urgency`, `days_delta` من الخادم. اختبر timezone boundaries وDST إن كانت المنطقة تدعمه.
- index مقترح: `(status, followup_scheduled_at, followup_due_date, doctor_id)` بعد مراجعة خطة الاستعلام الفعلية.

## 4) الصلاحيات والأمان

- أضف صلاحيتين canonical: `reception.follow_ups.view` و`reception.follow_ups.schedule`، وحدّث config/seeding/role assignment دون منح شامل تلقائي.
- GET وroute/Sidebar يحتاجان view، وPOST يحتاج schedule. ownership وtenant/branch والطبيب/الخدمة تُفحص API-side دائمًا.
- لا تعتبر queue view أو add walk-in بدائل. يمكن migration مؤقتة للأدوار المعتمدة فقط ثم حذف fallback بعد الانتقال.
- لا ترجع diagnosis/chief complaint/prescriptions. `followup_notes` تعليمات طبية read-only، والهاتف يظهر فقط وفق سياسة بيانات المرضى.
- لا تخزن القائمة في persistent cache ولا تسجل names/phones/notes في logs أو analytics. audit للجدولة: actor، visit id، appointment id، doctor id، timestamp فقط.

## 5) عقد GET النهائي

`GET /api/mobile/reception/follow-ups?search=&doctor_id=&urgency=&due_from=&due_to=&page=&per_page=`

- `urgency`: `overdue|today|upcoming`; `per_page` افتراضي 20 وأقصى 50؛ التواريخ `Y-m-d` مع تحقق `due_to >= due_from`.
- search server-side بـdebounce 350ms على patient name/code/phone، doctor، visit number؛ notes search يحتاج نفس view permission ولا يظهر raw query في logs.
- ترتيب افتراضي: overdue الأقدم أولًا، ثم اليوم، ثم القادم تصاعديًا، ثم visit id ثابتًا.
- Response:

```json
{
  "data": [{ "visit_id": 10, "visit_number": "VST-10", "visit_date": "2026-09-01", "patient": {"id": 4, "name": "...", "code": "P-4", "phone": "..."}, "doctor": {"id": 2, "name": "...", "specialization": "..."}, "original_service": {"id": 3, "name": "..."}, "followup_days": 14, "followup_notes": "...", "due_date": "2026-09-15", "urgency": "overdue", "days_delta": -11, "capabilities": {"can_schedule": true} }],
  "meta": {"current_page": 1, "last_page": 1, "per_page": 20, "total": 1, "has_more": false},
  "summary": {"total_pending": 1, "overdue": 1, "due_today": 0, "upcoming": 0, "scheduled_this_month": 3},
  "doctors": [{"id": 2, "name": "...", "pending_count": 1}],
  "applied_filters": {"search": null, "doctor_id": null, "urgency": null, "due_from": null, "due_to": null},
  "generated_at": "ISO-8601"
}
```

- summary يحترم doctor/search/date scope ويتجاهل urgency فقط كي تظل chips قابلة للمقارنة. عدّاد Dashboard يستخدم total pending غير المفلتر من نفس query.
- أضف `GET /api/mobile/reception/follow-ups/{visitId}/schedule-context` لدعم فتح/إعادة تحميل/deep link نموذج الحجز بأمان؛ يعيد الزيارة وdefaults وdoctors/services/availability/capabilities فقط.

## 6) عقد الجدولة النهائي

`POST /api/mobile/reception/follow-ups/{visitId}/schedule`

```json
{"doctor_id":2,"service_id":3,"appointment_date":"2026-09-28","appointment_time":"14:30","notes":"...","client_request_id":"uuid"}
```

- patient يؤخذ من الزيارة، و`booking_type=follow_up` إجباري، وbooking mode/ضرورة الوقت/end time والسعر يحسبها Laravel؛ لا تقبل patient id أو status أو booking type أو service price من Flutter.
- doctor/service مطلوبان وصالحان لبعضهما. default هو الطبيب والخدمة الأصليان؛ إذا أصبحت الخدمة غير متاحة يجب الاختيار، ولا fallback لأول خدمة.
- السعر المرجعي هو `Service.followup_price` بما فيه الصفر إن كان يعني متابعة مجانية. لا price override في 2.5؛ ثبّت هذه السياسة باختبار مالي قبل التنفيذ.
- التاريخ اليوم أو مستقبل، ويبدأ UI بالمقترح: due date إن كان قادمًا، وإلا اليوم. timed doctor يحتاج slot متاح؛ queue doctor لا يرسل وقتًا.
- `notes` ملاحظات حجز جديدة اختيارية حتى 1000 حرف؛ `followup_notes` الأصلية read-only ولا تُعدّل أو تُستبدل.
- service يمسك الزيارة `lockForUpdate` داخل tenant transaction، يعيد فحص eligibility، ثم يستخدم مسار `ReceptionBookingService` الموحد لفحص الإجازات/السعة/التعارض والخدمة وإنشاء الموعد، ثم يحدّث visit link ذريًا.
- نفّذ idempotency بـ`client_request_id` من 2.3، ولا auto-retry للـPOST. نفس المفتاح يعيد نفس النتيجة، وطلب منافس مختلف يرجع `409 FOLLOW_UP_ALREADY_SCHEDULED` دون موعد ثانٍ.
- نجاح 201 يعيد `{data: {visit_id, appointment: AppointmentResource}, summary, message_key}`. الأخطاء typed: 401/403/404/409/422، ولا raw exception أو user-facing server strings كعقد.

## 7) التكامل مع الإلغاء والبيانات القديمة

- داخل `ReceptionAppointmentService::cancelAppointment()`، إذا كان الموعد `booking_type=follow_up` ومربوطًا كـ`followup_appointment_id` لزيارة ولم يبدأ، امسح `followup_scheduled_at/id` في نفس transaction ليعود pending.
- لا تمسح الربط إذا اكتملت/بدأت زيارة المتابعة؛ state rules هي المرجع. اختبر cancellation وsoft-delete وappointment missing.
- migration repair command يرصد: timestamp بلا appointment id، appointment مفقود/ملغي، أو duplicate follow-up appointments؛ يعمل dry-run أولًا ويُراجع قبل الإصلاح.
- `followup_notified` لا يُستخدم كعلامة scheduled؛ أبقه خارج Mobile contract. إعادة تسميته/فصل notification state تحسين مستقل.

## 8) Mobile UX وUser Flow

- route: `/shell/reception/follow-ups` في Sidebar تحت «العمل اليومي» بعد Queue، بصلاحية view. بطاقة Dashboard pending follow-ups تفتح route فقط إذا capability يسمح.
- أعلى الشاشة: العنوان + last updated، summary chips قابلة للفلترة، search، doctor filter، ثم due-date filters داخل sheet قصيرة على الهاتف.
- الهاتف يعرض cards، والتابلت split/list موسعة. Card يعرض المريض، visit number، الطبيب/الخدمة، due date، days label، urgency badge، وتعليمات الطبيب read-only قابلة للتوسيع.
- لا تعتمد urgency على اللون وحده. الأولوية في العرض: overdue ثم today ثم upcoming، مع headers وعدّادات واضحة.
- زر «حجز متابعة» ينقل بـ`go_router` إلى `AppointmentFormScreen` الحالي في `reception_booking` بوضع typed `followUp(visitId)`؛ لا import مباشر بين features.
- نموذج الحجز يثبت المريض، يعرض تعليمات الطبيب، يحدد الأصل كdefault، ويعيد استخدام date/doctor/service/slots UI من 2.2. submit في follow-up mode يستدعي endpoint الخاص أعلاه.
- النجاح يعرض رقم/تاريخ الموعد، يعود للقائمة، يزيل العنصر ويحدّث summary ثم silent refresh. الفشل 409 يعرض أن المتابعة حُجزت بالفعل مع رابط الموعد إن كانت الصلاحية تسمح.
- initial/filter/search/page/schedule-context/slots/submit كلها shimmer مطابق للمساحة. أثناء الجدولة استبدل CTA بـshimmer capsule؛ لا spinner ولا refresh circle.
- refresh صامت مع البيانات الحالية وstale banner عند الفشل، وload-more skeleton. احفظ filters في Cubit خلال session، ولا تحفظ PHI محليًا.

## 9) Flutter Architecture

- أنشئ `features/reception_follow_ups/` مستقلًا: data/domain/presentation، repository abstract، typed entities/models/params، use cases `GetFollowUps`, وCubits للقائمة فقط.
- توسيع `reception_booking` بحالة `FollowUpBookingMode`, context loader و`ScheduleFollowUpUseCase`; الشاشة تعرف mode من route، لا من import لـfollow-ups.
- التواصل بين feature القائمة والحجز بالـroute وvisit id فقط. لا استيراد cubit/entity/repository بين sub-modules، ولا إعادة نسخ appointment form أو availability logic.
- `ReceptionFollowUpsCubit` يحمل filter/pagination/data/refreshWarning؛ debounce قابل للإلغاء، request generation تمنع stale response، pagination dedupe بالـvisit id، و`BlocSelector` يقلل rebuilds.
- كل repos/use cases تعيد `Either<Failure,T>`؛ Dio في data source فقط، endpoints في `ReceptionEndpoints`، DI في ملف كل feature ثم `app_di.dart`.
- أضف AR/EN keys وcentral tokens/icons/routes/guards. دعم RTL/LTR، dark/light، 320px، tablet/landscape، textScale 2.0، semantics، keyboard و48px targets.
- كل ملف أقل من 200 سطر، بلا hardcoded UI values/strings/endpoints، ولا تعديل Doctor examination feature إلا مزامنة due date المغطاة باختبارات.

## 10) Laravel Structure

- `V1/Reception/FollowUpController` thin؛ Requests للقائمة/context/schedule؛ `FollowUpResource`, context resource، وservice/repository الحاليان بعد التقوية.
- استخرج eligibility/scope وurgency إلى query/domain service واحد، وأعد استخدام `ReceptionBookingService`; لا Web Controller dependency ولا Eloquent خام.
- queries select/eager-load الحقول اللازمة، paginate، وتحسب summary دون N+1. context يتحقق أن visit ما زال eligible قبل كشف البيانات.
- أصلح Web controller ليستخدم نفس service/Requests والصلاحيات ولا يعيد `$e->getMessage()`، مع بقاء response المناسب للويب.

## 11) ترتيب التنفيذ

1. ثبّت سياسة السعر والصلاحيات، واكتب characterization tests للسلوك الحالي والحالات غير السليمة.
2. أضف due date migration/backfill/query الموحدة، وطابق Dashboard count مع list count.
3. أضف permissions واصلح Web leakage ثم cancellation relink behavior.
4. قوِّ schedule service: lock + eligibility + idempotency + booking service، ثم API/resources/context.
5. اختبر Laravel كاملًا، ثم أنشئ Flutter feature ووسّع booking mode مع unit/Cubit tests.
6. ابنِ UI والـshimmers، ثم Sidebar/dashboard routes والترجمات وresponsive/accessibility.
7. formatter، `flutter analyze` بلا warnings، feature/full Flutter tests، ثم Laravel targeted/full suite.

## 12) الاختبارات الإلزامية

- Laravel: eligibility لكل حالة، soft-deletes، tenant/branch isolation، permissions، pagination/search/filter/sort، timezone، stats/dashboard parity، MySQL/SQLite compatibility.
- Schedule: original/changed doctor-service، timed/queue doctor، leave/full day/slot race، inactive service، server price، idempotent replay، concurrent distinct requests، audit بلا PHI.
- Cancel: يعود pending عند إلغاء الموعد المؤهل ولا يعود بعد بدء/اكتمال المتابعة؛ repair command dry-run fixtures.
- Flutter: strict parsing،filters/debounce/race،pagination dedupe،Failures،follow-up route mode،prefill،availability changes،409 recovery،successful removal/summary patch.
- Widget/golden: كل shimmer/empty/error/stale،320px/tablet/landscape،AR/EN وRTL/LTR،dark/light،textScale 2.0،Semantics/focus.
- فحص يمنع `CircularProgressIndicator`, `CupertinoActivityIndicator`, `RefreshIndicator` داخل feature ومسار الحجز في هذا mode.

## 13) Definition of Done

- القائمة وDashboard يعرضان نفس العدد وفق predicate واحد، مرتبة بالاستحقاق ومحسوبة بتوقيت الـtenant.
- لا يمكن إنشاء موعدين لنفس الزيارة حتى مع concurrency/retry، وكل حجز يمر بقواعد availability والتعارض والسعة.
- السعر والمريض والحالة وbooking type server-owned، ولا fallback عشوائي لخدمة، ولا PHI في logs/cache.
- إلغاء موعد متابعة يعيدها للقائمة وفق state rules؛ البيانات القديمة قابلة للفحص والإصلاح الآمن.
- route/Sidebar/API محمية بصلاحيات Follow-up، وFlutter ملتزم Clean Architecture بلا cross-import أو circular loading.
- جميع اختبارات Laravel وFlutter و`flutter analyze` تمر بلا errors أو warnings، ولا ملف يتجاوز 200 سطر.

## 14) تحسينات تحتاج موافقة منفصلة

- اتصال سريع بالمريض أو WhatsApp/SMS reminder بقوالب localized وموافقة privacy/audit وopt-out.
- نتيجة تواصل `reached/no_answer/call_later/refused` وجدولة callback؛ تحتاج schema وصلاحية وتقارير مستقلة.
- تنبيه SLA للحالات المتأخرة وbadge حي في Sidebar، بقيم إعدادات server-side لا hardcoded.
- اقتراح أول slot قريب تلقائيًا مع إبقاء القرار للمستخدم؛ لا auto-booking.
- شاشة history للمتابعات المجدولة/الملغية بدل الاقتصار على pending، كمرحلة منفصلة بفلترة وتدقيق.
