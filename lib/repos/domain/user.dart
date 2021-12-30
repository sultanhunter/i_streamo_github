import 'dart:convert';

class User {
  final String name;
  final String avatarUrl;

  User({required this.name, required this.avatarUrl});

  Map<String, dynamic> toMap() {
    return {
      'login': name,
      'avatar_url': avatarUrl,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['login'] ?? '',
      avatarUrl: map['avatar_url'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  String get getAvatarUrlSmall => '$avatarUrl&s=64';
}
