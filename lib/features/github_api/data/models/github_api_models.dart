import '../../domain/entites/github_api_entity.dart';

class GithubRepoModel extends GithubRepoEntity {
  const GithubRepoModel({
    required int id,
    required String name,
    required String description,
    required bool fork,
    required String ownerUsername,
    required String ownerHtmlUrl,
    required String repoHtmlUrl,
  }) : super(
          id: id,
          name: name,
          description: description,
          fork: fork,
          ownerUsername: ownerUsername,
          ownerHtmlUrl: ownerHtmlUrl,
          repoHtmlUrl: repoHtmlUrl,
        );

  factory GithubRepoModel.fromJson(Map<String, dynamic> json) {
    return GithubRepoModel(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? "",
      fork: json['fork'],
      ownerUsername: json['owner']['login'],
      ownerHtmlUrl: json['owner']['html_url'],
      repoHtmlUrl: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'fork': fork,
      'owner': {
        'login': ownerUsername,
        'html_url': ownerHtmlUrl,
      },
      'url': repoHtmlUrl,
    };
  }
}
