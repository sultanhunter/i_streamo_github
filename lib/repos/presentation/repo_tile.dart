import 'package:flutter/material.dart';
import 'package:i_streamo_github/repos/domain/github_repo.dart';

class RepoTile extends StatelessWidget {
  final GithubRepo githubRepo;
  const RepoTile({Key? key, required this.githubRepo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(githubRepo.name),
    );
  }
}
