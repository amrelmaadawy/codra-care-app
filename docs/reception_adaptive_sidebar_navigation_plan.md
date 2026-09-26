# خطة تحويل Navigation الاستقبال إلى Adaptive Sidebar

> خطة موجهة إلى Gemini. نطاقها حسابات `Receptionist` و`ClinicAdmin` غير الطبية فقط. لا تغيّر تجربة الطبيب في نفس PR إلا لإزالة كود مشترك مكرر بأمان. الهدف ليس Drawer شكليًا، بل نظام Navigation واحد قابل للنمو ومتوافق مع الصلاحيات والـresponsive rules.

## 1) القرار UX النهائي

- أزل `AppBottomNavBar` بالكامل من Shell حساب الاستقبال؛ خمسة عناصر هي الحد الحالي والخصائص القادمة ستجعله غير صالح وقابلًا للكسر.
- الهاتف `< mobileMaxWidth`: استخدم Modal Sidebar عبر `Drawer` يفتح من زر Menu ثابت في AppBar، ويغلق بعد اختيار الوجهة.
- Tablet: Sidebar/Rail ثابت collapsed افتراضيًا بعرض design token، مع إمكانية التوسيع لإظهار labels إذا سمحت المساحة.
- Desktop/foldable wide: Sidebar ثابت extended، قابل للطي يدويًا، ويحفظ تفضيل الطي غير الحساس محليًا.
- لا تعرض routes غير منفذة أو Placeholder في القائمة. الوجهة تظهر فقط إذا كان route مسجلًا والميزة مفعلة والمستخدم مصرحًا له.
- deep links تفتح الشاشة الصحيحة ويظهر parent item محددًا حتى مع nested routes/query parameters.

## 2) مشاكل التنفيذ الحالي التي يجب إصلاحها

- `ShellNavItems` و`AppDrawer` يعرفان نفس الوجهات يدويًا؛ إضافة شاشة قد تظهر في واحد وتغيب من الآخر.
- `ShellNavItem` معرف داخل `bottom_nav_bar.dart` رغم أنه model عام للـShell، ما يخلق coupling غير صحيح.
- `AppShellScreen` يستخدم mobile items مختلفة عن rail items، ويكرر دوال selection/navigation.
- `AppNavRail` يحول `-1` إلى index صفر بـ`clamp`، وقد يحدد أول عنصر خطأ على route خارج القائمة.
- `AppDrawerHeader._formatName()` يضيف prefix الطبيب لكل المستخدمين، وfallback الدور هو `DOCTOR`; هذا خطأ لأكونت الاستقبال.
- القائمة الحالية مبنية على `isDoctor` فقط ولا تطبق permission + role + account type + feature availability لكل عنصر.
- بعض الشاشات ذات AppBar خاص قد لا تضمن Menu button للوصول إلى Sidebar على الهاتف.
- الألوان والمسافات والـwidths الجزئية داخل widgets تحتاج تجميعها في tokens بدل أرقام inline.

## 3) Information Architecture المقترحة للاستقبال

لا تُظهر عنصرًا قبل وجود route حقيقي. الترتيب النهائي القابل للنمو:

1. **العمل اليومي**
   - لوحة الاستقبال — `/shell/reception` — `reception.view`.
   - المواعيد — `/shell/appointments` — `reception.appointments.view`.
   - المرضى — `/shell/patients` — `patients.view` أو permission canonical المعتمدة.
   - طابور الانتظار — يظهر عند إنشاء شاشة الاستقبال الكاملة — `reception.queue.view`.
   - المتابعات — يظهر عند إنشاء route الخاص بها — appointments/queue view حسب policy.
2. **المالية**
   - التحصيل/المالية — `/shell/financial` — `billing.view` أو permission الفعلية بعد مراجعة backend.
3. **التقارير والإدارة**
   - التقارير — route فعلي فقط — `reports.view`.
   - الإعدادات — `/shell/settings` — permission إعدادات فعلية، وليس كل receptionist.
4. **الحساب**
   - الملف الشخصي — `/shell/profile`.
   - تسجيل الخروج — action منفصل destructive في footer، وليس route.

- Walk-in وAppointment New ليستا عناصر Sidebar؛ هما task routes تبدأ من Dashboard/Appointments ثم تعود للسياق السابق.
- لا تعرض badges وهمية. عند توفر unread/queue counts لاحقًا تُحقن كstate مستقلة دون إعادة بناء config.

## 4) مصدر Navigation موحد

أنشئ model عامًا داخل shell، مثل `ShellDestination`:

- `id` ثابت لا يعتمد على label.
- `route`, `labelKey`, `icon`, `selectedIcon`.
- `section` enum: dailyWork, finance, management, account.
- `allowedAccountTypes`, `allowedRoles`, `requiredAnyPermissions`, `requiredAllPermissions`.
- `matchPrefixes` لتحديد parent عند nested route.
- `featureFlag?`, `enabled`, و`sortOrder`.

أنشئ `ShellNavigationRegistry` كمصدر static immutable وحيد، ثم `ShellNavigationResolver` pure service يستقبل `PermissionService` والـfeature flags ويرجع sections/entries المرئية.

- Drawer وRail وExtended Sidebar يرسمون نفس resolved list؛ ممنوع تعريف routes داخل widgets.
- لا تستورد Presentation widgets داخل model/config.
- `PermissionService` يظل abstraction القراءة؛ لا business logic أو hardcoded user emails داخل navigation.
- unknown account type لا يرى reception navigation؛ يوجّه إلى unauthorized/fallback آمن بدل منحه قائمة افتراضية.

## 5) Responsive behavior

- استخدم `ResponsiveUtils.of(context)` فقط، ولا تكتب `width >= 600` داخل Shell.
- Mobile: `Scaffold.drawer` بعرض token مناسب لا يتجاوز مساحة آمنة على 320px، gesture opening حسب platform، وscrim واضح.
- Tablet: collapsed sidebar يعرض icons + tooltips وselected indicator؛ زر expand/collapse بحجم لمس 48px.
- Desktop: extended sidebar يعرض icon + label + section headings، ويبقى ثابتًا أثناء تبديل child routes.
- RTL: Sidebar على جهة البداية تلقائيًا باستخدام `Drawer` و`EdgeInsetsDirectional` و`BorderDirectional`; لا hardcode right/left.
- عند landscape قصير الارتفاع، body القائمة scrollable بينما header/footer ثابتان أو محسوبا المساحة بلا overflow.
- طي/فتح Sidebar animation من `AppDurations`، ويحترم `MediaQuery.disableAnimations`.

## 6) تصميم Sidebar

- Header: شعار العيادة/التطبيق، اسم المستخدم، role مترجم (`Receptionist/Clinic Admin`) وصورة آمنة؛ ممنوع doctor prefix/fallback.
- Sections بعناوين localized خفيفة، وتُخفى section كاملة إذا لم يبق فيها عناصر.
- Destination: ارتفاع لمس ≥48، icon واضح، label سطر واحد، selected state باستخدام background + icon/weight + indicator، لا اللون وحده.
- Footer: Profile اختياري ضمن Account section، theme/language إن كانت flows موجودة، ثم Logout destructive مع confirmation حسب النمط الحالي.
- dark/light theme من `ThemeExtensions`; لا `Colors.black`, أبعاد، shadows أو radius hardcoded. أضف tokens فقط عند غيابها وبعد مراجعة core.
- استخدم logo asset الموجود ولا تضف asset جديدًا بلا حاجة.

## 7) Shell/AppBar behavior

- `AppShellScreen` يحسب layout مرة من breakpoint + account type ثم يبني mobile drawer أو persistent sidebar.
- على Mobile، لا يوجد `bottomNavigationBar` لحساب الاستقبال؛ أعطِ body المساحة كاملة مع SafeArea الصحيحة.
- كل root screen داخل reception shell يجب أن تعرض `ShellMenuButton` موحدًا في AppBar. الشاشات ذات AppBar خاص تستخدم `AppShellScope.openDrawer` ولا تنشئ drawer خاصًا.
- screens خارج Shell مثل Walk-in/New Appointment تعرض Back وليس Menu، وتعود للمصدر باستخدام GoRouter فقط.
- route title يأتي من destination registry أو route metadata، وليس Map منفصلًا في `AppShellScreen`.
- navigation تستخدم `context.go(destination.route)`؛ إغلاق Drawer إجراء UI فقط ثم navigation، ولا `Navigator.push`.
- عند الضغط على الوجهة الحالية: أغلق Drawer فقط، ولا تعيد إنشاء route/cubit أو request.
- selected matching يقارن `matchedLocation/path` دون query string، ويختار أطول `matchPrefix` لمنع parent خاطئ.

## 8) حفظ حالة Sidebar

- حالة expanded/collapsed تخص UI وليست global mutable state. استخدم `ShellNavigationCubit` صغيرًا أو local state إذا لم يحتجها أكثر من Shell.
- احفظ فقط boolean غير حساس عبر abstraction storage، لا وصول مباشر من UI. Namespace بالقيمة العامة للتطبيق، ولا تخزن patient/tenant data معه.
- عند تغيير breakpoint: Mobile يتجاهل persisted extended state؛ Tablet/Desktop يستعيده ضمن قيود المساحة.
- route selection مصدره GoRouter فقط، وليس index مخزنًا؛ بذلك deep links وback navigation يظلان صحيحين.

## 9) الصلاحيات والأمان

- كل destination يمر عبر resolver: account type + role + permission + feature availability.
- `ClinicAdmin` لا يرث تلقائيًا كل العناصر إلا إذا backend permissions تؤكد ذلك.
- إخفاء العنصر ليس حماية؛ GoRouter guard والـAPI يرفضان الوصول المباشر بـ403.
- إذا فقد المستخدم permission بعد login/refresh، أعد resolve للقائمة، وإن كانت الصفحة الحالية غير مسموحة وجّهه لأول route مصرح به.
- first accessible route يُحسب من نفس registry، بدل hardcode `isDoctor ? dashboard : reception` فقط.
- لا تعرض counts أو أسماء مرضى في Sidebar؛ badges مستقبلًا تكون أرقامًا إجمالية غير حساسة.

## 10) الملفات والتعديلات المقترحة

- إنشاء `features/shell/domain/entities/shell_destination.dart` و`navigation_section.dart`.
- إنشاء `features/shell/domain/services/shell_navigation_resolver.dart` وregistry مناسب داخل shell config/domain.
- إنشاء widgets صغيرة: `adaptive_sidebar.dart`, `sidebar_header.dart`, `sidebar_section.dart`, `sidebar_destination_tile.dart`, `sidebar_footer.dart`, `shell_menu_button.dart`.
- refactor `app_shell_screen.dart` ليبقى orchestrator أقل من 200 سطر.
- تحويل `nav_rail.dart` إلى presentation للـsame destinations أو دمجه داخل adaptive sidebar دون تكرار.
- إزالة receptionist usage ثم حذف `bottom_nav_bar.dart` فقط إذا لم يعد الطبيب يحتاجه؛ إن ظل الطبيب يستخدمه، انقل `ShellNavItem` خارجه وأعد تسميته/تكييفه.
- استبدال محتوى `shell_nav_items.dart` بالregistry أو حذفه بعد migration.
- refactor `app_drawer.dart/header/tile` أو استبدالها بالـsidebar widgets مع الحفاظ على تجربة الطبيب حتى تُراجع.
- تحديث `app_router.dart`, route guards، localization ar/en، design tokens اللازمة، واختبارات shell.

## 11) خطة Migration آمنة

1. اكتب tests للـresolver والـroute matching على السلوك المتوقع قبل تعديل UI.
2. أنشئ registry/resolver وحوّل AppDrawer أولًا ليقرأ منه مع feature flag مؤقت.
3. أنشئ Adaptive Sidebar للـTablet/Desktop من نفس المصدر وقارن جميع routes والصلاحيات.
4. فعّل Mobile Drawer للاستقبال وأزل BottomNav له فقط.
5. أصلح AppBars لضمان Menu access في كل root reception screen.
6. أزل القوائم/Maps المكررة بعد إثبات عدم وجود route مفقود.
7. لا تغيّر الطبيب أو routing features الأخرى إلا بما تغطيه tests.

## 12) حالات التحميل والخطأ

- navigation المبنية من auth/permissions المحلية تظهر فورًا بلا loading.
- إذا أصبحت permissions/feature flags remote لاحقًا، استخدم `SidebarShimmer` يطابق header وsection tiles؛ ممنوع CircularProgressIndicator.
- أثناء logout: عطّل footer action واعرض shimmer صغير داخل مساحة الـtile؛ لا spinner.
- فشل تحديث permissions يحتفظ بآخر قائمة آمنة أو يعرض retry state localized؛ لا يعرض raw error.
- Sidebar نفسه لا يعاد بناؤه عند loading بيانات الشاشة الداخلية؛ افصل rebuild scopes باستخدام selectors.

## 13) Accessibility وUX details

- `Semantics(button:true, selected:...)` لكل destination، وترتيب focus مطابق للترتيب المرئي.
- keyboard navigation وEnter/Space على tablet/desktop، وtooltips في collapsed mode.
- contrast مطابق للثيم، touch target 48px، text scaling حتى 200% بلا overflow أو إخفاء logout.
- focus يعود بشكل منطقي للمحتوى بعد اختيار destination، والـDrawer يغلق قبل إعلان عنوان الصفحة لقارئ الشاشة.
- logout وdestinations destructive لا تعتمد على اللون وحده.

## 14) الاختبارات الإلزامية

- Unit: resolver لكل account type/role/permission combinations، empty sections، feature flags، unknown account، first accessible route.
- Unit: longest-prefix route matching، nested routes، query parameters، no match بلا تحديد أول عنصر كذبًا.
- Widget عند 320px: لا BottomNav للاستقبال، Menu ظاهر، Drawer يفتح، navigation تغلقه، ولا overflow.
- Widget tablet/desktop: collapsed/extended behavior، RTL placement، persistent state، keyboard/tooltips.
- permission tests: hidden destinations، direct-route guard، permission removal أثناء session.
- doctor regression: قائمة الطبيب الحالية لم تتغير إلا إذا كان ذلك مقصودًا ومغطى.
- light/dark + ar/en + textScale 2.0 + landscape، وعدم وجود `CircularProgressIndicator`/`CupertinoActivityIndicator` في Sidebar loading subtree.
- `flutter analyze` بلا warning، shell tests، ثم full Flutter suite.

## 15) Definition of Done

- حساب الاستقبال لا يعرض BottomNav على الهاتف، ويملك Sidebar سهلة الوصول وقابلة للنمو على كل المقاسات.
- مصدر واحد فقط للوجهات والعناوين والصلاحيات والـselected matching؛ لا route lists مكررة.
- لا destination ميتة أو Placeholder أو غير مصرح بها، وdirect access محمي بالـrouter/API.
- Header يعرض Receptionist/ClinicAdmin بصورة صحيحة ولا يستخدم doctor-specific strings.
- RTL/LTR، dark/light، 320px، tablet، foldable/desktop، keyboard وtext scaling تعمل دون overflow.
- لا hardcoded UI values/strings/routes خارج مصادرها، لا ملف فوق 200 سطر، لا circular loading، ولا regressions.

## 16) تحسينات تحتاج موافقة منفصلة

- تحويل الطبيب أيضًا من BottomNav إلى نفس Adaptive Sidebar لتوحيد التطبيق بالكامل؛ يفضّل PR مستقل بعد نجاح استقبال.
- pinned favorites أو ترتيب العناصر حسب المستخدم؛ لا تبدأ بها قبل استقرار القائمة الأساسية.
- global command/search داخل Sidebar للوصول السريع للمرضى والمواعيد؛ يحتاج privacy-aware search وdebounce/audit.
- badges لحظية للطابور والمتابعات؛ تتطلب مصدر counts مركزيًا وسياسة polling/push دون PHI.
