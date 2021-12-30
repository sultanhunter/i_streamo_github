import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:i_streamo_github/repos/domain/github_failure.dart';
import 'package:i_streamo_github/repos/domain/github_repo.dart';
import 'package:i_streamo_github/repos/infrastructure/github_repo_repository.dart';
import 'package:i_streamo_github/repos/infrastructure/pagination_config.dart';

part 'github_repos_state.dart';

class GithubReposCubit extends Cubit<GithubReposState> {
  final GithubRepository _githubRepository;

  GithubReposCubit(
    this._githubRepository,
  ) : super(GithubReposInitial());

  int page = 1;
  Future<void> getNextRepos({required bool isRefresh}) async {
    if (isRefresh) {
      page = 1;
    }
    late final List<GithubRepo> _previousRepos;
    if (state is GithubReposNewDataReceived) {
      final _currentState = state as GithubReposNewDataReceived;
      _previousRepos = _currentState.repos;
    } else if (state is GithubReposError) {
      final _currentState = state as GithubReposError;
      _previousRepos = _currentState.repos;
    } else {
      _previousRepos = [];
    }
    emit(GithubReposLoading(
        itemsPerPage: PaginationConfig.itemsPerPage, repos: _previousRepos));
    final _successOrFailure = await _githubRepository.getRepos(page);

    _successOrFailure.fold((l) {
      if (l is GithubFailureApi) {
        emit(GithubReposError(
            errorMessage:
                l.errorMessage ?? 'Something Went Wrong, Please Try Again',
            repos: _previousRepos));
      } else {
        emit(GithubReposNewDataReceived(
            isFresh: false, repos: _previousRepos, isNextPageAvailable: true));
      }
    }, (r) {
      page++;
      final _isFresh = r.isFresh;
      final _isNextPageAvailable = r.isNextPageAvailable;

      final List<GithubRepo> _totalRepos = [..._previousRepos, ...r.entity];

      emit(GithubReposNewDataReceived(
          isFresh: _isFresh,
          repos: _totalRepos,
          isNextPageAvailable: _isNextPageAvailable));
    });
  }

  Future<void> deleteAllUserData() async {
    _githubRepository.deleteAllUserData();
  }
}
