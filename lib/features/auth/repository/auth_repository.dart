import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/constants/firebase_constants.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/providers/firebase_provider.dart';
import 'package:reddit_clone/core/type_def.dart';
import 'package:reddit_clone/models/user_model.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firebaseAuth: ref.read(firebaseAuthProvider),
    firestore: ref.read(firebaseFirestoreProvider),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  AuthRepository({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    required GoogleSignIn googleSignIn,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  FutureEither<UserModel> googleSignIn() async {
    try {
      final result = await _googleSignIn.signIn();

      final GoogleSignInAccount account = result!;
      final GoogleSignInAuthentication auth = await account.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );

      final userData = await _firebaseAuth.signInWithCredential(credential);

      UserModel userModel;

      userData.additionalUserInfo!.isNewUser
          ? userModel = await saveUserData(userData)
          : userModel = await getUserData(userData.user?.uid).first;

      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<UserModel> saveUserData(UserCredential userData) async {
    final userModel = UserModel(
      name: userData.user?.displayName ?? '',
      profilePic: userData.user?.photoURL ?? Constants.avatarDefault,
      banner: Constants.avatarDefault,
      uid: userData.user?.uid ?? '',
      isAuthenticated: true,
      karma: 0,
      awards: [],
    );
    await _users.doc(userModel.uid).set(userModel.toMap());
    return userModel;
  }

  Stream<UserModel> getUserData(String? uid) {
    return _users.doc(uid).snapshots().map(
          (event) => UserModel.fromMap(
            event.data() as Map<String, dynamic>,
          ),
        );
  }

  void logout() {
    _googleSignIn.signOut();
    _firebaseAuth.signOut();
  }
}
