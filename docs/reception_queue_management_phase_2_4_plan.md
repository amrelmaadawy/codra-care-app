# خطة تنفيذ 2.4 — Reception Queue Management

> هذه وثيقة تنفيذ موجهة إلى Gemini. تُنفّذ بعد 2.1–2.3 وخطة الـAdaptive Sidebar، مع الالتزام الكامل بـ`.agents/rules/rules.md`. لا تنسخ منطق Laravel إلى Flutter، ولا تنفّذ التحسينات الموسومة «تحتاج موافقة» دون اعتمادها.

## 1) الهدف والنطاق

- إنشاء `ReceptionQueueScreen` لإدارة طابور اليوم: عرض، فلترة بالطبيب والحالة، تسجيل حضور/غياب، حفظ العلامات الحيوية، نداء الطبيب، إنهاء الزيارة، والإلغاء.
- المصدر الوحيد للحقيقة هو Laravel؛ Flutter يعرض `capabilities` ويرسل أوامر فقط، ولا يستنتج انتقالات طبية/مالية.
- الحالات المعتمدة: `waiting`, `with_doctor`, `completed`, `cancelled`، والأولويات: `urgent`, `vip`, `normal`.
- خارج النطاق: إعادة فتح العنصر، تغيير الأولوية، التحصيل/الاسترداد، تعديل الموعد، وDoctor examination flow.
- جميع حالات التحميل Shimmer فقط؛ ممنوع `CircularProgressIndicator`, `CupertinoActivityIndicator` و`RefreshIndicator` الافتراضي.

## 2) نتائج مراجعة النظام الحالي — يجب معالجتها

- `WaitingList` مرتبط بالمريض والطبيب والموعد/جلسة الباقة والخدمة، ويحفظ `is_present`, `vital_signs`, أوقات الدخول/النداء/الاكتمال.
- `callPatientToDoctor()` و`completeQueueItem()` و`cancelQueueItem()` تستخدم tenant transaction و`lockForUpdate` وتزامن الموعد وجلسات الباقة؛ يجب إعادة استخدامها، لا إعادة كتابتها في Mobile Controller.
- الإنهاء مسموح حاليًا من `with_doctor` فقط. الباقة تكمل الجلسة، ثم تكمل الموعد فقط عند اكتمال جميع الجلسات؛ وإلا يعود الموعد `scheduled`.
- الإلغاء يمنع `completed`، ويلغي الموعد العادي، بينما يعيد جلسة الباقة إلى `scheduled/pending`. الاسترداد الحالي اختياري؛ لا يُعرض في 2.4.
- Web `togglePresence` يقلب القيمة عميانيًا بلا lock/state validation؛ هذا غير آمن مع double tap أو retry ويجب ألا يُنسخ للموبايل.
- Web vitals يستخدم أسماء غير متسقة (`pulse_rate`, `oxygen_saturation`) بينما `VitalSignsData` والتدفقات الجديدة تستخدم `pulse`, `oxygen_level` و`blood_pressure`؛ يلزم adapter واحد.
- `ReceptionQueueItemResource` الحالي لا يرجع vitals أو capabilities أو pagination. وMobile queue routes غير موجودة بعد.
- لا توجد صلاحية `reception.queue.cancel`، وWeb cancel غير محمي بها؛ هذه ثغرة إلزامية الإصلاح قبل الإطلاق.
- Flutter لديه `doctor_queue` وqueue preview داخل dashboard. ممنوع استيرادهما من feature الاستقبال؛ أي atoms مشتركة تُستخرج إلى `core` بعد مراجعة صريحة فقط.

## 3) عقد الـAPI النهائي

### القائمة

`GET /api/mobile/reception/queue?doctor_id=&status=&page=&per_page=`

- `status`: `active|waiting|with_doctor|completed|cancelled`، والافتراضي `active` = waiting + with_doctor.
- `per_page` افتراضي 20 وأقصى 50؛ query typed ومتحقق منها، وdoctor يجب أن ينتمي للـtenant/branch المتاح للمستخدم.
- Response:

```json
{
  "data": [{ "id": 1, "ticket_number": "A-01", "patient": {"id": 8, "name": "...", "phone": "..."}, "doctor": {"id": 2, "name": "..."}, "service": {"id": 3, "name": "..."}, "appointment_id": 7, "status": "waiting", "priority": "normal", "is_present": true, "vital_signs": null, "entry_time": "ISO-8601", "called_time": null, "completed_time": null, "wait_minutes": 12, "capabilities": {"can_toggle_presence": true, "can_save_vitals": true, "can_call_doctor": true, "can_complete": false, "can_cancel": true} }],
  "meta": {"current_page": 1, "last_page": 1, "per_page": 20, "total": 1},
  "summary": {"waiting": 1, "with_doctor": 0, "completed": 0, "cancelled": 0},
  "doctors": [{"id": 2, "name": "...", "active_count": 1}],
  "generated_at": "ISO-8601"
}
```

- `capabilities` = صلاحية المستخدم + ownership + الحالة الحالية؛ إخفاء الزر في Flutter ليس حماية.
- إرجاع الهاتف فقط إن كانت صلاحية/سياسة عرضه تسمح. لا ترجع medical history أو payments أو Eloquent خامًا.

### الأوامر

- `POST /api/mobile/reception/{id}/toggle-presence`: body إلزامي `{ "is_present": true, "client_request_id": "uuid" }`؛ المسار يبقى للاسم المتفق عليه لكن السلوك set صريح وليس toggle أعمى.
- `POST /api/mobile/reception/{id}/save-vitals`: body `{ "vital_signs": {...}, "client_request_id": "uuid" }`.
- `POST /api/mobile/reception/{id}/call-doctor`, `/complete`: body `{ "client_request_id": "uuid" }`.
- `POST /api/mobile/reception/{id}/cancel`: body `{ "reason": "...", "client_request_id": "uuid" }`؛ لا يقبل `auto_refund` في 2.4.
- كل نجاح يعيد `{data: QueueItemResource, summary, message_key}`، لا يعيد الطابور كاملًا. Flutter يpatch العنصر ثم يعمل silent refresh.
- استخدم سجل `mobile_idempotency_keys` من خطة 2.3، وامنع auto-retry لكل write method. نفس UUID يُعاد للمحاولة اليدوية لنفس العملية.
- الأخطاء: `401`, `403`, `404`, `422`, و`409 QUEUE_STATE_CHANGED`; لا raw exceptions ولا رسائل عربية hardcoded كعقد.

## 4) قواعد الانتقال والصلاحيات

| الحالة | Presence | Vitals | Call doctor | Complete | Cancel |
|---|---:|---:|---:|---:|---:|
| `waiting` | نعم | نعم | نعم | لا | نعم |
| `with_doctor` | لا | نعم | لا | نعم | نعم |
| `completed` | لا | قراءة فقط | لا | لا | لا |
| `cancelled` | لا | قراءة فقط | لا | لا | لا |

- GET يحتاج `reception.queue.view`. وكل فعل يحتاج صلاحيته الحالية، مع إضافة `reception.queue.cancel` في config/seeding/role assignment والـRequest authorization.
- لا تمنح الصلاحية الجديدة لكل المستخدمين تلقائيًا؛ تُعطى للأدوار المعتمدة فقط وتُختبر direct API access.
- كل mutation: tenant transaction + `lockForUpdate` + إعادة فحص الحالة + idempotency + audit، ثم استدعاء service الحالي.
- أوصِي بمنع Call Doctor إذا `is_present=false` في API وUI؛ هذا **تغيير business rule يحتاج موافقة** قبل تفعيله.
- audit يسجل actor/action/queue id/doctor id/before-after status والوقت فقط؛ لا أسماء، هواتف، أو قيم vitals.

## 5) عقد العلامات الحيوية

- Mobile shape: `bp_systolic`, `bp_diastolic`, `temperature`, `pulse`, `weight_kg`, `height_cm`, `oxygen_level`, `respiratory_rate`, و`bmi` في response فقط.
- Request لا يرسل `bmi`. Laravel يحسبه من الوزن والطول ويقربه مركزيًا؛ Flutter لا يحسب قيمة طبية.
- أنشئ `SaveQueueVitalsRequest` ومرر القيم عبر `VitalSignsData`: يحول الضغط إلى التخزين canonical `blood_pressure` ويعيده للموبايل مقسومًا؛ لا تخزن shape ثانية.
- يلزم حقل واحد على الأقل، وكل الحقول nullable numeric. حدود منع القيم المستحيلة مركزيًا: systolic 40–300، diastolic 20–200 وأقل من systolic، الحرارة 34–44، النبض 30–250، الوزن 1–400، الطول 20–260، الأكسجين 50–100، والتنفس 5–80.
- Flutter يعكس القيود لتحسين UX فقط؛ Laravel هو المرجع. الأخطاء تعود بمسارات مثل `vital_signs.temperature` وتترجم محليًا.
- عرض الوحدات بوضوح (`mmHg`, `°C`, `bpm`, `kg`, `cm`, `%`, breaths/min)، بلوحة أرقام decimal مناسبة، ودون تصنيف “طبيعي/خطر” في هذه المرحلة.

## 6) UX وUser Flow

- Route: `/shell/reception/queue`، يضاف للـSidebar تحت «العمل اليومي» بعد المواعيد وبصلاحية `reception.queue.view`; dashboard queue preview يفتح نفس route مع `doctor_id` اختياري.
- App bar: عنوان، وقت آخر تحديث، زر refresh. أسفله summary chips ثم doctor selector ثم status segmented control؛ الفلاتر تظل محفوظة أثناء session.
- الهاتف: cards. Tablet/landscape: قائمة أوسع بعمود معلومات/أفعال، لا DataTable مزدحم. اعرض `with_doctor` أولًا ثم waiting حسب urgent → vip → normal مع الحفاظ على ترتيب الدخول.
- Card: ticket، المريض، الطبيب/الخدمة، الحالة، الأولوية، الحضور، وقت الانتظار، vitals summary. primary action حسب الحالة، والباقي في overflow؛ الإلغاء destructive وواضح نصيًا لا باللون وحده.
- Presence زر ذو فعل صريح «تسجيل حضور/تسجيل غياب»، وليس Switch optimistic. Call وComplete وCancel لها confirmation sheet؛ Cancel يطلب سببًا صالحًا.
- Save Vitals يفتح modal bottom sheet على الهاتف وdialog/side sheet المتجاوب على tablet، يحمّل القيم الحالية، يعرض BMI read-only بعد الحفظ، ويحذر قبل الإغلاق عند وجود تغييرات.
- initial/filter change/load-more = skeleton مطابق للكروت. أثناء action استبدل مساحة أزرار الكارت بـshimmer capsule وعطّل هذا الكارت فقط. Background refresh بلا loader، وفشله يبقي البيانات مع localized stale banner.
- empty states منفصلة: لا طابور اليوم، لا نتائج للفلتر، أو لا صلاحية. Retry مخصص ولا يمسح القائمة المحملة.
- polling كل 15–30 ثانية فقط عند foreground، بلا requests متداخلة؛ يتوقف بالخلفية ويعمل silent refresh عند العودة. dedupe بالـid ولا تُسقط scroll position.

## 7) Flutter Clean Architecture

أنشئ `features/reception_queue/` مستقلًا:

- Domain: `ReceptionQueueEntity`, `ReceptionQueueItemEntity`, `VitalSignsEntity`, `QueueCapabilitiesEntity`, `QueueFilter`; repository abstract؛ use cases للقائمة ولكل فعل.
- Data: typed models/requests، `ReceptionQueueRemoteDataSource` بـDio، repository impl يعيد `Either<Failure,T>`، parsing صارم مع nullable آمن.
- Presentation: `ReceptionQueueCubit/State` و`QueueVitalsCubit/State`، screen/view، filter/summary/card/action/vitals/shimmer/empty widgets صغيرة.
- State loaded يحمل data/filter/pagination/`pendingActionsById`/refresh warning؛ استخدم `BlocSelector` لكي لا يعاد بناء كل الكروت، و`BlocListener` للرسائل والتنقل.
- أضف endpoints فقط إلى `ReceptionEndpoints`، وسجّل DI في `reception_queue_di.dart` ثم `app_di.dart`; لا manual construction ولا endpoint داخل feature.
- لا تستورد `reception_dashboard` أو `doctor_queue`. انقل فقط visual atoms عديمة منطق المجال (status/priority badge وvitals row) إلى core في PR صغير مُراجع، ثم حدّث المستهلكين؛ وإلا اتركها receptionist-specific ولا تنسخ business logic.
- أضف route وguard وSidebar destination وAR/EN keys وdesign tokens/icons المركزية؛ دعم RTL/LTR، dark/light، 320px، textScale 2.0 وtouch target 48px.

## 8) Laravel Structure

- أضف `V1/Reception/QueueController` thin، وRequests: index/presence/vitals/cancel، ووسّع resource عبر resources صغيرة إن اقترب من 200 سطر.
- أضف `MobileReceptionQueueService` للتنسيق فقط، ويستدعي `ReceptionService`/repository الحاليين؛ لا يعتمد على Web Controller أو web response shape.
- query eager-loads الحقول اللازمة فقط، paginates، ويحسب summary منفصلًا عن الصفحة دون N+1. اعزل tenant/branch وطبّق doctor ownership.
- وحّد vital mapping في DTO الحالي، وأصلح Web adapter لاحقًا لنفس canonical keys لتجنب تخزين بيانات متباينة.
- أضف permission، Form Requests، policy/capability resolver، audit events، وAPI routes المسماة. كل ملف أقل من 200 سطر.

## 9) ترتيب التنفيذ الإلزامي

1. ثبّت transition table وقرار absent-call، ثم اختبارات Laravel characterization للخدمة الحالية.
2. أضف `reception.queue.cancel` وأصلح حماية Web/API قبل بناء الواجهة.
3. نفّذ canonical vitals adapter والـRequests/Resource/query/action API مع idempotency والـlocks.
4. اختبر API كاملًا بـtenant/permission/state/package/concurrency، ثم وثّق JSON contract.
5. أنشئ Flutter domain/data/DI/endpoints مع unit tests، ثم Cubits واختبار race/polling/action isolation.
6. ابنِ الشاشة والـshimmers والـvitals sheet، ثم route/Sidebar/dashboard deep link والترجمات.
7. شغّل formatter و`flutter analyze` واختبارات feature ثم full suite، واختبارات Laravel المستهدفة ثم الكاملة.

## 10) الاختبارات الإلزامية

- Laravel: tenant isolation، كل permission allow/deny، filters/pagination، resource shape، لا N+1، states 409/422، double submit idempotency، concurrent call/complete/cancel، package vs normal، cancellation بلا refund، BMI والمفاتيح القديمة/الجديدة.
- Flutter unit: parsing،Either failures،params،pagination dedupe،poll cancellation،per-item pending action،patch + silent refresh،عدم فقد filters.
- Cubit/widget: initial/filter/load-more/action shimmers،empty/error/stale،all action confirmations،vitals validation،capabilities hiding،direct route guard.
- Golden/widget: 320px/tablet/landscape،AR/EN،RTL/LTR،dark/light،textScale 2.0،keyboard/focus وSemantics.
- فحص آلي يمنع وجود `CircularProgressIndicator`, `CupertinoActivityIndicator` أو `RefreshIndicator` داخل feature.

## 11) Definition of Done

- كل action يطابق transition/appointment/package rules ويُرفض server-side عند الحالة أو الصلاحية الخطأ.
- Presence explicit وآمن من retries، وكل writes idempotent ولا يوجد double transition.
- vitals canonical وBMI server-side، ولا قيم طبية/PHI في logs أو cache غير آمن.
- queue paginated، live refresh لا يكرر العناصر ولا يهز scroll، وكل loading shimmer بلا أي مؤشر دائري.
- Sidebar/route/guards/capabilities متطابقة، ولا cross-feature imports أو hardcoded strings/colors/endpoints أو ملف فوق 200 سطر.
- Laravel + Flutter tests و`flutter analyze` تمر بلا errors أو warnings، مع مراجعة أمنية خاصة للإلغاء والصلاحيات.

## 12) تحسينات تحتاج موافقة منفصلة

- real-time عبر WebSocket/SSE بدل polling، مع fallback مضبوط؛ لا يُضاف قبل قياس الحمل والبنية التحتية.
- نداء صوتي/شاشة انتظار عامة باستخدام ticket فقط دون اسم المريض؛ يحتاج privacy review.
- SLA alerts لوقت الانتظار وتصعيد urgent؛ الحدود تأتي من إعدادات Laravel لا من Flutter.
- workflow مالي منفصل عند الإلغاء لاختيار refund/credit بإذن مالي وaudit؛ ممنوع تمرير `auto_refund` ضمن 2.4.
- bulk presence/no-show أو drag reorder؛ لا يُنفّذ قبل قواعد واضحة للتعارض والأولوية والتدقيق.
