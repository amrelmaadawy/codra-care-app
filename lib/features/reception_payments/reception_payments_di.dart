import 'package:get_it/get_it.dart';
import 'data/data_sources/reception_payments_remote_data_source.dart';
import 'data/repositories/reception_payments_repository_impl.dart';
import 'domain/repositories/reception_payments_repository.dart';
import 'domain/use_cases/add_appointment_service_use_case.dart';
import 'domain/use_cases/add_discount_use_case.dart';
import 'domain/use_cases/add_payments_use_case.dart';
import 'domain/use_cases/add_refund_use_case.dart';
import 'domain/use_cases/get_financial_snapshot_use_case.dart';
import 'domain/use_cases/get_service_options_use_case.dart';
import 'domain/use_cases/get_voucher_preview_use_case.dart';
import 'presentation/cubits/reception_payment_cubit.dart';
import 'presentation/cubits/service_options_cubit.dart';

void setupReceptionPaymentsDi([GetIt? locator]) {
  final sl = locator ?? GetIt.instance;

  // Data sources
  sl.registerLazySingleton<ReceptionPaymentsRemoteDataSource>(
    () => ReceptionPaymentsRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<ReceptionPaymentsRepository>(
    () => ReceptionPaymentsRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetFinancialSnapshotUseCase(sl()));
  sl.registerLazySingleton(() => AddPaymentsUseCase(sl()));
  sl.registerLazySingleton(() => AddRefundUseCase(sl()));
  sl.registerLazySingleton(() => AddDiscountUseCase(sl()));
  sl.registerLazySingleton(() => AddAppointmentServiceUseCase(sl()));
  sl.registerLazySingleton(() => GetServiceOptionsUseCase(sl()));
  sl.registerLazySingleton(() => GetVoucherPreviewUseCase(sl()));

  // Cubits
  sl.registerFactoryParam<ReceptionPaymentCubit, int, void>(
    (appointmentId, _) => ReceptionPaymentCubit(
      appointmentId: appointmentId,
      getSnapshotUseCase: sl(),
      addPaymentsUseCase: sl(),
      addRefundUseCase: sl(),
      addDiscountUseCase: sl(),
      addServiceUseCase: sl(),
    ),
  );

  sl.registerFactoryParam<ServiceOptionsCubit, int, void>(
    (appointmentId, _) => ServiceOptionsCubit(
      getServiceOptionsUseCase: sl(),
      appointmentId: appointmentId,
    ),
  );
}
