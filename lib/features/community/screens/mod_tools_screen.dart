import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/router.dart';
import 'package:routemaster/routemaster.dart';

class ModToolsScreen extends ConsumerWidget {
  const ModToolsScreen({super.key, required this.name});
  final String name;

  void navigateToEditCommunityScreen(BuildContext context) {
    Routemaster.of(context).push(RouteNames.communityEditScreen + name);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mod Tools'),
      ),
      body: SafeArea(
          child: Column(
        children: [
          const ListTile(
            leading: Icon(Icons.add_moderator),
            title: Text('Add Moderators'),
          ),
          ListTile(
            onTap: () {
              navigateToEditCommunityScreen(context);
            },
            leading: const Icon(Icons.edit),
            title: const Text('Edit Community'),
          )
        ],
      )),
    );
  }
}
