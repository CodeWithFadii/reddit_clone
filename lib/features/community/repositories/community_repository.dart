import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constants/firebase_constants.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/providers/firebase_provider.dart';
import 'package:reddit_clone/core/type_def.dart';
import 'package:reddit_clone/models/community.dart';

final communityRepositiryProvider = Provider((ref) {
  return CommunityRepository(
      firebaseFirestore: ref.read(firebaseFirestoreProvider));
});

class CommunityRepository {
  final FirebaseFirestore _firebaseFirestore;

  CommunityRepository({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  CollectionReference get _communities =>
      _firebaseFirestore.collection(FirebaseConstants.communitiesCollection);

  FutureVoid createCommunity(Community community) async {
    try {
      final data = await _communities.doc(community.name).get();
      if (data.exists) {
        throw 'Community with same name already exists, try with a different name :)';
      }
      return right(_communities.doc(community.name).set(community.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> getUserCommunities(String uid) {
    return _communities.where('members', arrayContains: uid).snapshots().map(
      (data) {
        List<Community> communityList = [];
        for (QueryDocumentSnapshot i in data.docs) {
          communityList
              .add(Community.fromMap(i.data() as Map<String, dynamic>));
        }
        return communityList;
      },
    );
  }
}
