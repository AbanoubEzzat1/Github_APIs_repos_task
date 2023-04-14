import 'package:abanoub_ezzat_geithub_api_task/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../reposetory/github_api_repository.dart';

class ClearCacheReposUseCase {
  final GithubApiRepository githubApiRepository;

  ClearCacheReposUseCase(this.githubApiRepository);

  Future<Either<Failure, void>> call() async {
    return await githubApiRepository.clearCache();
  }
}
