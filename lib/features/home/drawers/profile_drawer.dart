import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/theme/pallete.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void logout(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logout();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 15),
            CircleAvatar(
              backgroundImage: NetworkImage(user!.profilePic),
              radius: 70,
            ),
            SizedBox(height: 10),
            Text(
              'u/${user.name}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            ListTile(
              title: const Text('My Profile'),
              leading: const Icon(Icons.person),
              // onTap: () => navigateCreateCommunityScreen(context),
            ),
            ListTile(
              onTap: () => logout(ref),
              title: const Text(
                'Log Out',
              ),
              leading: Icon(
                Icons.logout_outlined,
                color: Pallete.redColor,
              ),
              // onTap: () => navigateCreateCommunityScreen(context),
            ),
            Switch.adaptive(
              value: true,
              onChanged: (value) {},
            )
          ],
        ),
      ),
    );
  }
}
