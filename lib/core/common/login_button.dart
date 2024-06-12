import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/theme/pallete.dart';

class LogInButton extends ConsumerWidget {
  const LogInButton({
    super.key,
  });

  void logIn(BuildContext context, WidgetRef ref) async {
    await ref.read(authControllerProvider.notifier).googleSignIn(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialButton(
      onPressed: () => logIn(context, ref),
      height: 45,
      color: Pallete.greyColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Constants.google,
            scale: 13,
          ),
          const SizedBox(width: 10),
          const Text(
            'Continue with Google',
            style: TextStyle(fontSize: 18),
          )
        ],
      ),
    );
  }
}
