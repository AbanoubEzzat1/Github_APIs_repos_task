import '../../domain/entites/github_api_entity.dart';

abstract class GithubReposState {
  const GithubReposState();
}

class GithubReposInitialState extends GithubReposState {}

class GithubReposLoadingState extends GithubReposState {}

class GithubReposLoadedState extends GithubReposState {
  final List<GithubRepoEntity> repos;

  const GithubReposLoadedState({required this.repos});
}

class GithubReposErrorState extends GithubReposState {
  final String errorMessage;

  const GithubReposErrorState({required this.errorMessage});
}

class ClearCacheLoadingState extends GithubReposState {}

class ClearCacheLoadedState extends GithubReposState {}

class ClearCacheErrorState extends GithubReposState {
  final String errorMessage;

  const ClearCacheErrorState({required this.errorMessage});
}
