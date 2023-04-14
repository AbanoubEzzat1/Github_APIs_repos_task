// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'package:abanoub_ezzat_geithub_api_task/core/errors/exceptions.dart';
import 'package:http/http.dart' as http;

import '../models/github_api_models.dart';

abstract class GithubApiRemoteDataSource {
  Future<List<GithubRepoModel>> getRepos(int page);
}

class GithubApiRemoteDataSourceImpl implements GithubApiRemoteDataSource {
  final http.Client client;

  GithubApiRemoteDataSourceImpl({required this.client});

  static const BASE_URL = "https://api.github.com";

  @override
  Future<List<GithubRepoModel>> getRepos(int page) async {
    final response = await client.get(
      Uri.parse('$BASE_URL/repositories?page=$page&per_page=10'),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      final List<dynamic> decodedJson = jsonDecode(response.body);
      final List<GithubRepoModel> repos = decodedJson
          .map<GithubRepoModel>(
              (jsonRepo) => GithubRepoModel.fromJson(jsonRepo))
          .toList();

      return repos;
    } else {
      throw ServerException();
    }
  }
}
