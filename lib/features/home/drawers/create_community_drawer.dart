import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/models/community.dart';
import 'package:reddit_clone/router.dart';
import 'package:routemaster/routemaster.dart';

class CreateCommunityDrawer extends ConsumerWidget {
  const CreateCommunityDrawer({super.key});

  void navigateCreateCommunityScreen(BuildContext context) {
    Routemaster.of(context).push(RouteNames.createCommunityScreen);
  }

  void navigateCommunityScreen(BuildContext context, Community community) {
    Routemaster.of(context)
        .push('${RouteNames.communityScreen}${community.name}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
                title: const Text('Create a community'),
                leading: const Icon(Icons.add),
                onTap: () => navigateCreateCommunityScreen(context)),
            ref.watch(getUserCommunitiesProvider).when(
                  data: (data) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final community = data[index];
                          return ListTile(
                            onTap: () =>
                                navigateCommunityScreen(context, community),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(community.avatar),
                            ),
                            title: Text('r/${community.name}'),
                          );
                        },
                      ),
                    );
                  },
                  error: (error, _) => ErrorText(errorText: error.toString()),
                  loading: () => const Loader(),
                )
          ],
        ),
      ),
    );
  }
}
