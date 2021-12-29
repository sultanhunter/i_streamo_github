part of 'github_repos_cubit.dart';

abstract class GithubReposState extends Equatable {
  const GithubReposState();

  @override
  List<Object> get props => [];
}

class GithubReposInitial extends GithubReposState {}

class GithubReposLoading extends GithubReposState {
  final int itemsPerPage;
  final List<GithubRepo> repos;

  const GithubReposLoading({
    required this.itemsPerPage,
    required this.repos,
  });
}

class GithubReposNewDataReceived extends GithubReposState {
  final List<GithubRepo> repos;
  final bool isNextPageAvailable;
  final bool isFresh;

  const GithubReposNewDataReceived({
    required this.isFresh,
    required this.repos,
    required this.isNextPageAvailable,
  });
}

class GithubReposError extends GithubReposState {
  final String? errorMessage;
  final List<GithubRepo> repos;

  const GithubReposError({
    this.errorMessage,
    required this.repos,
  });
}
