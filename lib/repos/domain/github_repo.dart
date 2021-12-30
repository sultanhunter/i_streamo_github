import 'dart:convert';

import 'package:i_streamo_github/repos/domain/user.dart';

class GithubRepo {
  final User user;
  final String name;
  final String description;
  final int stars;

  GithubRepo(
      {required this.user,
      required this.name,
      required this.description,
      required this.stars});

  Map<String, dynamic> toMap() {
    return {
      'user': user.toMap(),
      'name': name,
      'description': description,
      'stargazers_count': stars,
    };
  }

  factory GithubRepo.fromMap(Map<String, dynamic> map) {
    return GithubRepo(
      user: User.fromMap(map['user']),
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      stars: map['stargazers_count']?.toInt() ?? 0,
    );
  }

  factory GithubRepo.fromApiData(Map<String, dynamic> map) {
    final _user = User.fromMap(map['owner'] as Map<String, dynamic>);

    return GithubRepo(
        user: _user,
        name: map['name'] ?? '',
        description: map['description'] ?? '',
        stars: map['stargazers_count']?.toInt() ?? 0);
  }

  String toJson() => json.encode(toMap());

  factory GithubRepo.fromJson(String source) =>
      GithubRepo.fromMap(json.decode(source));

  String get fullName => '${user.name}/$name';
}
