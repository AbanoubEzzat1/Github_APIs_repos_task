class GithubRepoEntity {
  final int id;
  final String name;
  final String description;
  final bool fork;
  final String ownerUsername;
  final String ownerHtmlUrl;
  final String repoHtmlUrl;

  const GithubRepoEntity(
      {required this.id,
      required this.name,
      required this.description,
      required this.fork,
      required this.ownerUsername,
      required this.ownerHtmlUrl,
      required this.repoHtmlUrl});
}
