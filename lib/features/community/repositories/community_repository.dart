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

  Stream<Community> getCommunityByName(String name) {
    return _communities.doc(name).snapshots().map(
          (event) => Community.fromMap(event.data() as Map<String, dynamic>),
        );
  }

  FutureVoid editCommunity({required Community community}) async {
    try {
      return right(_communities.doc(community.name).update(community.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communities
        .where(
          'name',
          isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
          isLessThan: query.isEmpty
              ? null
              : query.substring(0, query.length - 1) +
                  String.fromCharCode(
                    query.codeUnitAt(query.length - 1) + 1,
                  ),
        )
        .snapshots()
        .map(
      (event) {
        List<Community> communities = [];
        print(event.docs.length);
        for (var element in event.docs) {
          communities
              .add(Community.fromMap(element.data() as Map<String, dynamic>));
        }
        return communities;
      },
    );
  }
}
