// ignore_for_file: no_wildcard_variable_uses

import 'package:flutter/material.dart';
import 'package:reddit_clone/features/auth/screens/login_screen.dart';
import 'package:reddit_clone/features/community/screens/community_edit_screen.dart';
import 'package:reddit_clone/features/community/screens/community_screen.dart';
import 'package:reddit_clone/features/community/screens/create_community_screen.dart';
import 'package:reddit_clone/features/community/screens/mod_tools_screen.dart';
import 'package:reddit_clone/features/home/screens/home_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  RouteNames.initialScreen: (_) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(
  routes: {
    RouteNames.initialScreen: (_) => const MaterialPage(child: HomeScreen()),
    RouteNames.createCommunityScreen: (_) =>
        const MaterialPage(child: CreateCommunityScreen()),
    '${RouteNames.communityScreen}:name': (_) {
      return MaterialPage(
        child: CommunityScreen(
          name: _.pathParameters['name']!,
        ),
      );
    },
    '${RouteNames.modToolsScreen}:name': (_) {
      return MaterialPage(
        child: ModToolsScreen(
          name: _.pathParameters['name']!,
        ),
      );
    },
    '${RouteNames.communityEditScreen}:name': (_) {
      return MaterialPage(
        child: CommunityEditScreen(
          name: _.pathParameters['name']!,
        ),
      );
    }
  },
);

class RouteNames {
  static const String initialScreen = '/';
  static const String createCommunityScreen = '/create-community';
  static const String communityScreen = '/r/';
  static const String modToolsScreen = '/mod-tools/';
  static const String communityEditScreen = '/edit-community/';
}
