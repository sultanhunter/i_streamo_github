import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_streamo_github/repos/app/cubit/github_repos_cubit.dart';
import 'package:i_streamo_github/repos/domain/github_repo.dart';
import 'package:i_streamo_github/repos/presentation/repo_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GithubReposCubit>().getNextRepos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: BlocBuilder<GithubReposCubit, GithubReposState>(
          builder: (context, state) {
        return ListView.builder(
          itemBuilder: (context, index) {
            if (state is GithubReposNewDataReceived) {
              return RepoTile(githubRepo: state.repos[index]);
            } else if (state is GithubReposLoading) {
              return SizedBox();
            } else if (state is GithubReposError) {
              return SizedBox();
            } else {
              return SizedBox();
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
      })),
    );
  }
}
