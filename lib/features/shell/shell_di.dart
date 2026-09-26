import 'package:get_it/get_it.dart';
import 'domain/services/shell_navigation_resolver.dart';

void setupShellDi() {
  final sl = GetIt.instance;
  sl.registerLazySingleton<ShellNavigationResolver>(
    () => const ShellNavigationResolver(),
  );
}
