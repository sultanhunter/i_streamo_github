import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:i_streamo_github/repos/domain/github_repo.dart';
import 'package:i_streamo_github/repos/presentation/github_repo_detail_screen.dart';

class RepoTile extends StatelessWidget {
  final GithubRepo githubRepo;

  const RepoTile({Key? key, required this.githubRepo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(githubRepo.name),
      subtitle: Text(
        githubRepo.description,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      leading: Hero(
        tag: githubRepo.name,
        child: CircleAvatar(
          backgroundImage:
              CachedNetworkImageProvider(githubRepo.user.getAvatarUrlSmall),
          backgroundColor: Colors.transparent,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.star_border),
          Text(
            githubRepo.stars.toString(),
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => GithubRepoDetailsScreen(githubRepo: githubRepo),
          ),
        );
      },
    );
  }
}
