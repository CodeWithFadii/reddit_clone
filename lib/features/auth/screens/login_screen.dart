import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/common/login_button.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/theme/pallete.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          Constants.logo,
          scale: 11,
        ),
        actions: [
          Text(
            'skip',
            style: TextStyle(
              color: Pallete.blueColor,
              fontSize: 18,
            ),
          ),
          const SizedBox(width: 12)
        ],
      ),
      body: loading
          ? const Loader()
          : SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Dive into anything',
                    style: TextStyle(
                      fontSize: 28,
                      letterSpacing: 1.1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Image.asset(
                    Constants.loginEmote,
                    height: 400,
                    width: 400,
                  ),
                  const SizedBox(height: 30),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: LogInButton(),
                  )
                ],
              ),
            ),
    );
  }
}
