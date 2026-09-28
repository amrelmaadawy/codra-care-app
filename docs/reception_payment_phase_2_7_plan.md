# خطة تنفيذ 2.7 — Payment at Reception

> وثيقة تنفيذ موجهة إلى Gemini. هذه مرحلة مالية عالية الحساسية، ولا يبدأ Flutter قبل إغلاق شروط Laravel في الأقسام 2–5. الالتزام الكامل بـ`.agents/rules/rules.md` إلزامي، والتحسينات في القسم الأخير لا تُنفّذ دون موافقة.

## 1) الهدف والنطاق

- إضافة Payment Bottom Sheet يفتح من Queue item المرتبط بموعد، لعرض الحساب والحركات وإضافة دفعة/خصم/خدمة وإجراء استرداد وفق الحالة والصلاحيات.
- Laravel هو المصدر الوحيد للأسعار والأرصدة والعمولات والحدود؛ Flutter لا يحسب رصيدًا أو سعر خدمة أو قيمة قابلة للاسترداد.
- دعم split payment ووسائل الدفع المفعلة والحساب البنكي/المرجع وسندات القبض/الصرف.
- خارج النطاق: تعديل/حذف حركة مالية، price override من الموبايل، تحصيل patient credit عام، تقسيط/تأمين، إلغاء سند، أو offline auto-sync.
- كل loading Shimmer فقط: فتح الـsheet، summary، transaction history، service search، submission وreceipt. ممنوع أي circular indicator أو `RefreshIndicator` افتراضي.

## 2) نتائج مراجعة Laravel الحالية — blockers إلزامية

- الرصيد الحالي: `service_price - payments + refunds - discounts`، لكن الحساب موزع بين Model/Controller/Services ويستخدم `float` في نقاط مالية متعددة.
- Payment ينشئ PatientTransaction + receipt voucher، وRefund ينشئ disbursement voucher، وDiscount adjustment بلا voucher؛ هذا الأساس يُعاد استخدامه بعد تقويته.
- payment/refund لا يقفلان الموعد ولا يمنعان concurrent full payments، ولا يوجد idempotency؛ timeout/retry قد يكرر transaction والسند.
- payment الحالي يسمح بتجاوز المتبقي، والخصم قد يتجاوز إجمالي التكلفة، ولا توجد state rules مركزية.
- Refund يتحقق من إجمالي مدفوعات المريض كلها، لا الموعد؛ لذلك يمكن استرداد أموال تخص موعدًا آخر.
- Refund جديد يحسب doctor/clinic shares بنسبة الطبيب الحالية، لا snapshot الدفعة الأصلية؛ تغيير العمولة ينتج عكسًا محاسبيًا خاطئًا.
- Add Service يزيد `appointments.service_price` فقط. الخدمة غير المدفوعة لا تترك line item يوضح نوعها وسعرها ومن أضافها، ولا توجد طريقة audit/reversal صحيحة.
- Add Service يقبل `price` من العميل تحت `reception.pricing.override`؛ الموبايل لا يجب أن يرسل سعرًا.
- Refund يستخدم `reception.payments.create` وAdd Service/Discount يستخدمان pricing override؛ الصلاحيات الحالية أوسع من الفعل الحقيقي.
- `removeDiscount()` يعمل soft-delete لحركة مالية؛ القاعدة الصحيحة adjustment/reversal غير قابل للمحو.

## 3) النموذج المالي المرجعي

- أنشئ Laravel `Money` value object يعتمد decimal string/minor units، rounding واحد حسب عملة الـtenant؛ ممنوع float arithmetic في الخدمات الجديدة.
- API يعيد الأموال كسلاسل ثابتة مثل `"150.00"` مع `{currency_code, currency_symbol, decimal_digits}`. Flutter يحولها إلى `MoneyEntity(minorUnits)` مركزيًا، لا `double`.
- المعادلات server-side فقط:
  - `gross_charges = sum(active charge items)`.
  - `discount_total = sum(discounts - discount reversals)`.
  - `net_due = gross_charges - discount_total` ولا يقل عن صفر.
  - `net_collected = payments - refunds`.
  - `balance = net_due - net_collected`; موجب = مستحق، صفر = مسدد، سالب = credit.
- server يعيد `max_payable`, `max_discount`, `max_refundable`, `financial_status` وcapabilities؛ Flutter يعرضها ولا يعيد اشتقاقها.

## 4) Charge ledger للخدمات

- أضف `appointment_charge_items`: appointment/service nullable، type (`base_service|additional_service|legacy_total`)، name snapshot، quantity،unit/total amount، status، created_by،void metadata وtimestamps.
- booking service ينشئ base charge مع الموعد. Migration backfill ينشئ `legacy_total` بقيمة `service_price` للحجوزات القديمة؛ لا يدّعي معرفة الخدمات التاريخية المفقودة.
- `appointments.service_price` يبقى aggregate denormalized للتوافق، ويُعاد حسابه من active charge items داخل نفس transaction؛ لا `increment` منفردًا.
- إضافة خدمة تقفل الموعد، تتحقق أن الخدمة فعالة ومتاحة للطبيب والحالة تسمح، وتأخذ السعر الحالي server-side، وتنشئ charge snapshot. لا تقبل `price` أو `paid_amount`.
- لا حذف للـcharge. الإلغاء المستقبلي يكون void/reversal بسبب إلزامي وصلاحية مستقلة؛ غير موجود في Mobile 2.7.

## 5) Refund integrity والـimmutability

- Refund limit يُحسب من معاملات الموعد نفسه: `payments - prior refunds`، مع state/policy؛ لا Patient totals.
- أضف refund allocations تربط refund transaction بدفعة/دفعات أصلية ومبلغ كل allocation. العكس يستخدم commission/doctor/clinic share snapshots الأصلية نسبيًا.
- server يوزع المبلغ deterministically على الدفعات القابلة للاسترداد أو يقبل payment transaction محددة إذا أقر المنتج ذلك؛ لا استرداد بلا أصل.
- الحركات والسندات المكتملة immutable. أي تصحيح يكون reversal transaction + reason + actor + reference، وليس update/delete/soft-delete.
- أضف `financial_version` للموعد، يزيد مع كل mutation. كل write يرسل expected version؛ mismatch يرجع `409 FINANCIAL_STATE_CHANGED` مع snapshot حديث.

## 6) الصلاحيات والحالات

- صلاحيات مستقلة: `reception.payments.view`, الإبقاء على `reception.payments.create`، وإضافة `reception.payments.refund`, `reception.discounts.create`, `reception.services.add`.
- لا تستخدم `pricing.override` لإضافة خدمة/خصم؛ تبقى فقط لمسار override منفصل غير متاح في 2.7. receipt preview/print له capability حسب صلاحيات المالية.
- baseline state policy:
  - Payment: موعد غير cancelled وله `max_payable > 0`.
  - Discount: غير cancelled، وله charge قابل للخصم، حتى `max_discount`.
  - Add Service: queue `with_doctor|completed` فقط وفق السلوك الحالي بعد حذف legacy `vitals_taken`.
  - Refund: `completed|cancelled` فقط، وله `max_refundable > 0`.
- هذه السياسة تُنفذ في Domain/API وتعود كـcapabilities؛ UI hiding ليس حماية. أي تغيير business يحتاج اختبار وموافقة.

## 7) GET financial snapshot

`GET /api/mobile/reception/appointments/{id}/transactions?page=&per_page=`

- يحتاج view permission، appointment داخل tenant/branch، history paginated افتراضي 20 وأقصى 50، newest first بترتيب ثابت.
- Response:

```json
{"appointment":{"id":7,"number":"A-7","status":"completed","patient":{"id":4,"name":"..."},"doctor":{"id":2,"name":"..."}},"money":{"currency_code":"EGP","currency_symbol":"ج.م","decimal_digits":2},"summary":{"gross_charges":"300.00","discount_total":"20.00","net_due":"280.00","payments":"200.00","refunds":"0.00","net_collected":"200.00","balance":"80.00","credit":"0.00","max_payable":"80.00","max_discount":"280.00","max_refundable":"200.00","financial_status":"partial","financial_version":3},"charges":[],"transactions":[],"meta":{"current_page":1,"last_page":1,"has_more":false},"payment_methods":[],"bank_accounts":[],"capabilities":{"can_pay":true,"can_refund":false,"can_discount":true,"can_add_service":true,"can_view_receipt":true},"generated_at":"ISO-8601"}
```

- لا ترجع commission shares أو internal treasury data. transaction يعيد id/number/type/category/amount/method/reference/description/created_at/actor display/voucher capability فقط.
- payment methods تعيد `requires_reference`, `requires_bank_account`, default account؛ server يعيد التحقق وقت الكتابة.
- أضف support endpoint paginated: `GET appointments/{id}/service-options?search=&page=` للخدمات المتاحة للطبيب؛ لا تحمل كل الخدمات داخل snapshot.

## 8) Write contracts

- كل body يحتوي `client_request_id` UUID و`expected_financial_version`. استخدم `mobile_idempotency_keys` مع operation + appointment + actor + payload hash.
- `POST .../{id}/payments`: canonical body دائمًا `payments:[{amount,payment_method,bank_account_id?,reference_number?,description?}]`. single payment = عنصر واحد؛ batch كله transaction واحدة.
- مجموع الدفعات يجب ألا يتجاوز locked `max_payable`. كل line تنشئ transaction وسندًا مستقلًا، والنجاح يعيد snapshot + transactions/vouchers.
- `POST .../{id}/refunds`: `{amount,payment_method,bank_account_id?,reference_number?,reason,client_request_id,expected_financial_version}`؛ reason إلزامي ولا يتجاوز max refundable.
- `POST .../{id}/discounts`: `{amount,reason,client_request_id,expected_financial_version}`؛ لا يتجاوز max discount، ولا voucher.
- `POST .../{id}/services`: `{service_id,quantity,notes?,client_request_id,expected_financial_version}`؛ السعر/الإجمالي server-owned، ولا دفع ضمن نفس الطلب.
- كل mutation: authorize → lock appointment → re-read ledger → state/limit validation → idempotent financial operation → voucher/audit/version → canonical snapshot؛ success 201/200.
- errors: 401/403/404/409/422/429، مع field codes و`message_key`; لا raw exceptions. لا auto-retry لأي POST، والمحاولة اليدوية تستخدم UUID نفسه.
- voucher response يوفر authorized short-lived receipt URL/identifier، لا Web session print URL. لا يفتح تلقائيًا بعد النجاح.

## 9) Bottom Sheet UX

- Queue Resource يضيف financial capabilities فقط إذا `appointment_id` موجود. Card يعرض فعل «الحساب والدفع» في overflow/secondary action، ويفتح GoRouter modal route؛ لا direct `showModalBottomSheet` ولا import بين features.
- route: `/shell/reception/queue/payment/:appointmentId` مع guards. الهاتف: draggable full-height sheet آمن مع keyboard؛ tablet: adaptive dialog/side sheet.
- header ثابت: المريض، رقم الموعد، financial status. summary cards: الإجمالي، الخصم، الصافي، المحصل، المسترد، المتبقي/الرصيد الدائن.
- sections داخل sheet: Overview،Pay،Actions،History. أظهر فقط الأفعال المسموحة، مع primary Pay عند وجود مستحق.
- Pay: زر «دفع المتبقي» يملأ server `max_payable`، وإضافة split lines،طريقة الدفع،حقول البنك/المرجع الديناميكية. لا يحدث summary بصريًا قبل نجاح server.
- Add Service: searchable paginated selector، quantity،وسعر read-only من server ثم confirmation. بعد الإضافة اعرض snapshot الجديد ويمكن فتح Pay كخطوة منفصلة.
- Discount/Refund: amount + mandatory reason + confirmation يعرض before/after snapshot من server preview إن أضيف؛ Refund destructive ولا يعتمد على اللون وحده.
- History grouped by date مع type badge وreceipt action. لا تظهر patient-wide transactions.
- عند 409: لا تعيد الإرسال؛ حدّث snapshot،احتفظ بالمدخلات،واطلب confirmation مجددًا. عند timeout: اعمل idempotency status/retry بنفس UUID ولا تفترض الفشل.
- initial/history/service search = skeletons مطابقة. أثناء mutation استبدل CTA/summary area بـshimmer؛ عطّل submit نفسه فقط، ولا spinner.
- الإغلاق أثناء request يحتاج confirmation ويمنع double submit. النجاح يعيد result للـQueue route ويعمل silent refresh للعنصر دون هز القائمة.
- offline policy في 2.7 صريحة: عرض read-only snapshot الأخير داخل session فقط، ومنع mutations مع رسالة localized. لا queue مالية صامتة ولا success وهمي.

## 10) Flutter Clean Architecture

- أنشئ `features/reception_payments/` مستقلًا: Money/summary/charge/transaction/payment method entities،typed params،repository abstract،use cases لكل endpoint.
- Data: strict models وDio data source وrepository impl يعيد `Either<Failure,T>`. الأموال تُparse إلى minor units مع currency scale؛ parsing invalid = typed failure لا zero fallback.
- Presentation: `ReceptionPaymentCubit/State` للـsnapshot/history/actions،و`ServiceOptionsCubit` للبحث. state يحمل financialVersion،pending action،form-safe draft وstale warning.
- Queue لا يستورد payment feature؛ يفتح route مركزيًا بالـappointment id. Router يبني modal page،والنتيجة تحفز Queue Cubit على silent refresh.
- أضف capabilities إلى queue contract/entity/model،وحدّث Queue card أثناء ذلك لإزالة hardcoded UI values وتقسيمه إن اقترب من 200 سطر.
- endpoints داخل `ReceptionEndpoints`،DI في `reception_payments_di.dart` ثم `app_di.dart`; Cubits factory،لا manual construction أو data access من UI.
- business validation ومبالغ Money في Domain،والنصوص/ar-en والوحدات/العملة من localization/server؛ RTL/LTR،dark/light،320px،tablet،textScale 2.0 و48px targets.
- لا persistent cache للحركات/طرق الدفع/مراجع البنك،ولا amounts/PHI في logs. controllers تُdispose،و`BlocSelector` يقلل rebuilds.

## 11) Laravel Structure وترتيب التنفيذ

1. characterization tests للحسابات الحالية،ثم اعتماد Money/currency/state/permission/refund-allocation policies.
2. migrations: charge items،refund allocations،financial version،idempotency indexes؛backfill + dry-run reconciliation report.
3. أنشئ `ReceptionFinancialService` واحدًا للحساب/locks/actions،وقوِّ PatientTransactionService دون كسر Treasury.
4. أصلح Web actions لاستخدام الخدمة نفسها،ألغِ financial deletes،وافصل permissions قبل Mobile API.
5. نفّذ Requests/Resources/Controller/routes وfeature tests،ثم راجع Treasury/commission/voucher reports.
6. نفّذ Flutter domain/data/tests،ثم Cubits والـmodal UI وربط Queue capabilities/routes.
7. formatter،`flutter analyze` بلا warnings،Flutter feature/full tests،ثم Laravel targeted/full financial suite.

## 12) الاختبارات الإلزامية

- Laravel: tenant/branch isolation،كل permission،appointment states،normal/package/follow-up،currency rounding،zero/negative/overpay/over-discount/over-refund.
- split payments وmethod requirements،bank/reference،inactive method،voucher numbering/link،additional charge ledger/backfill،financial version 409.
- concurrency/idempotency: double pay/refund/discount/service،timeout replay،same key different payload،simultaneous full balance payments.
- refund allocations تعكس original commission snapshots بدقة،partial/multi-payment refunds،Treasury totals قبل/بعد،ولا patient-cross-appointment refund.
- immutable ledger: لا update/delete،reversal/audit فقط؛audit لا يحتوي PHI أو bank reference كامل.
- Flutter: Money parsing/format،strict JSON،Either failures،capabilities،split form،409 refresh،timeout retry same UUID،history/service pagination،route result.
- Widget/golden: كل shimmer/error/offline/empty/success states،keyboard،320px/tablet/landscape،AR/EN،RTL/LTR،dark/light،textScale 2.0 وSemantics.
- فحص يمنع circular loaders وhardcoded UI/endpoints،ويضمن كل ملف أقل من 200 سطر.

## 13) Definition of Done

- كل مبلغ من ledger واحد وبـMoney دقيق،والـsnapshot/Treasury/vouchers/commission shares متطابقة.
- لا overpayment/over-discount/cross-appointment refund،ولا duplicate mutation تحت retry أو concurrency.
- كل خدمة مضافة لها immutable charge line،وكل Refund مربوط بدفعاته الأصلية ويعكس حصصها الفعلية.
- صلاحيات granular وcapabilities server-side،وكل mutation locked/idempotent/audited ولا raw errors أو PHI logs.
- Bottom Sheet responsive وآمنة،Queue integration بلا cross-feature imports،وكل loading shimmer فقط.
- Laravel/Flutter tests و`flutter analyze` تمر بلا errors أو warnings،مع مراجعة مالية يدوية قبل الإنتاج.

## 14) تحسينات تحتاج موافقة منفصلة

- approval workflow/PIN للخصومات أو الاستردادات فوق threshold من إعدادات Laravel،مع approver audit.
- secure share/print للفاتورة أو السند وPDF عبر Document Service؛لا روابط عامة دائمة.
- patient credit wallet لتسجيل overpayments بدل منعها؛يحتاج ledger وسياسة استخدام/استرداد مستقلة.
- explicit encrypted offline payment outbox مع cashier confirmation عند العودة واتصال idempotency؛غير مناسب للإطلاق الأول.
- card terminal/Paymob/Fawry integrations عبر provider abstraction وwebhooks/reconciliation،وليس اعتبار client success دفعة نهائية.
