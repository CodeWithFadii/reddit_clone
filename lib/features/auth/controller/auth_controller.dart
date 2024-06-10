import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/repository/auth_repository.dart';
import 'package:reddit_clone/models/user_model.dart';

//stores data of current user
final userProvider = StateProvider<UserModel?>((ref) => null);

//for accesing data from authController class
final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
      authRepository: ref.read(authRepositoryProvider), ref: ref),
);

//checking user logged in or not
final authStateChangesProvider = StreamProvider((ref) {
  final authProvider = ref.watch(authControllerProvider.notifier);
  return authProvider.authStateChanges;
});
//getting user data as stream
final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authProvider = ref.watch(authControllerProvider.notifier);
  return authProvider.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);

  Stream<User?> get authStateChanges => _authRepository.authStateChanges;

  Future<void> googleSignIn(BuildContext context) async {
    state = true;
    var user = await _authRepository.googleSignIn();
    state = false;
    user.fold(
      (l) => showSnackBar(context, l.message),
      (user) {
        _ref.watch(userProvider.notifier).update((state) => user);
      },
    );
  }



  Stream<UserModel> getUserData(String? uid) {
    return _authRepository.getUserData(uid);
  }
}
