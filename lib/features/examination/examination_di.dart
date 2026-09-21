import 'package:get_it/get_it.dart';
import 'data/data_sources/examination_remote_data_source.dart';
import 'data/repositories/examination_repository_impl.dart';
import 'domain/repositories/examination_repository.dart';
import 'domain/use_cases/complete_examination_use_case.dart';
import 'domain/use_cases/copy_previous_visit_use_case.dart';
import 'domain/use_cases/delete_file_use_case.dart';
import 'domain/use_cases/get_examination_use_case.dart';
import 'domain/use_cases/save_section_use_case.dart';
import 'domain/use_cases/start_examination_use_case.dart';
import 'domain/use_cases/upload_files_use_case.dart';
import 'presentation/cubit/examination_cubit.dart';

void setupExaminationDi() {
  final sl = GetIt.instance;

  // Data Source
  sl.registerLazySingleton<ExaminationRemoteDataSource>(
    () => ExaminationRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<ExaminationRepository>(
    () => ExaminationRepositoryImpl(sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => StartExaminationUseCase(sl()));
  sl.registerLazySingleton(() => GetExaminationUseCase(sl()));
  sl.registerLazySingleton(() => SaveSectionUseCase(sl()));
  sl.registerLazySingleton(() => UploadFilesUseCase(sl()));
  sl.registerLazySingleton(() => DeleteFileUseCase(sl()));
  sl.registerLazySingleton(() => CompleteExaminationUseCase(sl()));
  sl.registerLazySingleton(() => CopyPreviousVisitUseCase(sl()));

  // Cubit
  sl.registerFactoryParam<ExaminationCubit, int, void>(
    (visitId, _) => ExaminationCubit(
      visitId: visitId,
      getExaminationUseCase: sl(),
      saveSectionUseCase: sl(),
      uploadFilesUseCase: sl(),
      deleteFileUseCase: sl(),
      completeExaminationUseCase: sl(),
      copyPreviousVisitUseCase: sl(),
    ),
  );
}
