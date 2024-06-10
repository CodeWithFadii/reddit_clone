import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/router.dart';
import 'package:routemaster/routemaster.dart';

class CreateCommunityDrawer extends ConsumerWidget {
  const CreateCommunityDrawer({super.key});

  void navigateCreateCommunityScreen(BuildContext context) {
    Routemaster.of(context).push(RouteNames.createCommunityScreen);
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
                onTap: () => navigateCreateCommunityScreen(context))
          ],
        ),
      ),
    );
  }
}
