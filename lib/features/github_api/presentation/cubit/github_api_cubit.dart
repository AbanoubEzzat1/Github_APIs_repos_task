import 'package:abanoub_ezzat_geithub_api_task/core/strings/failures.dart';
import 'package:abanoub_ezzat_geithub_api_task/features/github_api/domain/usecases/get_github_api_usecase.dart';
import 'package:abanoub_ezzat_geithub_api_task/features/github_api/presentation/cubit/github_api_states.dart';
import 'package:bloc/bloc.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entites/github_api_entity.dart';
import '../../domain/usecases/clear_cach_repo_github_api_usecase.dart';

class GithubReposCubit extends Cubit<GithubReposState> {
  final GetAllReposUseCase getAllReposUseCase;
  final ClearCacheReposUseCase cacheReposUseCase;

  GithubReposCubit(
      {required this.getAllReposUseCase, required this.cacheReposUseCase})
      : super(GithubReposInitialState());
  List<GithubRepoEntity>? repos;
  Future<void> getGithubRepos(int page) async {
    emit(GithubReposLoadingState());
    final result = await getAllReposUseCase(page);
    result.fold(
      (error) => emit(
          GithubReposErrorState(errorMessage: _mapFailureToMessage(error))),
      (entities) {
        repos = entities;
        return emit(GithubReposLoadedState(repos: entities));
      },
    );
  }

  Future<void> clearCache() async {
    emit(ClearCacheLoadingState());
    final result = await cacheReposUseCase();
    result.fold(
      (error) =>
          emit(ClearCacheErrorState(errorMessage: _mapFailureToMessage(error))),
      (entities) => emit(ClearCacheLoadedState()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case EmptyCacheFailure:
        return EMPTY_CACHE_FAILURE_MESSAGE;
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      default:
        return "Unexpected Error , Please try again later .";
    }
  }
}
