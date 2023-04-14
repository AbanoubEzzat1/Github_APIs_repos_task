import 'package:abanoub_ezzat_geithub_api_task/core/errors/failure.dart';
import 'package:abanoub_ezzat_geithub_api_task/features/github_api/domain/entites/github_api_entity.dart';
import 'package:dartz/dartz.dart';

import '../reposetory/github_api_repository.dart';

class GetAllReposUseCase {
  final GithubApiRepository githubApiRepository;

  GetAllReposUseCase(this.githubApiRepository);

  Future<Either<Failure, List<GithubRepoEntity>>> call(int page) async {
    return await githubApiRepository.getRepos(page);
  }
}
