# خطة تنفيذ 2.1 — Reception Dashboard (لحظي)

> هذه الخطة موجهة إلى Gemini للتنفيذ داخل `CodraCare` (Laravel) و`medical_erp` (Flutter). المطلوب تنفيذها بالترتيب، وعدم القفز إلى الواجهة قبل تثبيت عقد الـAPI والاختبارات. أي اقتراح مذكور في قسم «تحسينات تحتاج موافقة» لا يُنفّذ ضمن 2.1 قبل موافقة صاحب المشروع.

## 1) الهدف ونطاق المرحلة

- استبدال Placeholder الخاص بمسار `/shell/reception` بشاشة `ReceptionDashboardScreen` حقيقية، سريعة ومناسبة للموبايل.
- عرض ملخص مواعيد اليوم: `scheduled`, `in_consultation`, `completed`, `cancelled`.
- عرض معاينة لحظية للطابور النشط فقط: `waiting` و`with_doctor`، مع فلتر طبيب.
- عرض إحصاءين سريعين: إجمالي المرضى الفريدين اليوم، والمتابعات المعلقة.
- المرحلة قراءة فقط: لا تضف check-in/call/complete/cancel أو حجز جديد قبل مراحلها المخصصة.
- كل حالات التحميل بلا استثناء Shimmer؛ ممنوع `CircularProgressIndicator` و`CupertinoActivityIndicator` و`RefreshIndicator` ذي المؤشر الدائري في هذه الشاشة.

## 2) نتائج مراجعة النظام الحالية (يجب أخذها كحقائق)

- endpoint المطلوب غير موجود حاليًا في `CodraCare/routes/api.php`، ومسار Flutter الحالي يعرض `PlaceholderShellContent`.
- Laravel يستخدم حالات المواعيد الأربع المطلوبة في `AppointmentStatus`، وحالات الطابور المطلوبة في `WaitingStatus`.
- الويب يعرض حتى 6 عناصر في معاينة الطابور؛ لذلك هذه الشاشة Dashboard وليست شاشة إدارة الطابور الكاملة.
- Flutter مجهز بـClean Architecture وCubit وGetIt وDio وGoRouter وEasyLocalization و`AppShimmer`/`AppShimmerBox`.
- `ApiClient.baseUrl` ينتهي بـ`/api/mobile`؛ لذلك endpoint داخل Flutter هو `/reception/dashboard` وليس `/api/mobile/reception/dashboard`.
- توجد فجوة في المواصفات: `total_patients_today` مطلوب في الـUI لكنه غير موجود في JSON المبدئي؛ إضافته إلزامية.
- `active_waiting_count` اسم قديم/ملتبس لكنه سيبقى للتوافق، وتعريفه النهائي: إجمالي `waiting + with_doctor` المطابق لفلتر الطبيب، وليس عدد `waiting` فقط.
- `AuthService::resolveRoleAndAccountType()` يرجع صلاحيات ثابتة لكل الحسابات حاليًا. هذا خرق أمني لقواعد المشروع، ولا يجوز الاعتماد عليه أو حماية الشاشة من Flutter فقط.

## 3) قرارات المنتج وعقد السلوك النهائي

- فلتر الطبيب يغيّر قسم Active Queue وعدّاده وقيم `doctors[].today_count` فقط؛ إحصاءات مواعيد اليوم والمرضى والمتابعات تظل على مستوى العيادة. هذا يطابق وضع الفلتر داخل قسم الطابور ويمنع تغيّر بطاقات أعلى الشاشة بشكل غير متوقع.
- بدون `doctor_id`: إرجاع كل الأطباء النشطين وكل الطابور النشط. إذا يوجد طبيب واحد فقط لا تفرض اختياره؛ يمكن للـUI إظهاره مختارًا بصريًا مع بقاء معنى البيانات واضحًا.
- `active_queue` معاينة بحد أقصى 6 عناصر، و`active_waiting_count` هو العدد الكامل. لا توجد pagination في Dashboard لأن القائمة bounded preview؛ شاشة الطابور الكاملة ستتولى pagination لاحقًا.
- ترتيب المعاينة: `with_doctor` أولًا، ثم `urgent`, ثم `vip`, ثم `normal`، ثم الأقدم حسب `entry_time`, ثم `id` لكسر التعادل.
- لا تعرض عناصر تاريخية عندما يكون طابور اليوم فارغًا. ألغِ fallback الموجود في Dashboard الويب الذي يجلب آخر عناصر من أيام سابقة لهذه الـAPI.
- تعريف «اليوم» من timezone الخاص بالـtenant/server، وليس ساعة الهاتف.
- `total_patients_today`: عدد `patient_id` الفريد في اتحاد مواعيد اليوم غير الملغاة وطابور اليوم بجميع حالاته، لمنع عد المريض مرتين إذا كان لديه موعد وqueue item.
- `pending_follow_ups_count`: زيارات `completed` التي لها `followup_days > 0` و`followup_scheduled_at IS NULL`، بنفس منطق `ReceptionFollowUpRepository`.
- `doctors[].today_count`: عدد عناصر الطابور النشطة اليوم للطبيب (`waiting + with_doctor`) حتى يكون الرقم مفيدًا داخل فلتر الطابور.

## 4) عقد الـAPI النهائي

`GET /api/mobile/reception/dashboard?doctor_id={nullable-int}`، داخل envelope القياسي للمشروع:

```json
{
  "success": true,
  "message": "Reception dashboard retrieved successfully",
  "data": {
    "appointments_today": {"scheduled": 5, "in_consultation": 1, "completed": 8, "cancelled": 2},
    "total_patients_today": 13,
    "active_queue": [{
      "id": 41, "ticket_number": "D3-004", "patient_id": 17, "patient_name": "...",
      "patient_phone": "...", "doctor_id": 3, "doctor_name": "...", "service_name": "...",
      "appointment_id": 91, "status": "waiting", "priority": "normal", "is_present": true,
      "entry_time": "2026-09-25T09:30:00+03:00", "called_time": null, "wait_minutes": 18
    }],
    "active_waiting_count": 3,
    "pending_follow_ups_count": 4,
    "doctors": [{"id": 3, "name": "...", "today_count": 2}],
    "selected_doctor_id": null,
    "generated_at": "2026-09-25T09:48:00+03:00",
    "capabilities": {"can_view_appointments": true, "can_view_queue": true, "can_view_follow_ups": true}
  }
}
```

- استخدم `snake_case` فقط. إن كان `todayCount` مستخدمًا بالفعل خارج هذا الفرع، يقبل Model في Flutter مؤقتًا `today_count ?? todayCount`، لكن Laravel يعيد `today_count`.
- الحقول الرقمية أعداد غير سالبة، والقوائم لا تكون `null`. الحقول الاختيارية فقط: الهاتف، الخدمة، `appointment_id`, `called_time`, `selected_doctor_id`.
- التوقيت ISO-8601 مع offset. `wait_minutes` يحسبه السيرفر ويُثبت عند صفر كحد أدنى؛ الـUI لا يحسب business values.
- doctor_id غير موجود/غير نشط داخل tenant يعيد 422 برسالة localized/آمنة، ولا يسقط إلى «كل الأطباء» بصمت.
- 401 للتوكن غير الصحيح، 403 لنقص الصلاحية، و500 برسالة عامة بلا exception/SQL/PHI.

## 5) Laravel — خطوات التنفيذ

1. أصلح tenant context للـMobile في middleware/service قابل لإعادة الاستخدام بدل نسخ `resolveDoctor`: تحقق من المستخدم و`tenant_code` والـtenant النشط، اتصل بقاعدة tenant، ثم طبّق الصلاحيات الفعلية.
2. أصلح `AuthService` كي يجلب role/permissions الحقيقية من tenant بعد الاتصال، بدل المصفوفة الثابتة. لا تمنح receptionist أو doctor صلاحيات افتراضية واسعة. أضف regression tests قبل تعديل السلوك.
3. أضف route تحت `Route::prefix('mobile')->middleware('auth:sanctum')` ثم `prefix('reception')`: `GET dashboard` باسم `mobile.reception.dashboard`.
4. أنشئ `app/Http/Controllers/V1/Reception/DashboardController.php`: رفيع، validation فقط، استدعاء service، وإرجاع `ApiResponseTrait`.
5. أنشئ `app/Services/Tenant/ReceptionDashboardService.php` لتجميع read model دون منطق داخل controller.
6. أنشئ `app/Repositories/Tenant/ReceptionDashboardRepository.php` لاستعلامات aggregates والطابور والأطباء والمتابعات. استخدم eager loading وselect للحقول المطلوبة فقط وتجنب N+1.
7. أنشئ Resources صغيرة (`ReceptionDashboardResource`, `ReceptionQueueItemResource`) أو transformer مخصص إن كان ذلك نمط المشروع المعتمد؛ لا ترجع Eloquent models مباشرة.
8. طبّق `reception.view` على endpoint. اجلب كل section فقط إذا كانت صلاحيتها موجودة: `reception.appointments.view`، `reception.queue.view`، والمتابعات إذا كان للمستخدم queue أو appointments view. أعد `capabilities` واجعل Flutter يخفي القسم غير المصرح بدل تسريب بياناته.
9. لا تعتمد على doctor_id القادم من العميل دون validation داخل tenant. لا تسجل أسماء/هواتف المرضى أو payload كامل في logs.
10. نفّذ counts باستعلامات aggregate محدودة، ولا تحمل كل السجلات إلى PHP. يجب أن يستخدم count والمعاينة نفس base query حتى لا يختلف الرقم عن العناصر.

## 6) Laravel — اختبارات إلزامية

- Feature test للـ200 وشكل envelope وكل المفاتيح والأنواع.
- counts لكل appointment status، وحساب unique patients بلا double count، والمتابعات بالتعريف أعلاه.
- الطابور يحتوي اليوم فقط وحالتي `waiting/with_doctor` فقط، بحد 6 وبالترتيب المحدد.
- doctor filter يعزل queue/count فقط ولا يغيّر clinic-wide stats، و`today_count` صحيح لكل طبيب.
- يوم بلا بيانات يعيد أصفارًا وقوائم فارغة، ولا يعيد بيانات قديمة.
- 401 بلا token، 403 بلا `reception.view`/صلاحية القسم، 422 لطبيب غير موجود أو غير نشط، وعزل كامل بين tenant A وtenant B.
- query-count assertion مع بيانات متعددة لاكتشاف N+1، واختبار عدم ظهور soft-deleted records.

## 7) Flutter — الهيكل والملفات

- Feature مستقل `lib/features/reception_dashboard/` بطبقات `data/domain/presentation`، ولا يستورد من `doctor_dashboard` أو `doctor_queue`.
- Domain entities صغيرة: `ReceptionDashboardEntity`, `AppointmentTodayStatsEntity`, `ReceptionQueueItemEntity`, `ReceptionDoctorSummaryEntity`, و`ReceptionDashboardCapabilitiesEntity`.
- Repository abstract: `getDashboard({int? doctorId}) -> Future<Either<Failure, ReceptionDashboardEntity>>`.
- Use case: `GetReceptionDashboardUseCase` مع params typed وEquatable؛ لا تمرر Map من Presentation.
- Data: models منفصلة وstrict parsing للحقول المطلوبة؛ لا تحول id مفقودًا إلى 0. RemoteDataSource يستخدم `ApiResponse<Map<String,dynamic>>` و`ReceptionEndpoints.dashboard` مع queryParameters عند وجود doctorId فقط.
- RepositoryImpl يحول Dio/exceptions إلى Failures المعتمدة، ولا يرسل raw exception للـUI.
- أضف `reception_dashboard_di.dart` واستدعِه من `app_di.dart`؛ lazy singletons للـdata/repository/use case وfactory للـCubit.
- أضف `ReceptionEndpoints.dashboard = '/reception/dashboard'`، واستبدل Placeholder في `app_router.dart` بـ`ReceptionDashboardScreen` مع guard account type + role + permission + ownership، وليس `isDoctor` فقط.
- أضف جميع النصوص تحت namespace `reception_dashboard` في `ar.json` و`en.json`، بلا نصوص user-facing hardcoded.
- كل ملف Dart أقل من 200 سطر؛ افصل AppBar/status grid/filter/queue section/card/empty/error/shimmer إلى widgets مستقلة.

## 8) Cubit وحالات البيانات

- الحالات immutable + Equatable: `Initial`, `Loading`, `Loaded`, `Error`؛ Loaded يحمل data وselectedDoctorId و`isQueueRefreshing` وrefresh warning اختياري.
- `load()` الأول يرسل Loading ثم Loaded/Error. `retry()` يعيد full shimmer.
- `selectDoctor(id)` يحتفظ بالإحصاءات الحالية، يرسل `isQueueRefreshing=true` لعرض shimmer داخل queue/filter فقط، ويستدعي الـAPI. استخدم request sequence/token لتجاهل response قديم إذا غيّر المستخدم الطبيب سريعًا.
- polling كل 30 ثانية لأن الشاشة لحظية: يبدأ بعد أول نجاح، لا يبدأ request جديدًا إذا السابق مستمر، يتوقف في background/`close()` ويعود عند foreground.
- background refresh وpull-to-refresh يبقيان البيانات الحالية؛ عند الفشل لا تستبدلها بشاشة Error، بل اعرض رسالة localized غير مزعجة وآخر وقت تحديث.
- فلترة وترتيب وقيم الإحصاءات تأتي من السيرفر؛ Cubit لا يعيد حساب domain data.

## 9) UI/UX النهائي

- Scaffold + AppBar بعنوان الاستقبال، تاريخ اليوم المحلي للعرض، وآخر تحديث من `generated_at` دون كشف بيانات حساسة.
- Phone: قائمة رأسية. Tablet/landscape: الإحصاءات في عمود/شبكة والطابور في مساحة أوسع باستخدام `ResponsiveUtils`/`LayoutBuilder`، لا breakpoint inline.
- «مواعيد اليوم»: شبكة 2×2 على الهاتف، 4 أعمدة على tablet، بأيقونة + label + count؛ scheduled أزرق، in consultation لون الحالة المعتمد، completed أخضر، cancelled أحمر، كلها من `AppColors`/theme.
- «إحصاءات سريعة»: بطاقتان للمرضى اليوم والمتابعات المعلقة. بطاقة المتابعات لا تكون tappable حتى يوجد route حقيقي.
- «الطابور النشط»: header به العدد الكامل، ثم فلتر الطبيب عبر `AppDropdown`/bottom sheet: «كل الأطباء» ثم الاسم و`today_count`. لا تستخدم chips طويلة تكسر عرض 320px.
- Queue card تعرض ticket، اسم المريض، الطبيب، الخدمة، الحالة، الأولوية، وقت الدخول/مدة الانتظار. أخفِ الهاتف من بطاقة الـDashboard لتقليل كشف PHI؛ لا توجد أزرار عمليات في 2.1.
- empty state يفرّق بين «لا يوجد طابور اليوم» و«لا يوجد مرضى لهذا الطبيب»، مع زر إعادة المحاولة/إزالة الفلتر بحجم لمس 48px.
- دعم RTL/LTR، text scaling، Semantics للأعداد والحالات، وعدم الاعتماد على اللون وحده.

## 10) سياسة التحميل — إلزامية

- Initial/retry: `ReceptionDashboardShimmer` يطابق الشكل الحقيقي: 4 status cards + 2 quick cards + filter + 3 queue cards.
- تغيير الطبيب: shimmer موضعي للفلتر/queue مع بقاء باقي الصفحة ثابتًا.
- استخدم `RefreshIndicator.noSpinner` إن كان مدعومًا في نسخة Flutter الحالية، مع shimmer strip أعلى المحتوى أثناء السحب/التحديث؛ وإلا نفّذ gesture/refresh action مخصصًا. ممنوع المؤشر الدائري حتى لو كان داخل Button.
- polling الصامت لا يعرض loader؛ لا تومض الشاشة ولا تعود إلى full shimmer.
- error initial: `AppErrorWidget` أو variant مناسب مع Retry؛ الضغط على Retry ينقل إلى shimmer. لا تعرض raw error.

## 11) Flutter tests والتحقق

- Model tests: payload كامل، null optionals، empty arrays، legacy `todayCount` إن لزم، ورفض missing/invalid required fields.
- DataSource test: endpoint الصحيح، عدم إرسال doctor_id عند null، وإرساله كرقم عند الاختيار، وفك envelope.
- Repository/UseCase tests لكل success وNetwork/Unauthorized/Forbidden/Validation/Server failures.
- Cubit tests: initial success/error، retry، selectDoctor، تجاهل response المتأخر، silent refresh يحافظ على data عند الفشل، timer/close بلا emit بعد الإغلاق.
- Widget tests على 320px وphone وtablet، عربي RTL وإنجليزي LTR، textScale مرتفع، empty/error/partial permissions، وعدم وجود أي `CircularProgressIndicator` في subtree.
- Golden/widget test للشاشة المحملة والـshimmer في light/dark إن كانت golden infrastructure متاحة؛ لا تضف dependency جديدة لأجلها.
- بعد التنفيذ: `dart format`، `flutter analyze` بلا warnings، اختبارات feature كاملة، ثم اختبارات Flutter الخاصة بالfeature وبعدها suite الحالي.

## 12) Definition of Done وتسليم Gemini

- عقد الـAPI موثق ومغطى باختبارات، والـresponse الفعلي يطابقه حرفيًا.
- الصلاحيات حقيقية على Laravel وFlutter؛ 403 واختفاء UI متوافقان، مع tenant isolation وعدم log للـPHI.
- route لم يعد Placeholder، وكل الحالات loading/success/empty/error/permission/refresh تعمل بلا مؤشر دائري.
- لا hardcoded endpoint/color/spacing/radius/icon/string/duration، لا cross-feature import، لا UI business logic، ولا ملف يتجاوز 200 سطر.
- لا تعدّل تغييرات المستخدم غير المرتبطة، ولا تعمل commit، وسلّم قائمة الملفات المعدلة ونتائج الأوامر والاختبارات وأي مخاطرة متبقية.

## 13) تحسينات تحتاج موافقة منفصلة

- WebSocket/SSE بدل polling لتحويل «لحظي» إلى push حقيقي؛ polling 30 ثانية هو baseline الآمن لهذه المرحلة.
- الضغط على بطاقة المتابعات لفتح قائمة follow-ups، والضغط على «عرض الكل» للطابور؛ يتطلبان routes/features مستقلة.
- تنبيه بصري/اهتزاز للحالات urgent الجديدة مع إعداد قابل للإغلاق، ومراعاة الخصوصية وعدم إظهار اسم المريض في notification lock screen.
- حفظ آخر snapshot مشفرًا للقراءة offline مع وسم «بيانات قديمة»؛ لا يُنفذ قبل تحديد سياسة TTL وownership بـclinic/branch/user.
