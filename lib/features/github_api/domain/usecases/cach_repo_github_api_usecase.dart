import 'package:abanoub_ezzat_geithub_api_task/core/errors/failure.dart';
import 'package:abanoub_ezzat_geithub_api_task/features/github_api/domain/entites/github_api_entity.dart';
import 'package:dartz/dartz.dart';

import '../reposetory/github_api_repository.dart';

class CacheReposUseCase {
  final GithubApiRepository githubApiRepository;

  CacheReposUseCase(this.githubApiRepository);

  Future<Either<Failure, void>> call(
      List<GithubRepoEntity> reposToCache) async {
    return await githubApiRepository.cacheRepos(reposToCache);
  }
}
