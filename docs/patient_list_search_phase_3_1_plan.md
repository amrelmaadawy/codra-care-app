# خطة تنفيذ 3.1 — Patient List & Search

> وثيقة تنفيذ موجّهة إلى Gemini بعد مراجعة Laravel وFlutter الحاليين. الالتزام بـ`.agents/rules/rules.md` إلزامي، وكل حالة انتظار تكون Shimmer فقط؛ ممنوع `CircularProgressIndicator` و`RefreshIndicator` الافتراضي وأي spinner.

## 1) الهدف والنطاق

- إنشاء `PatientListScreen` للاستقبال ومدير العيادة لعرض قائمة مرضى الـtenant والبحث والتحميل المتدرج عبر `GET /api/mobile/patients?search=&page=`.
- العنصر المعتمد: `{id, code, name, phone, gender, age, lastVisitDate}`؛ الحقول الاختيارية هي `phone/gender/age/lastVisitDate` فقط، ولا تُستبدل قيم JSON التالفة بأصفار أو نصوص فارغة.
- القائمة read-only في 3.1. إنشاء/تعديل/حذف المريض، الملف الطبي، المعاملات المالية، والفلاتر المتقدمة خارج النطاق.
- لا تجعل الكارت tappable ولا تعرض chevron حتى تنفيذ شاشة تفاصيل عامة مصرح بها؛ المسار الحالي `/patients/:id` يفتح تفاصيل الطبيب ولا يصلح للاستقبال.
- مصدر الحقيقة هو Laravel. العمر و«آخر زيارة» والترتيب والصلاحيات تُحسب في الخادم، لا في Flutter.

## 2) نتائج مراجعة النظام الحالي — Blockers قبل Flutter

- endpoint المطلوب `/api/mobile/patients` غير موجود؛ الموجود `/api/mobile/doctor/patients` ومصمم أساسًا لسجل الطبيب.
- `/shell/patients` يبني حاليًا `DoctorPatientListScreen` لكل الحسابات، لذلك الاستقبال يستعمل Cubit وendpoint الطبيب بالخطأ.
- `PatientApiController` الحالي يسمح لبعض حسابات الاستقبال ثم يمرر `doctor=null`؛ وهذا يوسّع النطاق ضمنيًا إلى كل مرضى العيادة. افصل المسارين ولا تعتمد هذا السلوك.
- `patients.view` مستخدمة في Flutter و`ReceptionTestAccountSeeder` لكنها غير موجودة في الكتالوج الرسمي `config/tenant_permissions.php`. لا تبدأ UI قبل توحيدها.
- `reception.patients.lookup` صلاحية بحث سريع أثناء الحجز، وليست بديلًا عن عرض دليل المرضى كاملًا.
- Web repository يبحث في الاسم والكود والرقم القومي والهاتفين لكنه يحمل `medicalHistory` و`appointments` بلا حاجة للقائمة، ولا يعيد `lastVisitDate`.
- شاشة الطبيب الحالية تحتوي `RefreshIndicator`، وfallbacks مثل `id=0` عند JSON غير صالح، ولا يجوز نسخ هذه السلوكيات للشاشة الجديدة.
- `patients` داخل قاعدة tenant ولا يحتوي `branch_id`. الـtenant isolation متاح، لكن branch isolation غير قابل للتنفيذ من البيانات الحالية؛ احسم هل كل tenant يمثل عيادة واحدة. إن كانت المنشأة متعددة الفروع فإضافة branch ownership وترحيل البيانات شرط سابق.

## 3) الصلاحيات والعزل

- أضف `patients.view` كقيمة canonical في `tenant_permissions.php` تحت «إدارة المرضى»، وحدّث seeding/sync واختبارات الكتالوج. أبقِ `reception.patients.lookup` مستقلة.
- endpoint العام يقبل فقط مستخدمًا authenticated، tenant نشطًا، و`patients.view` أو tenant/super admin. لا تمنح الصلاحية اعتمادًا على اسم الدور فقط.
- الطبيب يستمر على `/mobile/doctor/patients` ونطاق مرضاه فقط؛ الاستقبال/مدير العيادة يستخدم `/mobile/patients`. لا يوجد fallback من أحدهما للآخر.
- Flutter sidebar والroute guard والخادم يطبقون نفس الصلاحية. إخفاء destination ليس حماية؛ 403 مطلوب عند الوصول المباشر.
- soft-deleted patients/visits لا تظهر. لا cross-tenant IDs، ولا national ID أو ملاحظات أو تاريخ مرضي في response.
- لا تخزن القائمة أو عبارة البحث في persistent storage، ولا تسجل الاسم/الهاتف/النتائج/SQL bindings في logs أو analytics.

## 4) عقد Laravel المعتمد

- Route داخل `mobile` مع `auth:sanctum`, `mobile.tenant` وthrottle مناسب: `GET /api/mobile/patients`.
- Query عبر `ListPatientsRequest`: `search nullable|string|max:100` بعد trim، و`page nullable|integer|min:1`. حجم الصفحة ثابت 20 في 3.1 لتجنب client-controlled payloads.
- البحث الفارغ يعرض الصفحة الأولى. Flutter لا يرسل بحثًا بطول حرف واحد؛ يعرض hint، ويبدأ من حرفين.
- البحث يطابق `full_name`, `patient_code`, `national_id`, `phone`, `secondary_phone` دون إرجاع الحقول الحساسة غير الموجودة في entity.
- استخدم `PhoneNormalizer` لدعم الأرقام العربية و`+20/0020`، وescape حرفي `%`, `_`, `\\` في LIKE. طبّع المسافات ولا تبنِ SQL نصيًا.
- `lastVisitDate` = أحدث `visit_date` لزيارة فعلية غير محذوفة، بنفس تعريف النظام الحالي سواء `in_progress` أو `completed`؛ `null` إذا لم توجد زيارة.
- `age` يحسب من `date_of_birth` في timezone المنشأة ويعود integer nullable. لا تُرجع `lastVisitDateHuman` لأن صياغته localized داخل Flutter.
- الترتيب ثابت: `last_visit_date DESC NULLS LAST` ثم `id DESC`. طبّق صيغة متوافقة مع محرك قاعدة البيانات بدل SQL خاص غير محمول.
- استخدم select للحقول اللازمة + `withMax('visits', 'visit_date')` أو subquery واحدة؛ ممنوع N+1 وتحميل medical history/appointments.
- أضف composite index لـ`visits(patient_id, visit_date, id)` فقط بعد فحص migration الحالية و`EXPLAIN`; لا تضف migration مكررة.

```json
{
  "success": true,
  "message": "patients.list_loaded",
  "data": {
    "items": [{"id": 12, "code": "PAT-0012", "name": "...", "phone": "010...", "gender": "female", "age": 31, "last_visit_date": "2026-09-20"}],
    "meta": {"current_page": 1, "last_page": 4, "per_page": 20, "total": 73, "has_more": true}
  }
}
```

- القيم البرمجية ثابتة: `gender = male|female|null` والتاريخ `YYYY-MM-DD`. يحافظ JSON على snake_case المتبع في API الحالي، ويحوّله model صراحة إلى `lastVisitDate/currentPage/...` في Dart؛ النصوص المترجمة لا تدخل في model.
- الأخطاء: 401/403/422/429/500 داخل envelope الموحد مع message key عام؛ لا ترجع `$e->getMessage()` أو stack trace أو query.

## 5) Laravel structure وترتيب التنفيذ

1. أضف characterization tests للسلوك الحالي ثم أصلح كتالوج `patients.view` ومزامنة صلاحيات tenants.
2. أنشئ `V1/Patient/ListPatientsRequest`, resource وcontroller رفيعًا؛ request يتولى authorization/validation وresource وحده يثبت JSON shape.
3. أضف method مخصصة في طبقة Repository/Service لقائمة الموبايل، ولا تعِد استخدام query الويب الثقيلة أو `PatientRecordsRepository` الخاص بالطبيب.
4. سجّل route العام قبل أي parameterized patient route، وطبّق tenant middleware + permission + throttling.
5. أصلح `Doctor PatientApiController` بحيث لا يقبل reception كطريق بديل؛ لا تغيّر عقد الطبيب المرئي دون اختبارات regression.
6. شغّل formatter وLaravel targeted tests ثم suite ذات الصلة قبل بدء Flutter.

## 6) Flutter Clean Architecture

- أنشئ feature مستقلة `features/patient_management/` بطبقات `data/domain/presentation` وDI مستقل. ممنوع import من `doctor_patients` أو `reception_booking`.
- Domain: `PatientListEntity`, `PatientPageEntity`, typed `PatientListQuery(search,page)`, repository abstract، و`GetPatientsUseCase` يعيد `Either<Failure, PatientPageEntity>`.
- Data: `PatientListModel`, `PatientPageModel`, remote data source عبر `ApiClient/Dio` و`PatientEndpoints`, ثم repository impl. parsing required fields صارم، وunknown gender يعرض unknown ولا ينهار.
- Presentation: `PatientListCubit` وEquatable states تحمل items/query/pagination/refresh/load-more failure. Cubit factory عبر get_it، ولا network/JSON/DI يدوي من UI.
- قسّم screen/widgets/cubit/models بحيث كل ملف أقل من 200 سطر. استخدم ثوابت theme/breakpoints/debounce/page threshold؛ لا magic values أو hardcoded endpoint/UI strings.
- لا تنقل entity خاصة بميزة إلى `core`. إن تكرر presentational primitive حقيقي، استخرج widget عام لا يعتمد على feature entity بعد مراجعة الاستخدامين.

## 7) Router والـuser flow

- في `AppRoutes.patients` اختر حسب account context: doctor → شاشة الطبيب الحالية؛ receptionist/clinic_admin مع `patients.view` → `PatientListScreen`; غير ذلك → redirect لأول destination مسموحة/403 screen وفق router policy.
- أنشئ `PatientListCubit` داخل route بـ`BlocProvider` ثم `loadInitial()` مرة واحدة. لا تسجل Cubit كsingleton.
- عند دخول الشاشة: shimmer مطابق للكروت → success/empty/error. الرجوع من شاشة أخرى يحافظ على القائمة والـscroll ما دام shell branch حيًا.
- search: trim + debounce ثابت 350–400ms، حرف واحد لا يرسل request، clear يلغي المؤقت والطلب ويعيد الصفحة الأولى.
- استخدم Dio `CancelToken` أو request generation id؛ response قديم لا يكتب فوق query أحدث. pagination مرتبطة بنفس query وتدمج بالـid دون تكرار.
- load-more قرب نهاية القائمة مرة واحدة فقط. فشله يبقي العناصر ويعرض inline retry؛ لا يحول الشاشة كلها إلى error.
- refresh بزر واضح في app bar؛ أثناءه استخدم shimmer مناسب مع منع النقرات المتكررة. لا تستخدم `RefreshIndicator` لأنه يعرض مؤشرًا دائريًا.

## 8) تصميم `PatientListScreen`

- App bar داخل shell: «المرضى» + total من meta بعد التحميل + refresh semantics. لا زر إضافة في 3.1 حتى يوجد flow وصلاحية canonical له.
- شريط بحث مثبت أسفل العنوان: hint «الاسم، الكود، الهاتف أو الرقم القومي»، زر clear، keyboard search، و48px touch target.
- الهاتف 320–599px: قائمة cards بعمود واحد. العرض الأكبر: عمودان عند توفر عرض فعلي بعد sidebar، مع max content width واتجاه قراءة صحيح.
- الكارت: avatar initials محايد، الاسم سطران كحد أقصى، code badge، الهاتف `Directionality.ltr`، gender كنص localized، العمر، وآخر زيارة/«لا توجد زيارات».
- اللون لا يكون الوسيلة الوحيدة للجنس أو الحالة، ولا تستخدم pink/blue كدلالة أساسية. القيم null تعرض localized «غير مسجل» دون شرطة غامضة.
- لا تعرض national ID أو medical alerts أو insurance في هذه المرحلة؛ المطابقة في البحث لا تعني كشف القيمة.
- الحالات: initial shimmer، search shimmer، pagination card shimmer، empty clinic، no search results مع clear، full error مع retry، inline pagination error، وoffline message.
- البحث الجديد يمكنه إبقاء header/query ثابتين، لكن منطقة النتائج تتحول إلى skeletons بدل spinner. لا تعرض بيانات query قديمة على أنها نتيجة query جديدة.
- دعم AR/EN وRTL/LTR وdark/light وtextScale 2.0 وlandscape، keyboard dismissal، Semantics واضحة، وترتيب focus منطقي.

## 9) ملفات متوقعة

- Laravel: route، `ListPatientsRequest`, `PatientListResource`, mobile patient controller، service/repository method، permission catalog/sync، واختبارات Feature/Unit.
- Flutter: `patient_management_di.dart`; endpoints; data source/models/repository; entities/query/repository/use case; cubit/state; screen + app bar/search/card/shimmers/empty/error widgets.
- عدّل `app_shell_routes.dart`, `app_di.dart`, `app_permissions.dart` عند الحاجة، وملفات `ar.json/en.json`. لا تكرر مفاتيح `doctor_patients.*` للشاشة العامة.

## 10) الاختبارات الإلزامية

- Laravel: unauthenticated 401، wrong permission 403، admin/`patients.view` success، lookup وحدها لا تكفي، tenant isolation، suspended tenant، soft deletes.
- البحث بالاسم العربي/الكود/الرقم القومي/الهاتف العربي و`+20/0020`، المسافات، `%/_/\\` كقيم حرفية، max length وpage invalid.
- age null/صحيح، patient بلا زيارة، آخر زيارة صحيحة، stable ordering والتعادل، pagination بلا تكرار/فقد، response shape/types، query count يمنع N+1.
- regression: الطبيب يرى مرضاه فقط، والاستقبال لا يصل إلى doctor endpoint/detail، والـweb patients page لا تنكسر.
- Flutter: strict model parsing، nullable fields/date، query equality، repository failure mapping، use case validation.
- Cubit: initial/search debounce/clear/cancel stale response/load more/dedup/end page/retry/close timer، وعدم إطلاق طلب لحرف واحد.
- Widget/golden: كل الحالات السابقة على 320px/tablet/landscape، AR/EN، RTL/LTR، dark/light، textScale 2.0، scroll/focus/semantics.
- route/permission tests للطبيب والاستقبال والمدير والمستخدم غير المصرح، واختبار source يمنع `CircularProgressIndicator` و`RefreshIndicator` في feature الجديدة.
- بوابة التسليم: `dart format`, `flutter analyze` بلا warnings، اختبارات feature ثم Flutter suite، واختبارات Laravel المستهدفة ثم suite ذات الصلة.

## 11) Definition of Done

- endpoint العام مفصول عن الطبيب، مصرح بـ`patients.view` canonical، ومعزول tenant/branch حسب القرار الموثق، ولا يسرّب PHI أو raw errors.
- القائمة paginated، البحث دقيق وثابت وآمن، `age/lastVisitDate` من Laravel، ولا N+1 أو تحميل علاقات غير مطلوبة.
- account الصحيح يصل للشاشة الصحيحة، ولا cross-feature imports أو route لتفاصيل الطبيب من الاستقبال.
- كل loading shimmer فقط، وكل empty/error/offline/pagination states قابلة للتعافي ولا تفقد query بلا سبب.
- responsive/localized/accessible، كل ملف أقل من 200 سطر، ولا hardcoded UI/endpoints أو dead code.
- Laravel وFlutter tests وanalyze تمر بلا errors أو warnings، مع مراجعة يدوية على حساب receptionist فعلي وحساب doctor فعلي وtenant آخر.

## 12) تحسينات مقترحة تحتاج موافقة منفصلة

- فلاتر gender/آخر زيارة/لم يزر بعد + sort bottom sheet، مع query contract واختبارات جديدة.
- زر اتصال سريع مع صلاحية مستقلة وإخفاء/Mask الهاتف للمستخدمين غير المصرح لهم.
- مسح QR/barcode لكود المريض، مع إدخال search فقط وعدم تخزين الصورة.
- إنشاء مريض سريع مع duplicate detection بالهاتف/الرقم القومي؛ ينفذ في مرحلة مستقلة ولا يضاف كزر معطل.
- in-session recent searches فقط؛ لا persistent history لأنها PHI. دعم full-text/normalized Arabic columns يؤجل حتى قياس حجم البيانات وأداء LIKE.
