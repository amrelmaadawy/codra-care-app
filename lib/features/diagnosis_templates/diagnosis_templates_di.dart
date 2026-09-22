import 'package:get_it/get_it.dart';
import 'data/data_sources/diagnosis_template_remote_data_source.dart';
import 'data/repositories/diagnosis_template_repository_impl.dart';
import 'domain/repositories/diagnosis_template_repository.dart';
import 'domain/use_cases/create_diagnosis_template_use_case.dart';
import 'domain/use_cases/delete_diagnosis_template_use_case.dart';
import 'domain/use_cases/get_diagnosis_template_detail_use_case.dart';
import 'domain/use_cases/get_diagnosis_templates_for_exam_use_case.dart';
import 'domain/use_cases/get_diagnosis_templates_use_case.dart';
import 'domain/use_cases/update_diagnosis_template_use_case.dart';
import 'domain/use_cases/use_diagnosis_template_use_case.dart';
import 'presentation/cubit/diagnosis_template_list_cubit.dart';

void setupDiagnosisTemplatesDi() {
  final sl = GetIt.instance;

  // Data Source
  sl.registerLazySingleton<DiagnosisTemplateRemoteDataSource>(
    () => DiagnosisTemplateRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<DiagnosisTemplateRepository>(
    () => DiagnosisTemplateRepositoryImpl(sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetDiagnosisTemplatesUseCase(sl()));
  sl.registerLazySingleton(() => GetDiagnosisTemplatesForExamUseCase(sl()));
  sl.registerLazySingleton(() => GetDiagnosisTemplateDetailUseCase(sl()));
  sl.registerLazySingleton(() => CreateDiagnosisTemplateUseCase(sl()));
  sl.registerLazySingleton(() => UpdateDiagnosisTemplateUseCase(sl()));
  sl.registerLazySingleton(() => DeleteDiagnosisTemplateUseCase(sl()));
  sl.registerLazySingleton(() => UseDiagnosisTemplateUseCase(sl()));

  // Cubit
  sl.registerFactory(
    () => DiagnosisTemplateListCubit(
      getTemplatesUseCase: sl(),
      createTemplateUseCase: sl(),
      updateTemplateUseCase: sl(),
      deleteTemplateUseCase: sl(),
      useTemplateUseCase: sl(),
    ),
  );
}
