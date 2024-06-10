import 'package:flutter/material.dart';
import 'package:reddit_clone/features/auth/screens/login_screen.dart';
import 'package:reddit_clone/features/community/screens/create_community_scree.dart';
import 'package:reddit_clone/features/home/screens/home_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  RouteNames.initialScreen: (_) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  RouteNames.initialScreen: (_) => const MaterialPage(child: HomeScreen()),
  RouteNames.createCommunityScreen: (_) =>
      const MaterialPage(child: CreateCommunityScree()),
});

class RouteNames {
  static const String initialScreen = '/';
  static const String createCommunityScreen = '/create-community';
}
