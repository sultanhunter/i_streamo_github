import 'package:dio/dio.dart';

class GithubHeaders {
  final String? etag;
  final PaginationLink? paginationLink;

  GithubHeaders({this.etag, this.paginationLink});

  factory GithubHeaders.parse(Response response) {
    return GithubHeaders(
      etag: response.headers.map['ETag']!.elementAt(0),
      paginationLink: PaginationLink.parse(
        response.headers.map['Link']?[0].split(',') ?? [],
        requestUrl: response.requestOptions.uri.toString(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'etag': etag,
      'paginationLink': paginationLink?.toJson(),
    };
  }

  factory GithubHeaders.fromJson(Map<String, dynamic> map) {
    return GithubHeaders(
      etag: map['etag'],
      paginationLink: map['paginationLink'] != null
          ? PaginationLink.fromJson(map['paginationLink'])
          : null,
    );
  }
}

class PaginationLink {
  final int maxPage;

  PaginationLink({required this.maxPage});

  factory PaginationLink.parse(List<String> values,
      {required String requestUrl}) {
    return PaginationLink(
        maxPage: _extractMaxPageNumber(values.firstWhere(
            (element) => element.contains('rel="last"'),
            orElse: () => requestUrl)));
  }

  static int _extractMaxPageNumber(String value) {
    final uriString = RegExp(
      r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)',
    ).stringMatch(value);

    return int.parse(Uri.parse(uriString!).queryParameters['page'] ?? '0');
  }

  Map<String, dynamic> toJson() {
    return {
      'maxPage': maxPage,
    };
  }

  factory PaginationLink.fromJson(Map<String, dynamic> map) {
    return PaginationLink(
      maxPage: map['maxPage']?.toInt() ?? 0,
    );
  }
}
