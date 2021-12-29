abstract class GithubFailure {}

class GithubFailureApi extends GithubFailure {
  final String? errorMessage;

  GithubFailureApi({this.errorMessage});
}
