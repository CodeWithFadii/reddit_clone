import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/home/delegates/community_search_delegate.dart';
import 'package:reddit_clone/features/home/drawers/create_community_drawer.dart';
import 'package:reddit_clone/features/home/drawers/profile_drawer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      drawer: const CreateCommunityDrawer(),
      endDrawer: const ProfileDrawer(),
      appBar: AppBar(
        title: const Text('Home'),
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () => openDrawer(context),
            icon: const Icon(Icons.menu),
          );
        }),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: CommunitySearchDelegate(ref: ref));
            },
            icon: const Icon(Icons.search),
          ),
          Builder(builder: (context) {
            return IconButton(
              onPressed: () {
                openEndDrawer(context);
              },
              icon: CircleAvatar(
                radius: 17,
                backgroundImage: NetworkImage(
                  user.profilePic,
                ),
              ),
            );
          }),
          const SizedBox(width: 5),
        ],
      ),
    );
  }

  void openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void openEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }
}
