import 'dart:convert';

class GithubRepo {
  final String name;
  final String description;
  final int stars;

  GithubRepo(
      {required this.name, required this.description, required this.stars});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'stars': stars,
    };
  }

  factory GithubRepo.fromMap(Map<String, dynamic> map) {
    return GithubRepo(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      stars: map['stargazers_count']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory GithubRepo.fromJson(String source) =>
      GithubRepo.fromMap(json.decode(source));
}
