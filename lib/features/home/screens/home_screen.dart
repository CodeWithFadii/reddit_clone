import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/home/drawers/create_community_drawer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      drawer: CreateCommunityDrawer(),
      appBar: AppBar(
        title: Text('Home'),
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () => openDrawer(context),
            icon: Icon(Icons.menu),
          );
        }),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: CircleAvatar(
              radius: 17,
              backgroundImage: NetworkImage(
                user.profilePic,
              ),
            ),
          ),
          SizedBox(width: 5),
        ],
      ),
    );
  }

  void openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }
}
