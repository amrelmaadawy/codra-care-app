import 'package:get_it/get_it.dart';
import 'data/data_sources/prescription_remote_data_source.dart';
import 'data/repositories/prescription_repository_impl.dart';
import 'domain/repositories/prescription_repository.dart';
import 'domain/use_cases/copy_prescription_use_case.dart';
import 'domain/use_cases/create_prescription_use_case.dart';
import 'domain/use_cases/delete_prescription_use_case.dart';
import 'domain/use_cases/get_prescription_context_use_case.dart';
import 'domain/use_cases/get_prescription_detail_use_case.dart';
import 'domain/use_cases/get_prescriptions_use_case.dart';
import 'domain/use_cases/mark_printed_use_case.dart';
import 'domain/use_cases/update_prescription_use_case.dart';
import 'presentation/cubit/prescription_detail_cubit.dart';
import 'presentation/cubit/prescription_form_cubit.dart';
import 'presentation/cubit/prescription_list_cubit.dart';

void setupPrescriptionDi() {
  final sl = GetIt.instance;

  // Data Source
  sl.registerLazySingleton<PrescriptionRemoteDataSource>(
    () => PrescriptionRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<PrescriptionRepository>(
    () => PrescriptionRepositoryImpl(sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetPrescriptionsUseCase(sl()));
  sl.registerLazySingleton(() => GetPrescriptionContextUseCase(sl()));
  sl.registerLazySingleton(() => GetPrescriptionDetailUseCase(sl()));
  sl.registerLazySingleton(() => CreatePrescriptionUseCase(sl()));
  sl.registerLazySingleton(() => UpdatePrescriptionUseCase(sl()));
  sl.registerLazySingleton(() => DeletePrescriptionUseCase(sl()));
  sl.registerLazySingleton(() => CopyPrescriptionUseCase(sl()));
  sl.registerLazySingleton(() => MarkPrintedUseCase(sl()));

  // Cubits
  sl.registerFactory(
    () => PrescriptionListCubit(
      getPrescriptionsUseCase: sl(),
      deletePrescriptionUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => PrescriptionFormCubit(
      getPrescriptionContextUseCase: sl(),
      getPrescriptionDetailUseCase: sl(),
      createPrescriptionUseCase: sl(),
      updatePrescriptionUseCase: sl(),
      copyPrescriptionUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => PrescriptionDetailCubit(
      getPrescriptionDetailUseCase: sl(),
      markPrintedUseCase: sl(),
    ),
  );
}
