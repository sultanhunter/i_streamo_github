import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:i_streamo_github/repos/domain/github_failure.dart';
import 'package:i_streamo_github/repos/domain/github_repo_detail.dart';
import 'package:i_streamo_github/repos/infrastructure/github_repo_details/github_repo_detail_repository.dart';

part 'github_repo_detail_state.dart';

class GithubRepoDetailCubit extends Cubit<GithubRepoDetailState> {
  final GithubRepoDetailRepository _githubRepoDetailRepository;
  GithubRepoDetailCubit(this._githubRepoDetailRepository)
      : super(GithubRepoDetailInitial());

  Future<void> getRepoData(String fullName) async {
    emit(GithubRepoDetailLoading());
    final _successOrFailure =
        await _githubRepoDetailRepository.getReadmeHtml(fullName);

    _successOrFailure.fold((l) {
      if (l is GithubFailureApi) {
        emit(GithubRepoDetailError(errorMessage: l.errorMessage));
      } else {
        emit(GithubRepoDetailError(
            errorMessage:
                'Please Connect to Internet Once to get the Repository Data'));
      }
    }, (r) {
      emit(GithubRepoDetailDataReceived(
          githubRepoDetail: r.entity, isFresh: r.isFresh));
    });
  }
}
