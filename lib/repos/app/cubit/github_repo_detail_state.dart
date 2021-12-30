part of 'github_repo_detail_cubit.dart';

abstract class GithubRepoDetailState extends Equatable {
  const GithubRepoDetailState();

  @override
  List<Object> get props => [];
}

class GithubRepoDetailInitial extends GithubRepoDetailState {}

class GithubRepoDetailLoading extends GithubRepoDetailState {}

class GithubRepoDetailDataReceived extends GithubRepoDetailState {
  final GithubRepoDetail githubRepoDetail;
  final bool isFresh;

  const GithubRepoDetailDataReceived(
      {required this.githubRepoDetail, required this.isFresh});
}

class GithubRepoDetailError extends GithubRepoDetailState {
  final String? errorMessage;

  const GithubRepoDetailError({this.errorMessage});
}
