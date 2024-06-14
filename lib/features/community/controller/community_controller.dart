import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/providers/storage_repository_provider.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/repositories/community_repository.dart';
import 'package:reddit_clone/models/community.dart';
import 'package:routemaster/routemaster.dart';

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  return CommunityController(
      communityRepository: ref.read(communityRepositiryProvider),
      ref: ref,
      storageProvider: ref.read(storageRepositoryProvider));
});

final getUserCommunitiesProvider = StreamProvider((ref) {
  return ref.watch(communityControllerProvider.notifier).getUserCommunities();
});
final getCommunitiesByNameProvider = StreamProvider.family((ref, String name) {
  return ref
      .watch(communityControllerProvider.notifier)
      .getCommunityByName(name);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;

  CommunityController(
      {required CommunityRepository communityRepository,
      required Ref ref,
      required StorageRepository storageProvider})
      : _communityRepository = communityRepository,
        _ref = ref,
        _storageRepository = storageProvider,
        super(false);

  void createCommunity(String communityName, BuildContext context) async {
    final uid = _ref.read(userProvider)?.uid ?? '';

    Community community = Community(
      id: communityName,
      name: communityName,
      banner: Constants.bannerDefault,
      avatar: Constants.avatarDefault,
      members: [uid],
      mods: [uid],
    );
    state = true;
    final res = await _communityRepository.createCommunity(community);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Community created successfully!');
      Routemaster.of(context).pop();
    });
  }

  Stream<List<Community>> getUserCommunities() {
    final uid = _ref.read(userProvider)?.uid ?? '';
    return _communityRepository.getUserCommunities(uid);
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }

  void editCommunity(
      {required Community community,
      required XFile? imagePath,
      required XFile? bannerPath,
      required BuildContext context}) async {
    state = true;
    if (imagePath != null) {
      final imageData = await _storageRepository.storeFile(
        path: 'communities/profile',
        id: community.name,
        file: imagePath,
      );
      imageData.fold((l) => showSnackBar(context, l.message),
          (avatar) => community = community.copyWith(avatar: avatar));
    }
    if (bannerPath != null) {
      final imageData = await _storageRepository.storeFile(
        path: 'communities/banner',
        id: community.name,
        file: bannerPath,
      );
      imageData.fold((l) => showSnackBar(context, l.message),
          (banner) => community = community.copyWith(banner: banner));
    }
    final data = await _communityRepository.editCommunity(community: community);
    data.fold(((l) => showSnackBar(context, l.message)), (r) {
      print('pooooooooooooop');
      Routemaster.of(context).pop();
    });
    state = false;
  }
}
