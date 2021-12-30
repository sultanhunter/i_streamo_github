import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingRepoTile extends StatelessWidget {
  const LoadingRepoTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        child: ListTile(
          title: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: 14,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.teal, borderRadius: BorderRadius.circular(2.0)),
            ),
          ),
          subtitle: Container(
            height: 14,
            width: 250,
            decoration: BoxDecoration(
                color: Colors.teal, borderRadius: BorderRadius.circular(2.0)),
          ),
          leading: const CircleAvatar(),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star_border),
              Text(
                '',
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ),
        baseColor: Colors.teal.shade400,
        highlightColor: Colors.teal.shade200);
  }
}
