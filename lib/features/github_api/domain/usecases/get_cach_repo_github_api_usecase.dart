import 'package:abanoub_ezzat_geithub_api_task/core/errors/failure.dart';
import 'package:abanoub_ezzat_geithub_api_task/features/github_api/domain/entites/github_api_entity.dart';
import 'package:dartz/dartz.dart';

import '../reposetory/github_api_repository.dart';

class GetCacheReposUseCase {
  final GithubApiRepository githubApiRepository;

  GetCacheReposUseCase(this.githubApiRepository);

  Future<Either<Failure, List<GithubRepoEntity>>> call() async {
    return await githubApiRepository.getCachedRepos();
  }
}
