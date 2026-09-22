import 'package:get_it/get_it.dart';
import 'data/data_sources/doctor_question_remote_data_source.dart';
import 'data/repositories/doctor_question_repository_impl.dart';
import 'domain/repositories/doctor_question_repository.dart';
import 'domain/use_cases/create_doctor_question_use_case.dart';
import 'domain/use_cases/delete_doctor_question_use_case.dart';
import 'domain/use_cases/get_doctor_questions_use_case.dart';
import 'domain/use_cases/reorder_doctor_questions_use_case.dart';
import 'domain/use_cases/toggle_doctor_question_use_case.dart';
import 'domain/use_cases/update_doctor_question_use_case.dart';
import 'presentation/cubit/doctor_questions_cubit.dart';

void setupDoctorQuestionsDi() {
  final sl = GetIt.instance;

  // Data Source
  sl.registerLazySingleton<DoctorQuestionRemoteDataSource>(
    () => DoctorQuestionRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<DoctorQuestionRepository>(
    () => DoctorQuestionRepositoryImpl(sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetDoctorQuestionsUseCase(sl()));
  sl.registerLazySingleton(() => CreateDoctorQuestionUseCase(sl()));
  sl.registerLazySingleton(() => UpdateDoctorQuestionUseCase(sl()));
  sl.registerLazySingleton(() => DeleteDoctorQuestionUseCase(sl()));
  sl.registerLazySingleton(() => ToggleDoctorQuestionUseCase(sl()));
  sl.registerLazySingleton(() => ReorderDoctorQuestionsUseCase(sl()));

  // Cubit (Factory)
  sl.registerFactory(
    () => DoctorQuestionsCubit(
      getQuestionsUseCase: sl(),
      createQuestionUseCase: sl(),
      updateQuestionUseCase: sl(),
      deleteQuestionUseCase: sl(),
      toggleQuestionUseCase: sl(),
      reorderQuestionsUseCase: sl(),
    ),
  );
}
