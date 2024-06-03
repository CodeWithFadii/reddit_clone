
import 'package:flutter/material.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/theme/pallete.dart';

class LogInButton extends StatelessWidget {
  const LogInButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {},
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
