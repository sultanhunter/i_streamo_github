import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_streamo_github/auth/app/cubits/cubit/authentication_cubit.dart';
import 'package:i_streamo_github/repos/app/cubit/github_repos_cubit.dart';
import 'package:i_streamo_github/repos/presentation/failure_repo_tile.dart';
import 'package:i_streamo_github/repos/presentation/loading_repo_tile.dart';
import 'package:i_streamo_github/repos/presentation/no_connection_toast.dart';
import 'package:i_streamo_github/repos/presentation/repo_tile.dart';
import 'package:visibility_detector/visibility_detector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GithubReposCubit>().getNextRepos(isRefresh: false);
  }

  bool canLoadNextPage = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is UnAuthenticated) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/authentication', (route) => false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
          ),
          title: const Text('Github Repos'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  context.read<AuthenticationCubit>().logOut();
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: SafeArea(
          child: _PaginatedListView(),
        ),
      ),
    );
  }
}

class _PaginatedListView extends StatelessWidget {
  _PaginatedListView({
    Key? key,
  }) : super(key: key);

  bool canLoadNextPage = false;
  bool hasAlreadyShownSnackBar = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GithubReposCubit, GithubReposState>(
        listener: (context, state) {
      if (state is GithubReposNewDataReceived) {
        if (!state.isFresh && !hasAlreadyShownSnackBar) {
          showNoConnectionToast('No connection, data may be outdated', context);
          hasAlreadyShownSnackBar = true;
        }
        canLoadNextPage = state.isNextPageAvailable;
      } else if (state is GithubReposInitial) {
        canLoadNextPage = true;
      } else {
        canLoadNextPage = false;
      }
    }, builder: (context, state) {
      return ListView.builder(
        itemBuilder: (context, index) {
          if (state is GithubReposNewDataReceived) {
            if (state.repos.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(10.0),
                child: Card(
                  child: Text('No Results to Display'),
                ),
              );
            }
            final _thirdLastIndex = state.repos.length - 3;
            if (index == _thirdLastIndex) {
              return VisibilityDetector(
                  key: const Key('third-item'),
                  child: RepoTile(githubRepo: state.repos[index]),
                  onVisibilityChanged: (visibility) {
                    if (visibility.visibleFraction > 0 && canLoadNextPage) {
                      print('3rd last visible');
                      context
                          .read<GithubReposCubit>()
                          .getNextRepos(isRefresh: false);
                    }
                  });
            }
            return RepoTile(githubRepo: state.repos[index]);
          } else if (state is GithubReposLoading) {
            if (index < state.repos.length) {
              return RepoTile(githubRepo: state.repos[index]);
            } else {
              return const LoadingRepoTile();
            }
          } else if (state is GithubReposError) {
            if (index < state.repos.length) {
              return RepoTile(githubRepo: state.repos[index]);
            } else {
              final _errorMessage = state.errorMessage;
              return FailureRepoTile(
                errorMessage: _errorMessage,
              );
            }
          } else {
            return Text('some');
          }
        },
        itemCount: state is GithubReposNewDataReceived
            ? state.repos.length
            : state is GithubReposLoading
                ? state.repos.length + state.itemsPerPage
                : state is GithubReposError
                    ? state.repos.length
                    : 0,
      );
    });
  }
}
