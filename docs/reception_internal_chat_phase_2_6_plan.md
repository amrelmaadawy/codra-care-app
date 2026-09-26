# خطة تنفيذ 2.6 — Reception Internal Chat

> وثيقة تنفيذ موجهة إلى Gemini. المطلوب هو نفس محادثات 1.11 والبيانات الحالية، لكن بمنظور الاستقبال متعدد الأطباء. تُنفّذ بعد الـAdaptive Sidebar، مع الالتزام الكامل بـ`.agents/rules/rules.md`. التحسينات في القسم الأخير تحتاج موافقة منفصلة.

## 1) الهدف والنطاق

- إنشاء `ReceptionInternalChatScreen` لعرض محادثات أطباء المنشأة، البحث فيها، متابعة unread، فتح محادثة، تحميل التاريخ، الإرسال، وإثبات القراءة.
- الاستقبال يرى عدة conversations، والطبيب يرى conversation واحدة؛ الطرفان يستخدمان نفس `doctor_chats` و`doctor_chat_messages`، وليس جداول أو رسائل منفصلة.
- المرحلة نصية فقط. خارج النطاق: المرفقات، الصوت، حذف/تعديل الرسالة، groups، patient-context links، reactions وtyping indicator.
- كل loading هو Shimmer فقط: قائمة المحادثات، bubbles، تحميل الأقدم، unread badge والحفظ. ممنوع `CircularProgressIndicator`, `CupertinoActivityIndicator` و`RefreshIndicator` الافتراضي.

## 2) نتائج مراجعة النظام الحالي

- قاعدة البيانات تضمن conversation واحدة لكل doctor، والرسالة تحمل `sender_type=doctor|reception`, sender snapshot، read status وtimestamps.
- Laravel يدعم أحدث 50 رسالة، `before_id` داخليًا، polling بـ`after_id`، counters للطبيب والاستقبال وmark-read، لكن Mobile API موجود للطبيب فقط.
- Reception Web يحمّل كل الأطباء بلا pagination، وينشئ chat records داخل GET لكل طبيب نشط؛ ذلك write amplification ولا يناسب التوسع.
- Web يسمح بالدخول بـ`reception.view` فقط رغم وجود `messages.view/create`، ويرجع raw exception text عند فشل الإرسال.
- Poll قد يعيد عددًا غير محدود من الرسائل بعد `after_id`، ويعتمد على `is_active` من العميل لتغيير read state؛ GET polling يجب أن يبقى read-only.
- send لا يملك idempotency؛ timeout ثم retry قد ينشئ رسالتين. counters وmark-all-read يمكن أن تتسابق مع رسالة داخلة فتظهر unread values غير صحيحة.
- API resources ترجع أوقاتًا display-formatted و`human_time` بالعربية بدل ISO locale-neutral، و`sender_id` nullable بينما Flutter الحالي يحوله إلى صفر.
- Flutter Doctor Chat لا يحمل الرسائل الأقدم، وقد تتداخل polling requests، ويستمر timer بالخلفية رغم تغيير `is_active`.
- Doctor UI الحالي يحتوي ألوانًا/أحجامًا/durations ونص `just now` hardcoded، وbusiness validation داخل widget؛ لا يُنسخ قبل refactor.

## 3) قرارات المجال والأمان

- صلاحية فتح/list/read: `messages.view`. صلاحية الإرسال: `messages.create`. لا تستخدم `reception.view` كبديل أمني؛ account type/role/tenant/permission كلها مطلوبة.
- `is_read` يعني أن الطرف المقابل قرأ الرسالة: رسالة reception تُقرأ بواسطة الطبيب، ورسالة doctor تُقرأ بواسطة فريق الاستقبال ككل، وليس لكل موظف على حدة.
- inactive doctor: تبقى المحادثة التاريخية ظاهرة إذا لها رسائل/unread، لكن الإرسال يُعطل في UI ويرفض API بـ409. الأطباء النشطون بلا رسائل يظهرون لبدء محادثة.
- لا تُرجع patient/visit/medical data تلقائيًا ولا تدعم deep links خام داخل النص. الرسالة قد تحتوي PHI؛ لا persistent cache، لا analytics content، ولا body داخل push notification.
- logs/audit تسجل actor/chat/message id/action/timestamp فقط، بلا نص الرسالة أو sender name. الاتصالات HTTPS وtenant isolation إلزاميان.
- rate limit للإرسال حسب tenant + actor + chat، مع حد 2000 Unicode character وtrim/empty validation في Request وDomain. قاعدة “أرقام فقط” الحالية تبقى مؤقتًا؛ تغييرها يحتاج قرار منتج.

## 4) API تحت Reception prefix

Base: `/api/mobile/reception/internal-chat/`

- `GET chats?search=&status=active|inactive|all&page=&per_page=`: قائمة conversations paginated؛ default all حتى لا تُخفى محادثة تاريخية أو unread لطبيب غير نشط، وper page 20 وأقصى 50.
- `GET chats/{chatId}?before_id=&limit=`: chat metadata + أحدث/أقدم page، limit افتراضي 50 وأقصى 100؛ لا يغيّر read state.
- `GET chats/{chatId}/poll?after_id=&limit=`: رسائل أحدث فقط، أقصى 100، مع `has_more`; GET read-only.
- `POST chats/{chatId}/send`: إرسال استقبال.
- `POST chats/{chatId}/read`: تعليم رسائل doctor بالقراءة حتى cursor محدد.
- `GET unread-count`: إجمالي unread للاستقبال لاستخدام الشاشة والـSidebar badge.

### List response

```json
{"data":[{"id":9,"doctor":{"id":2,"name":"...","specialization":"...","photo_url":null,"is_active":true},"last_message":{"preview":"...","sender_type":"doctor","created_at":"ISO-8601"},"unread_count":3,"capabilities":{"can_view":true,"can_send":true}}],"meta":{"current_page":1,"last_page":1,"per_page":20,"total":1,"has_more":false},"total_unread":3,"generated_at":"ISO-8601"}
```

- sort: unread conversations أولًا، ثم `last_message_at DESC`، ثم doctor name/id ثابتًا. search على الاسم والتخصص فقط، بطول محدود وdebounce 350ms.
- لا تنشئ chats داخل GET. أنشئها عند doctor creation، migration backfill، أو atomically عند فتح/إرسال أول محادثة.

### Conversation and message contract

```json
{"chat":{"id":9,"doctor":{},"unread_count":0,"capabilities":{}},"messages":[{"id":44,"client_message_id":null,"sender":{"id":7,"name":"...","type":"doctor"},"body":"...","is_read":false,"read_at":null,"created_at":"ISO-8601"}],"page":{"next_before_id":21,"has_older":true},"total_unread":2,"server_time":"ISO-8601"}
```

- لا ترجع `time/date/human_time`; Flutter ينسق ISO حسب locale/timezone. `sender.id` nullable وموديل Flutter يعامله كذلك.
- send body: `{ "message": "...", "client_message_id": "uuid" }`. Response 201 يعيد message canonical وchat counters.
- أضف `client_message_id` nullable للرسائل مع unique مناسب داخل chat/sender side؛ نفس UUID + نفس payload يعيد نفس الرسالة، ومفتاح مع payload مختلف يرجع 409.
- read body: `{ "up_to_message_id": 44 }`; لا mark-all عمياء. حدّث رسائل doctor فقط حتى cursor، ثم counter داخل transaction.
- أخطاء typed: 401/403/404/409/422/429؛ responses تستخدم `message_key` آمن، ولا raw exceptions أو stack traces.

## 5) سلامة التزامن والعدادات

- send/read يمسكان `DoctorChat` بـ`lockForUpdate` داخل tenant transaction، ويعيدان التحقق من doctor/capability قبل mutation.
- send ينشئ message + يحدّث `last_message_at` + counter المقابل ذريًا. read يحدّث الرسائل حتى cursor ثم يعيد حساب unread authoritative قبل تحديث denormalized counter.
- أضف indexes ملائمة: `(chat_id,id)`, `(chat_id,sender_type,is_read,id)` وunique idempotency index، بعد فحص query plans.
- أضف reconciliation command بـdry-run لإصلاح counters من الرسائل الفعلية، واختبار race بين send/read.
- polling limit + `has_more`: إذا تراكم أكثر من 100، Flutter يطلب الصفحة التالية فورًا دون إسقاط رسائل. dedupe بالـserver id ثم client message UUID.

## 6) Mobile UX

- route رئيسي `/shell/reception/internal-chat`; Sidebar تحت «التواصل» بصلاحية `messages.view`، مع badge من مصدر مركزي غير حاوٍ لأي PHI.
- الهاتف: قائمة conversations ثم route فرعي `/shell/reception/internal-chat/:chatId`. التابلت/landscape: master-detail؛ القائمة يسار/يمين حسب RTL وconversation في الجزء الأكبر.
- قائمة المحادثات تعرض صورة/initials، الاسم والتخصص، preview، وقت محلي، unread badge وحالة inactive. search ثابت أعلى القائمة وempty states مختلفة للكل/البحث/عدم الصلاحية.
- Conversation app bar يعرض الطبيب والتخصص وحالة الحساب، لا presence “online” لأن النظام لا يملك presence حقيقيًا.
- bubbles تميز sender بالموضع والشكل لا باللون فقط، مع اسم موظف الاستقبال عند الرسائل الصادرة من أعضاء مختلفين، date dividers وunread divider.
- عند الفتح: آخر الرسائل ثم scroll للـfirst unread أو الأسفل. السحب لأعلى يحمل الأقدم ويحافظ على scroll anchor؛ وصول رسالة جديدة يعمل auto-scroll فقط إذا المستخدم قريب من الأسفل، وإلا يظهر “رسائل جديدة”.
- input لا يظهر دون `can_send` أو للطبيب غير النشط. يدعم multiline، character counter، keyboard send حسب المنصة، ويحافظ على draft في الذاكرة لكل chat خلال session فقط.
- optimistic bubble لكل رسالة بـUUID وحالات `sending/sent/failed/read`; لا global sending lock. الفشل يحتفظ بالنص مع retry/delete-local، وإعادة المحاولة تستخدم نفس UUID.
- initial/list/older-page loading = skeletons مطابقة. pending bubble يستخدم shimmer صغير في delivery area، unread badge loading shimmer؛ ممنوع spinner.
- polling للمحادثة المفتوحة كل 5 ثوانٍ وللقائمة/unread كل 15 ثانية، بالقيم من `AppDurations/config`; لا requests متداخلة، مع jitter/backoff عند الفشل.
- timers تتوقف تمامًا عند background أو route غير مرئي، وتعمل catch-up عند العودة. فشل polling صامت مع stale indicator ولا يمسح الرسائل.

## 7) Flutter Architecture — منع النسخ بين Doctor وReception

- لا تنشئ feature تستورد `doctor_chat`. انقلها تدريجيًا إلى feature موحّدة `features/internal_chat/` تستخدم نفس domain/data/widgets للطرفين.
- Domain مشترك: `InternalChatEntity`, `ChatMessageEntity`, `ChatParticipantEntity`, `ChatCapabilities`, cursors، delivery status، repository abstract وuse cases typed.
- Data: canonical models، Doctor/Reception remote methods داخل data source منظم، repository impl يعيد `Either<Failure,T>`, وendpoints مركزية منفصلة حسب scope.
- Presentation: `DoctorConversationCubit` للطبيب، `ReceptionChatListCubit` للقائمة، و`ReceptionConversationCubit` للمحادثة؛ shared passive widgets فقط داخل نفس feature.
- لا تجعل Cubit القائمة يحمل كل الرسائل. كل conversation screen له Cubit factory ويُغلق عند الخروج؛ tablet يحتفظ فقط بالمحادثة المحددة.
- state immutable + Equatable: initial/loading/empty/error/loaded، pagination flags، polling warning، `pendingByClientId`; side effects في `BlocListener` فقط.
- validation المركزي في domain/core validators؛ widgets تعرض الخطأ فقط. أزل hardcoded color/spacing/radius/icon/string/duration من Doctor Chat أثناء migration.
- endpoints في `ReceptionEndpoints` و`DoctorEndpoints` فقط، DI في `internal_chat_di.dart` ثم `app_di.dart`; GoRouter guards للحساب والصلاحيات وchat id.
- Sidebar لا يستورد chat feature؛ استخدم `core` provider-agnostic `NavigationBadgeService` لتحديث badge، بعد مراجعة core change.
- دعم ar/en، RTL/LTR، dark/light، 320px، tablet/foldable/landscape، textScale 2.0، keyboard/focus، screen reader و48px targets.

## 8) Laravel Structure

- أضف `V1/Reception/InternalChatController` thin وRequests: list/history/poll/send/read، مع Resources canonical مشتركة للطبيب والاستقبال.
- قسّم `DoctorChatService` إلى chat application service محايد + participant authorization؛ لا تجعل Reception controller يعتمد على Web controller.
- repository list يعيد `LengthAwarePaginator` ولا ينشئ records. queries select/eager-load المطلوب فقط، وتحمي inactive/soft-deleted doctors وفق القاعدة.
- حدّث Doctor Mobile API لنفس timestamps/cursors/idempotency/read-up-to تدريجيًا مع backward-compatible rollout أو API version؛ لا تكسر تطبيق الطبيب فجأة.
- أصلح Web permissions وraw exception leakage، واستخدم نفس domain service حتى لا تختلف counters/validation بين Web وMobile.
- كل ملف أقل من 200 سطر، ولا message contents في logs/notifications. Push مستقبلًا يرسل “رسالة داخلية جديدة” فقط.

## 9) ترتيب التنفيذ الإلزامي

1. characterization tests لعقود الطبيب/Web الحالية، ثم ثبّت read semantics وinactive policy وdigits-only decision.
2. migrations: client UUID/indexes/backfill chats، ثم idempotent send/read-to-cursor/counter locking وreconciliation tests.
3. Requests/permissions/resources/paginated Reception API، ثم Feature tests شاملة، وإصلاح Web leakage.
4. أنشئ Flutter unified internal-chat domain/data/DI، وانقل Doctor Chat مع regression tests قبل إضافة استقبال.
5. نفّذ list/conversation Cubits، lifecycle-safe polling، pagination وoptimistic idempotent sending.
6. ابنِ adaptive master-detail UI وكل الـshimmers، ثم routes/Sidebar/badge/translations/accessibility.
7. formatter، `flutter analyze` بلا warnings، feature/full Flutter tests، ثم Laravel targeted/full suite.

## 10) الاختبارات الإلزامية

- Laravel: tenant isolation، view/create permissions، doctor ownership، inactive/soft-delete، pagination/search/sort، resource ISO shape، rate limit، max/empty/numbers-only.
- concurrency: duplicate UUID،same-key different payload،simultaneous retries،send/read race،cursor bounds،>100 poll backlog،counter reconciliation.
- Flutter unit/Cubit: strict nullable parsing،Either failures،list pagination/debounce/race،older/newer merge،dedupe IDs/UUID،per-message retry،scroll intent،lifecycle/backoff/no overlap.
- Widget/golden: list/detail/master-detail،unread/date dividers،inactive/read-only،all shimmer/error/empty/stale states،320px/tablet/landscape،AR/EN،RTL/LTR،dark/light،textScale 2.0.
- security tests: direct route/API without permissions،cross-tenant chat id،no raw errors،no PHI logs/push/cache،safe plain-text rendering.
- فحص يمنع `CircularProgressIndicator`, `CupertinoActivityIndicator`, `RefreshIndicator` داخل feature، ويفحص عدم وجود ملفات فوق 200 سطر أو hardcoded UI values.

## 11) Definition of Done

- الطبيب والاستقبال يريان نفس conversation دون duplication، والرسائل مرتبة ومكتملة مع older/poll cursors آمنة.
- send idempotent،read محدد حتى cursor،counters صحيحة تحت concurrency،ولا polling بالخلفية أو requests متداخلة.
- list paginated ولا تقوم بأي writes،وصلاحيات view/send مفصولة ومطبقة API/route/UI مع tenant isolation.
- لا PHI في logs/push/persistent cache،ولا raw exceptions،وكل timestamps ISO ومنسقة محليًا.
- Doctor Chat لم ينكسر بعد توحيد feature،ولا cross-feature imports أو business logic في widgets أو hardcoded UI/endpoints.
- كل loading shimmer بلا مؤشر دائري،وجميع Laravel/Flutter tests و`flutter analyze` تمر بلا errors أو warnings.

## 12) تحسينات تحتاج موافقة منفصلة

- WebSocket/SSE بدل polling مع fallback وreconnect/resume cursors وقياس تكلفة البنية.
- Push notifications عامة بلا محتوى الرسالة،مع mute per doctor/quiet hours وتخزين device tokens آمن.
- مرفقات عبر Central Document Service فقط: allowlist،size limits،virus scan،signed URLs،audit وexpiry؛ لا رفع مباشر داخل chat.
- تشفير محتوى الرسائل at rest وسياسة retention/legal hold؛ يحتاج قرار تشغيلي وخطة migration/backup/search.
- read receipts لكل موظف استقبال بدل team-level read؛ يحتاج participant/read table وليس تغيير boolean الحالي فقط.
- canned replies/mentions/priority messages؛ تحتاج صلاحيات وUX وعدم استخدامها كبديل لتنبيهات الحالات الطبية الحرجة.
