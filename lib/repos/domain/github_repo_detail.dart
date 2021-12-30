import 'dart:convert';

import 'package:dio/dio.dart';

class GithubRepoDetail {
  final String html;

  GithubRepoDetail({
    required this.html,
  });

  Map<String, dynamic> toMap() {
    return {
      'html': html,
    };
  }

  factory GithubRepoDetail.fromMap(Map<String, dynamic> map) {
    return GithubRepoDetail(
      html: map['html'] ?? '',
    );
  }

  factory GithubRepoDetail.fromApiData(Response response) {
    return GithubRepoDetail(html: response.data as String);
  }

  String toJson() => json.encode(toMap());

  factory GithubRepoDetail.fromJson(String source) =>
      GithubRepoDetail.fromMap(json.decode(source));
}
