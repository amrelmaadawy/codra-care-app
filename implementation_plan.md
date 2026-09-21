# CodraCare Mobile App — Feature Plan (Detailed)

> **مرجع شغل** — مبني على تحليل مباشر لكود الـ Laravel (Models, Controllers, Enums, Routes).
> الـ API هتتبنى من الصفر على الـ Laravel لخدمة الـ Mobile.
> بوابة المريض = نفس مفهومها في السيستم (من ناحية الستاف/الإدارة).

---

## الـ Tech Stack المحدد

| Layer | Package |
|---|---|
| State | `flutter_bloc` (Cubit default) |
| DI | `get_it` |
| Navigation | `go_router` |
| Network | `dio` + interceptors |
| Storage | `flutter_secure_storage` |
| Localization | `easy_localization` (AR/EN + RTL) |
| Either | `dartz` |
| Images | `cached_network_image` |

---

## الـ Enums المستخرجة من Laravel (مرجع للموبايل)

```
AppointmentStatus : scheduled | confirmed | in_consultation | completed | cancelled | no_show
WaitingStatus     : waiting | with_doctor | completed | cancelled | no_show
VisitStatus       : in_progress | completed | cancelled
BookingType       : new_patient | follow_up | package
PriorityLevel     : normal | urgent
TransactionType   : charge | payment | refund | discount
Gender            : male | female
BloodType         : A+ | A- | B+ | B- | AB+ | AB- | O+ | O-
CommissionType    : percentage | fixed
ImageType         : scan | lab | document | other
DoctorQuestionType: text | yes_no | multiple_choice
BookingMode       : flexible | timed | queue (Doctor booking preferences)
```

---

## المرحلة 0 — Foundation (البنية التحتية)
> **لا يبدأ أي فيتشر قبل ما المرحلة دي تخلص 100%**

### 0.1 — Project Scaffold (Clean Architecture)
```
lib/
  core/
    network/          → dio_client, interceptors/, endpoints/
    error/            → failures.dart, exceptions.dart
    utils/            → either_extensions, responsive_utils
    di/               → app_di.dart (يستدعي feature DI)
    router/           → app_router.dart (go_router)
    theme/            → app_colors, app_typography, app_spacing, app_radius
    constants/        → app_sizes, app_durations, app_assets, app_icons
    localization/     → translations/ (ar.json, en.json)
    widgets/          → shared reusable widgets
  features/
    auth/
    doctor/
    reception/
    patients/
    clinic_admin/
    financial/
    inventory/
  main.dart
  app.dart
```
**المخرج**: يشتغل الـ app، يفتح على شاشة Login، مفيش crashes.

---

### 0.2 — Network Layer
- `DioClient` مع Base URL قابل للتغيير حسب الـ tenant
- **Interceptors**:
  - `AuthInterceptor` → بيضيف `Authorization: Bearer {token}` + `X-Tenant-Code: {code}`
  - `LocaleInterceptor` → `Accept-Language: ar | en`
  - `LoggingInterceptor` → في debug mode بس
  - `ErrorInterceptor` → يحول HTTP errors لـ `Failure` objects
  - `RetryInterceptor` → 3 retries على network errors
- **Failures**: `ServerFailure`, `NetworkFailure`, `UnauthorizedFailure`, `NotFoundFailure`, `ValidationFailure`
- **API Response Shape** (متوقع من Laravel):
  ```json
  { "success": true, "data": {...}, "message": "..." }
  { "success": false, "message": "...", "errors": {...} }
  ```

---

### 0.3 — Auth Feature
**Screens**: `LoginScreen`
**API Endpoints to Build**:
- `POST /api/mobile/auth/login` → email, password, tenant_code → token + user_data + permissions[]
- `POST /api/mobile/auth/logout`
- `GET  /api/mobile/auth/me` → user info + permissions (للـ refresh)

**Domain**:
- `AuthRepository` (abstract) → `login()`, `logout()`, `getMe()`
- `LoginUseCase`, `LogoutUseCase`
- `UserEntity` { id, name, email, role, accountType, permissions[], tenantCode }

**Cubit**: `AuthCubit` → states: `AuthInitial | AuthLoading | AuthAuthenticated | AuthUnauthenticated | AuthError`

**Storage**: token + tenantCode في `flutter_secure_storage`

---

### 0.4 — Permissions System
- `PermissionService` في core → يحمل list الـ permissions من الـ user
- `PermissionGuard` في go_router → يمنع الدخول لـ routes بدون permission
- `hasPermission(String permission)` helper accessible من أي مكان
- **Permission Keys** (نفس اللي في Laravel): `dashboard.view`, `reception.view`, `patients.view`, إلخ

---

### 0.5 — App Shell & Adaptive Navigation
- Shell بيتغير حسب `accountType` بعد Login:
  - **Doctor** → Doctor Shell (queue, patients, prescriptions, reports)
  - **Receptionist / ClinicAdmin** → Clinic Shell (reception, appointments, patients, financial, settings)
- Bottom Navigation على mobile، Navigation Rail على tablet
- Deep Links عبر go_router

---

## المرحلة 1 — Doctor Portal
> الـ routes موجودة على Laravel، هنبني API مقابلها

### 1.1 — Doctor Dashboard
**Screen**: `DoctorDashboardScreen`
**Data**: إحصائيات اليوم للدكتور
**API**: `GET /api/mobile/doctor/dashboard`
```json
{
  "today_queue_count": 12,
  "waiting_count": 3,
  "with_doctor_count": 1,
  "completed_today": 8,
  "today_appointments_count": 5,
  "pending_follow_ups": 2
}
```
**Cubit**: `DoctorDashboardCubit` → `loading | loaded(DoctorDashboardEntity) | error`

---

### 1.2 — Waiting Queue (قائمة الانتظار)
**Screens**: `DoctorQueueScreen`
**Data**: `WaitingList` filtered by doctor_id + today + status in [waiting, with_doctor]
**API**:
- `GET  /api/mobile/doctor/queue` → list of WaitingListEntity
- `POST /api/mobile/doctor/queue/{id}/call` → تغيير status لـ with_doctor
- `POST /api/mobile/doctor/queue/{id}/complete` → يفتح شاشة الفحص
- `POST /api/mobile/doctor/queue/{id}/cancel`

**WaitingListEntity**: { id, ticketNumber, patient{name,age,gender,phone}, service, priority, status, entryTime, vitalSigns?, appointmentId? }

**Cubit**: `DoctorQueueCubit` → polling كل 30 ثانية (لا reload للشاشة)
**أولوية** → urgent يظهر أول + badge أحمر

---

### 1.3 — Examination (شاشة الفحص)
**Screens**: `ExaminationScreen` (أهم شاشة في الـ Doctor Portal)
**Sections في الشاشة**:
1. بيانات المريض (اسم، عمر، جنس، رقم الملف)
2. العلامات الحيوية (vital_signs) — من WaitingList
3. أسئلة الدكتور + إجابات المريض (DoctorPatientAnswer)
4. الشكوى الرئيسية (chief_complaint)
5. التشخيص (diagnosis)
6. الملاحظات
7. الزيارات السابقة (sidebar/bottom sheet)
8. المتابعة (followup_days, followup_notes)
9. إرفاق صور (ImageType: scan, lab, document)

**API**:
- `GET  /api/mobile/doctor/examination/{visitId}` → بيانات الزيارة الكاملة
- `POST /api/mobile/doctor/examination/{visitId}/section` → حفظ قسم (chief_complaint | diagnosis | notes)
- `POST /api/mobile/doctor/examination/{visitId}/files` → رفع صور
- `DELETE /api/mobile/doctor/examination/{visitId}/files/{imageId}`
- `POST /api/mobile/doctor/examination/{visitId}/complete` → إغلاق الزيارة (يحتاج followup_days اختياري)
- `GET  /api/mobile/doctor/examination/{visitId}/previous-visit/{prevId}/copy`

**VisitEntity**: { id, visitNumber, patient, doctor, vitalSigns{bp,temp,pulse,weight,height,o2,bmi}, chiefComplaint, diagnosis, notes, status, followupDays, followupNotes, images[], answers[], prescriptions[], previousVisits[] }

**Cubit**: `ExaminationCubit` → auto-save كل section بشكل منفصل

---

### 1.4 — Prescriptions (الروشتة)
**Screens**: `PrescriptionsListScreen`, `PrescriptionFormScreen`, `PrescriptionDetailScreen`
**API**:
- `GET    /api/mobile/doctor/prescriptions` → paginated list
- `POST   /api/mobile/doctor/prescriptions` → إنشاء روشتة
- `GET    /api/mobile/doctor/prescriptions/{id}` → تفاصيل
- `PUT    /api/mobile/doctor/prescriptions/{id}` → تعديل
- `DELETE /api/mobile/doctor/prescriptions/{id}`
- `GET    /api/mobile/doctor/prescriptions/{id}/copy` → نسخ روشتة سابقة

**PrescriptionEntity**: { id, visitId, patientId, items[{drug, dose, frequency, duration, route(MedicineRoute enum), instructions}] }

**Cubit**: `PrescriptionCubit`, `PrescriptionFormCubit`

---

### 1.5 — Doctor Patients
**Screens**: `DoctorPatientListScreen`, `DoctorPatientDetailScreen`
**API**:
- `GET /api/mobile/doctor/patients?search=&page=` → paginated
- `GET /api/mobile/doctor/patients/{id}` → profile + visits history

**PatientSummaryEntity**: { id, name, code, phone, gender, age, totalVisits, lastVisitDate }

---

### 1.6 — Diagnosis Templates
**Screen**: `DiagnosisTemplatesScreen`
**API**:
- `GET    /api/mobile/doctor/diagnosis-templates`
- `POST   /api/mobile/doctor/diagnosis-templates`
- `PUT    /api/mobile/doctor/diagnosis-templates/{id}`
- `DELETE /api/mobile/doctor/diagnosis-templates/{id}`
- `POST   /api/mobile/doctor/diagnosis-templates/{id}/use` → يملأ شاشة الفحص

---

### 1.7 — Doctor Questions (أسئلة الاستقبال)
**Screen**: `DoctorQuestionsScreen` (CRUD + reorder)
**API**:
- `GET    /api/mobile/doctor/questions`
- `POST   /api/mobile/doctor/questions`
- `PUT    /api/mobile/doctor/questions/{id}`
- `DELETE /api/mobile/doctor/questions/{id}`
- `PATCH  /api/mobile/doctor/questions/{id}/toggle`
- `POST   /api/mobile/doctor/questions/reorder`

**DoctorQuestionEntity**: { id, text, type(DoctorQuestionType), options[], isRequired, isActive, sortOrder }

---

### 1.8 — Leave Days (الإجازات)
**Screen**: `DoctorLeaveDaysScreen` (calendar view)
**API**:
- `GET    /api/mobile/doctor/leave-days`
- `POST   /api/mobile/doctor/leave-days` → add leave
- `DELETE /api/mobile/doctor/leave-days/by-date` → by date
- `GET    /api/mobile/doctor/leave-days/appointments-count?date=` → check قبل الحذف

---

### 1.9 — Doctor Reports
**Screen**: `DoctorReportsScreen`
**Data**: إجمالي الأرباح + عدد الزيارات + breakdown per service
**API**: `GET /api/mobile/doctor/reports?from=&to=`

---

### 1.10 — Doctor Profile
**Screen**: `DoctorProfileScreen`
**API**:
- `GET  /api/mobile/doctor/profile`
- `PUT  /api/mobile/doctor/profile` → update info
- `PUT  /api/mobile/doctor/profile/password`
- `POST /api/mobile/doctor/profile/photo`

---

### 1.11 — Internal Chat (مع الاستقبال)
**Screen**: `DoctorChatScreen`
**API** (polling-based):
- `GET  /api/mobile/doctor/chat/init`
- `GET  /api/mobile/doctor/chat/poll?last_id=` → new messages
- `POST /api/mobile/doctor/chat/send`
- `POST /api/mobile/doctor/chat/read`
- `GET  /api/mobile/doctor/chat/unread-count`

---

### 1.12 — Notifications
**Screen**: `DoctorNotificationsScreen`
**API**:
- `GET  /api/mobile/doctor/notifications`
- `POST /api/mobile/doctor/notifications/mark-read`
- `POST /api/mobile/doctor/notifications/mark-all`

---

## المرحلة 2 — Reception Portal

### 2.1 — Reception Dashboard (اللحظية)
**Screen**: `ReceptionDashboardScreen`
**Sections**:
- اليوم: appointments count by status (scheduled/in_consultation/completed/cancelled)
- Active Queue (waiting + with_doctor) مع Doctor filter
- Quick stats: total patients today, pending follow-ups

**API**: `GET /api/mobile/reception/dashboard?doctor_id=`
```json
{
  "appointments_today": { "scheduled": 5, "in_consultation": 1, "completed": 8, "cancelled": 2 },
  "active_queue": [ { WaitingListItem } ],
  "active_waiting_count": 3,
  "pending_follow_ups_count": 4,
  "doctors": [ { id, name, todayCount } ]
}
```

---

### 2.2 — Appointments Management
**Screens**: `AppointmentsScreen` (calendar + list), `AppointmentFormScreen`
**API**:
- `GET  /api/mobile/reception/appointments?date=&doctor_id=&status=&page=`
- `POST /api/mobile/reception/appointments` → حجز موعد جديد
- `GET  /api/mobile/reception/appointments/calendar-events?month=` → للعرض على Calendar
- `POST /api/mobile/reception/appointments/{id}/confirm`
- `POST /api/mobile/reception/appointments/{id}/cancel`

**AppointmentEntity**: { id, appointmentNumber, patient, doctor, service, appointmentDate, appointmentTime, startTime, endTime, bookingType(BookingType), bookingMode, status(AppointmentStatus), servicePrice, notes, totalSessions?, completedSessions? }

---

### 2.3 — Walk-in & Check-in
**Flow داخل Reception Dashboard**:
1. **Walk-in** → اختيار مريض (أو إنشاء جديد) + دكتور + خدمة → `POST /api/mobile/reception/walk-in`
2. **Check-in** للموعد → `POST /api/mobile/reception/check-in/{appointmentId}`

**API**:
- `GET  /api/mobile/reception/available-slots?doctor_id=&date=` → slots متاحة
- `GET  /api/mobile/reception/upcoming-days?doctor_id=` → أيام فيها مواعيد
- `GET  /api/mobile/reception/doctors/{doctorId}/questions` → أسئلة الدكتور للمريض
- `POST /api/mobile/reception/walk-in`
- `POST /api/mobile/reception/check-in/{appointmentId}`

---

### 2.4 — Queue Management (طابور الاستقبال)
**Screen**: `ReceptionQueueScreen`
**Actions على كل item**:
- Toggle Presence (حضور/غياب)
- Save Vitals (vital_signs)
- Call Doctor
- Complete Visit
- Cancel

**API**:
- `GET  /api/mobile/reception/queue?doctor_id=` → live queue
- `POST /api/mobile/reception/{id}/toggle-presence`
- `POST /api/mobile/reception/{id}/save-vitals`
- `POST /api/mobile/reception/{id}/call-doctor`
- `POST /api/mobile/reception/{id}/complete`
- `POST /api/mobile/reception/{id}/cancel`

**VitalSigns Shape**: { bp_systolic, bp_diastolic, temperature, pulse, weight_kg, height_cm, oxygen_level, respiratory_rate, bmi }

---

### 2.5 — Follow-ups
**Screen**: `ReceptionFollowUpsScreen`
**Data**: زيارات مكتملة فيها followup_days ولم يُحدد لها موعد بعد
**API**:
- `GET  /api/mobile/reception/follow-ups`
- `POST /api/mobile/reception/follow-ups/{visitId}/schedule` → حجز موعد متابعة

---

### 2.6 — Internal Chat (مع الأطباء)
**Screen**: `ReceptionInternalChatScreen` — نفس مفهوم 1.11 من ناحية الاستقبال
**API**: نفس هيكل doctor chat بس من prefix `/api/mobile/reception/internal-chat/`

---

### 2.7 — Payment at Reception
**Component (Bottom Sheet)**: يفتح من داخل Queue item
**API**:
- `POST /api/mobile/reception/appointments/{id}/payments` → إضافة دفعة
- `POST /api/mobile/reception/appointments/{id}/refunds`
- `POST /api/mobile/reception/appointments/{id}/discounts`
- `POST /api/mobile/reception/appointments/{id}/services` → إضافة خدمة
- `GET  /api/mobile/reception/appointments/{id}/transactions` → ملخص مالي للموعد

---

## المرحلة 3 — Patient Management

### 3.1 — Patient List & Search
**Screen**: `PatientListScreen`
**API**: `GET /api/mobile/patients?search=&page=`
**PatientListEntity**: { id, code, name, phone, gender, age, lastVisitDate }

---

### 3.2 — Patient Profile (الملف الطبي الكامل)
**Screen**: `PatientProfileScreen` — Tabs:
1. **البيانات الشخصية** (اسم، تليفون، جنس، تاريخ ميلاد، فصيلة دم، تأمين)
2. **التاريخ الطبي** (PatientMedicalHistory — chronic diseases, allergies, surgeries)
3. **الزيارات** (visits history + prescriptions per visit)
4. **المعاملات المالية** (transactions: charge/payment/refund/discount)
5. **الصور والمستندات** (images)

**API**:
- `GET /api/mobile/patients/{id}` → الملف الكامل
- `GET /api/mobile/patients/{id}/visits?page=`
- `GET /api/mobile/patients/{id}/transactions?page=`
- `GET /api/mobile/patients/{id}/images`

**PatientEntity**: { id, code, name, phone, gender, dob, age, bloodType, insuranceName, insuranceCopay, address, medicalHistory{chronicDiseases, allergies, surgeries, notes}, financialSummary{totalCharged, totalPaid, totalRefunded, balance} }

---

### 3.3 — Patient Create / Edit
**Screen**: `PatientFormScreen`
**API**:
- `POST /api/mobile/patients`
- `PUT  /api/mobile/patients/{id}`

**Fields**: name, phone, gender, date_of_birth, blood_type, national_id, address, insurance_name, insurance_number, insurance_copay_percentage, notes

---

### 3.4 — Patient Financial Transactions
**Screen**: داخل Patient Profile Tab
**API**:
- `GET    /api/mobile/patients/{id}/transactions`
- `POST   /api/mobile/patients/{id}/transactions` → إضافة معاملة يدوية
- `DELETE /api/mobile/patients/{id}/transactions/{txId}`

---

## المرحلة 4 — Clinic Admin Panel

### 4.1 — Admin Dashboard
**Screen**: `AdminDashboardScreen`
**Data**: نفس data الـ Laravel `DashboardController`:
- Appointments today (by status)
- Active queue
- Revenue today / month + growth %
- Pending receivables
- Total patients + new today/month
- Doctors on duty
- Low stock alerts (items ≤ min_quantity)
- Weekly patient flow (last 7 days chart)
- Payment methods breakdown (pie chart)
- Recent activity logs

**API**: `GET /api/mobile/admin/dashboard`

---

### 4.2 — Doctors Management
**Screens**: `DoctorsListScreen`, `DoctorFormScreen`, `DoctorDetailScreen`
**API**:
- `GET    /api/mobile/admin/doctors`
- `POST   /api/mobile/admin/doctors`
- `GET    /api/mobile/admin/doctors/{id}`
- `PUT    /api/mobile/admin/doctors/{id}`
- `DELETE /api/mobile/admin/doctors/{id}`
- `PATCH  /api/mobile/admin/doctors/{id}/toggle-status`
- `PUT    /api/mobile/admin/doctors/{id}/booking-preferences`
- `PUT    /api/mobile/admin/doctors/{id}/service-customization`

**DoctorEntity**: { id, name, title, specialization, phone, email, licenseNumber, isActive, commissionType(CommissionType), commissionPercentage, commissionFixed, bookingPreferences{mode, slotDuration, dailyLimit, availability{day: {active,from,to}}} }

---

### 4.3 — Employees & Roles
**Screens**: `EmployeesScreen`, `EmployeeFormScreen`, `RolesScreen`, `RoleFormScreen`
**API**:
- `GET    /api/mobile/admin/employees`
- `POST   /api/mobile/admin/employees`
- `GET    /api/mobile/admin/employees/{id}`
- `PUT    /api/mobile/admin/employees/{id}`
- `DELETE /api/mobile/admin/employees/{id}`
- `GET    /api/mobile/admin/roles`
- `POST   /api/mobile/admin/roles`
- `PUT    /api/mobile/admin/roles/{id}` → assign permissions
- `DELETE /api/mobile/admin/roles/{id}`
- `GET    /api/mobile/admin/permissions` → full list of available permissions

---

### 4.4 — Services Management
**Screen**: `ServicesScreen`, `ServiceFormScreen`
**API**:
- `GET    /api/mobile/admin/services`
- `POST   /api/mobile/admin/services`
- `GET    /api/mobile/admin/services/{id}`
- `PUT    /api/mobile/admin/services/{id}`
- `DELETE /api/mobile/admin/services/{id}`
- `PATCH  /api/mobile/admin/services/{id}/toggle-status`

**ServiceEntity**: { id, name, price, duration, description, isActive, category? }

---

### 4.5 — Clinic Settings
**Screen**: `ClinicSettingsScreen` — Sections:
1. بيانات المنشأة (facility: name, phone, address, logo)
2. إعدادات الاستقبال (reception settings)
3. الباكيجات (packages settings)
4. العملات (currencies)

**API**:
- `GET  /api/mobile/admin/settings/facility`
- `PUT  /api/mobile/admin/settings/facility`
- `GET  /api/mobile/admin/settings/reception`
- `GET/PUT /api/mobile/admin/settings/packages`
- `GET  /api/mobile/admin/settings/currencies`

---

### 4.6 — Payment Methods
**Screen**: داخل Settings
**Data**: قائمة طرق الدفع (cash, card, insurance, etc.) + bank accounts
**API**: `/api/mobile/admin/settings/payment-methods/`

---

### 4.7 — Activity Log
**Screen**: `ActivityLogScreen`
**API**: `GET /api/mobile/admin/activity-log?page=&user_id=&action=`

---

### 4.8 — Notifications
**Screen**: `NotificationsScreen` (shared across roles)
**API**: `GET/POST /api/mobile/notifications/`

---

## المرحلة 5 — Financial Module

### 5.1 — Treasury (الخزينة)
**Screen**: `TreasuryScreen`
**Data**: إجمالي الخزينة + movements (دخل/خروج) + doctor balances
**API**:
- `GET  /api/mobile/financial/treasury`
- `GET  /api/mobile/financial/treasury/doctors/{doctorId}` → رصيد دكتور
- `POST /api/mobile/financial/treasury/withdrawals` → سحب
- `POST /api/mobile/financial/treasury/withdrawals/{id}/refund`

---

### 5.2 — Financial Vouchers (سندات القبض والصرف)
**Screens**: `VouchersScreen`, `VoucherFormScreen`, `VoucherDetailScreen`
**Types**: `receipt` (سند قبض) | `payment_voucher` (سند صرف)
**API**:
- `GET    /api/mobile/financial/receipts?page=`
- `POST   /api/mobile/financial/receipts`
- `GET    /api/mobile/financial/receipts/{id}`
- `PUT    /api/mobile/financial/receipts/{id}`
- `DELETE /api/mobile/financial/receipts/{id}`
- (نفس pattern لـ payment-vouchers)

**FinancialVoucherEntity**: { id, type, amount, paymentMethod, issueDate, patient?, doctor?, description, referenceNumber }

---

### 5.3 — Clinic Invoices
**Screen**: `ClinicInvoicesScreen`
**API**:
- `GET    /api/mobile/financial/invoices?page=`
- `POST   /api/mobile/financial/invoices`
- `GET    /api/mobile/financial/invoices/{id}`
- `DELETE /api/mobile/financial/invoices/{id}`

---

### 5.4 — Promissory Notes (الأوراق التجارية)
**Screen**: `PromissoryNotesScreen`
**API**:
- `GET  /api/mobile/financial/promissory-notes`
- `POST /api/mobile/financial/promissory-notes`
- `POST /api/mobile/financial/promissory-notes/{id}/payments` → سداد قسط

---

### 5.5 — Tax Notices
**Screen**: `TaxNoticesScreen`
**API**: CRUD على `/api/mobile/financial/tax-notices`

---

### 5.6 — Reports & Analytics
**Screen**: `ReportsScreen`
**Report Types** (نفس اللي في Laravel):
- تقرير الإيرادات (revenue by period/doctor/service)
- تقرير المرضى (new/total/by doctor)
- تقرير المواعيد (by status/doctor/period)
- تقرير الأطباء (performance + commissions)
**API**: `GET /api/mobile/financial/reports/{type}?from=&to=&doctor_id=`

---

## المرحلة 6 — Inventory & Purchases

### 6.1 — Inventory Items
**Screen**: `InventoryScreen`, `InventoryItemFormScreen`
**API**:
- `GET    /api/mobile/inventory?category_id=&search=&page=`
- `POST   /api/mobile/inventory`
- `PUT    /api/mobile/inventory/{id}`
- `DELETE /api/mobile/inventory/{id}`
- `POST   /api/mobile/inventory/{id}/adjust` → تعديل يدوي للكمية
- `POST   /api/mobile/inventory/{id}/dispense` → صرف
- `GET    /api/mobile/inventory/{id}/movements` → حركة الصنف

**InventoryItemEntity**: { id, name, category, availableQuantity, minQuantity, unit, costPrice, sellingPrice, isLowStock(computed) }

---

### 6.2 — Inventory Categories
**API**: CRUD على `/api/mobile/inventory/categories`

---

### 6.3 — Purchase Orders
**Screens**: `PurchaseOrdersScreen`, `PurchaseOrderFormScreen`
**Status**: `PurchaseOrderStatus` enum
**API**: CRUD على `/api/mobile/purchases`

---

### 6.4 — Purchase Receipts (استلام المشتريات)
**Screen**: داخل Purchase Order detail
**API**: CRUD على `/api/mobile/purchases/receipts`

---

## المرحلة 7 — Patient Portal (بوابة المريض)
> نفس مفهومها في السيستم — المريض يدخل بحسابه الخاص ويشوف بياناته فقط

### 7.1 — Patient Auth
- Login بـ (phone أو email) + OTP أو password
- بيانات المريض مربوطة بـ `patient_id` + `tenant_code`

### 7.2 — My Appointments
**Screen**: `PatientAppointmentsScreen`
**Data**: appointments بتاعته (قادمة + سابقة)
**API**: `GET /api/mobile/patient/appointments`

### 7.3 — Book Appointment
**Flow**: اختيار دكتور → اختيار يوم → اختيار slot → تأكيد
**API**:
- `GET /api/mobile/patient/doctors` → قائمة الأطباء
- `GET /api/mobile/patient/doctors/{id}/slots?date=`
- `POST /api/mobile/patient/appointments`

### 7.4 — My Medical Record
**Screen**: `PatientMedicalRecordScreen`
**Data**: visits summary + prescriptions (read-only)
**API**: `GET /api/mobile/patient/medical-record`

### 7.5 — My Prescriptions
**Screen**: `PatientPrescriptionsScreen`
**API**: `GET /api/mobile/patient/prescriptions`

### 7.6 — My Invoices
**Screen**: `PatientInvoicesScreen`
**Data**: invoices + transactions (paid/pending)
**API**: `GET /api/mobile/patient/invoices`

### 7.7 — Patient Notifications
**Screen**: `PatientNotificationsScreen`
- تذكير بالموعد القادم
- جاهزية نتيجة تحليل
- تأكيد الحجز

---

## المرحلة 8 — Advanced Features

| # | الفيتشر | التفاصيل |
|---|---|---|
| 8.1 | **Push Notifications** | FCM + APNs — device token يُرسل لـ Laravel عند Login |
| 8.2 | **Real-time Queue** | Server-Sent Events (SSE) أو WebSockets بدل polling — يُقيَّم بعد استقرار المرحلة 2 |
| 8.3 | **Vitals Charts** | رسم بياني لتطور العلامات الحيوية عبر الزيارات — `fl_chart` package |
| 8.4 | **Subscription Management** | عرض الاشتراك الحالي + تجديد — `/api/mobile/admin/subscription` |
| 8.5 | **Support Chat** | تواصل مع Codra Support — `/api/mobile/support` |
| 8.6 | **Offline Support** | Local queue للعمليات الحرجة: check-in, vital signs, basic notes |
| 8.7 | **Lab Orders** | مرهون بوجود جدول `medical_tests` في الـ backend |

---

## الـ API Structure العامة (Laravel Side)

```
/api/mobile/
  auth/         → login, logout, me
  doctor/       → كل بوابة الدكتور
  reception/    → كل بوابة الاستقبال
  patients/     → إدارة المرضى (admin + receptionist)
  admin/        → إدارة العيادة
  financial/    → المالية
  inventory/    → المخزن
  patient/      → بوابة المريض (self-service)
  notifications/→ shared
```

**Middleware Stack** (Laravel):
- `api` + `auth:sanctum` + `tenant.resolve` + `mobile.permissions`

---

## ترتيب التنفيذ الإلزامي

```
0 (Foundation)     → 0.1 → 0.2 → 0.3 → 0.4 → 0.5
1 (Doctor)         → 1.2 → 1.3 → 1.4 → 1.1 → 1.5 → 1.6 → 1.7 → 1.8 → 1.9 → 1.10 → 1.11 → 1.12
2 (Reception)      → 2.1 → 2.3 → 2.4 → 2.2 → 2.5 → 2.6 → 2.7
3 (Patients)       → 3.1 → 3.2 → 3.3 → 3.4
4 (Admin)          → 4.1 → 4.2 → 4.4 → 4.3 → 4.5 → 4.6 → 4.7 → 4.8
5 (Financial)      → 5.1 → 5.6 → 5.2 → 5.3 → 5.4 → 5.5
6 (Inventory)      → 6.2 → 6.1 → 6.3 → 6.4
7 (Patient Portal) → 7.1 → 7.2 → 7.3 → 7.4 → 7.5 → 7.6 → 7.7
8 (Advanced)       → بعد استقرار كل ما سبق
```

> **أولوية القيمة لليوزر**: المرحلة 1 (Doctor) ثم 2 (Reception) هما الأعلى استخداماً يومياً وهيجيبوا أكبر قيمة أسرع.
