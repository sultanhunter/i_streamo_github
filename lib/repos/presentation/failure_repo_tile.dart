import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_streamo_github/repos/app/cubit/github_repos_cubit.dart';
import 'package:i_streamo_github/repos/domain/github_failure.dart';

class FailureRepoTile extends StatelessWidget {
  final String errorMessage;
  const FailureRepoTile({Key? key, required this.errorMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      textColor: Theme.of(context).colorScheme.onError,
      iconColor: Theme.of(context).colorScheme.onError,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Theme.of(context).errorColor,
        child: ListTile(
          title: const Text(
            'Error, Please Try Again',
          ),
          subtitle: Text(
            errorMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          leading: const SizedBox(
            height: double.infinity,
            child: Icon(Icons.warning),
          ),
          trailing: IconButton(
            onPressed: () {
              context.read<GithubReposCubit>().getNextRepos(isRefresh: false);
            },
            icon: const Icon(Icons.refresh),
          ),
        ),
      ),
    );
  }
}
