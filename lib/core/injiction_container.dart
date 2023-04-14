import 'package:abanoub_ezzat_geithub_api_task/core/network/network_info.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../features/github_api/data/data_sources/github_api_local_data_source.dart';
import '../features/github_api/data/data_sources/github_api_remote_data_source.dart';
import '../features/github_api/data/repository/github_api_repository_impl.dart';
import '../features/github_api/domain/reposetory/github_api_repository.dart';
import '../features/github_api/domain/usecases/cach_repo_github_api_usecase.dart';
import '../features/github_api/domain/usecases/clear_cach_repo_github_api_usecase.dart';
import '../features/github_api/domain/usecases/get_cach_repo_github_api_usecase.dart';
import '../features/github_api/domain/usecases/get_github_api_usecase.dart';
import '../features/github_api/presentation/cubit/github_api_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //-- FeaturePosts

  // bloc
  sl.registerFactory(() =>
      GithubReposCubit(getAllReposUseCase: sl(), cacheReposUseCase: sl()));

  //  UseCases
  sl.registerLazySingleton(() => CacheReposUseCase(sl()));
  sl.registerLazySingleton(() => ClearCacheReposUseCase(sl()));
  sl.registerLazySingleton(() => GetCacheReposUseCase(sl()));
  sl.registerLazySingleton(() => GetAllReposUseCase(sl()));

  // Repository
  sl.registerLazySingleton<GithubApiRepository>(() => GithubRepoRepositoryImpl(
        localDataSource: sl(),
        remoteDataSource: sl(),
        networkInfo: sl(),
      ));

  // Datasources
  sl.registerLazySingleton<GithubApiRemoteDataSource>(
      () => GithubApiRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<GithubApiLocalDataSource>(
      () => GithubApiLocalDataSourceImpl(sharedPreferences: sl()));

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
