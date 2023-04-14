// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:abanoub_ezzat_geithub_api_task/features/github_api/data/models/github_api_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class GithubApiLocalDataSource {
  Future<void> cacheRepos(List<GithubRepoModel> repoModels);
  Future<List<GithubRepoModel>> getCachedRepos();
  Future<void> clearReposCache();
}

const String CACHED_REPOS = 'CACHED_REPOS';

class GithubApiLocalDataSourceImpl implements GithubApiLocalDataSource {
  final SharedPreferences sharedPreferences;

  GithubApiLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheRepos(List<GithubRepoModel> repoModels) {
    return sharedPreferences.setString(
      CACHED_REPOS,
      json.encode(
        repoModels.map((repoModel) => repoModel.toJson()).toList(),
      ),
    );
  }

  @override
  Future<List<GithubRepoModel>> getCachedRepos() {
    final jsonString = sharedPreferences.getString(CACHED_REPOS);
    if (jsonString != null) {
      final List<dynamic> repoList = json.decode(jsonString);
      final List<GithubRepoModel> repoModels = repoList
          .map((repoJson) => GithubRepoModel.fromJson(repoJson))
          .toList();
      return Future.value(repoModels);
    } else {
      return Future.value([]);
    }
  }

  @override
  Future<void> clearReposCache() async {
    await sharedPreferences.remove(CACHED_REPOS);
  }
}
