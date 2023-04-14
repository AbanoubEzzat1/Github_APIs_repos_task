import 'package:abanoub_ezzat_geithub_api_task/features/github_api/domain/entites/github_api_entity.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';

abstract class GithubApiRepository {
  Future<Either<Failure, List<GithubRepoEntity>>> getRepos(int page);
  Future<Either<Failure, List<GithubRepoEntity>>> getCachedRepos();
  Future<Either<Failure, void>> cacheRepos(List<GithubRepoEntity> reposToCache);
  Future<Either<Failure, void>> clearCache();
}
