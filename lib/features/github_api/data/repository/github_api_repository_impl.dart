import 'package:abanoub_ezzat_geithub_api_task/features/github_api/data/data_sources/github_api_remote_data_source.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entites/github_api_entity.dart';
import '../../domain/reposetory/github_api_repository.dart';
import '../data_sources/github_api_local_data_source.dart';
import '../models/github_api_models.dart';

class GithubRepoRepositoryImpl implements GithubApiRepository {
  final GithubApiLocalDataSource localDataSource;
  final GithubApiRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  GithubRepoRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<GithubRepoEntity>>> getRepos(int page) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteRepos = await remoteDataSource.getRepos(page);
        await localDataSource.cacheRepos(remoteRepos);
        return Right(remoteRepos);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localPosts = await localDataSource.getCachedRepos();
        return Right(localPosts);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
    // try {
    //   final remoteRepos = await remoteDataSource.getRepos(page);
    //   await localDataSource.cacheRepos(remoteRepos);
    //   return Right(remoteRepos);
    // } on ServerException {
    //   return Left(ServerFailure());
    // }
  }

  @override
  Future<Either<Failure, List<GithubRepoEntity>>> getCachedRepos() async {
    try {
      final cachedRepos = await localDataSource.getCachedRepos();
      return Right(cachedRepos);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> cacheRepos(
      List<GithubRepoEntity> reposToCache) async {
    final List<GithubRepoModel> reposToCacheModels = reposToCache
        .map((repo) => GithubRepoModel(
              id: repo.id,
              name: repo.name,
              description: repo.description,
              fork: repo.fork,
              ownerUsername: repo.ownerUsername,
              ownerHtmlUrl: repo.ownerHtmlUrl,
              repoHtmlUrl: repo.repoHtmlUrl,
            ))
        .toList();

    try {
      await localDataSource.cacheRepos(reposToCacheModels);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> clearCache() async {
    try {
      await localDataSource.clearReposCache();
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
