import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/models/community.dart';
import 'package:reddit_clone/theme/pallete.dart';

class CommunityEditScreen extends ConsumerStatefulWidget {
  const CommunityEditScreen({super.key, required this.name});
  final String name;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CommunityEditScreenState();
}

class _CommunityEditScreenState extends ConsumerState<CommunityEditScreen> {
  XFile? bannerImage;
  XFile? profleImage;

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        bannerImage = res;
      });
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        profleImage = res;
      });
    }
  }

  void save(Community community, BuildContext context) {
    ref.watch(communityControllerProvider.notifier).editCommunity(
        community: community,
        imagePath: profleImage,
        bannerPath: bannerImage,
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return ref.watch(getCommunitiesByNameProvider(widget.name)).when(
          data: (community) => Scaffold(
            backgroundColor:
                Pallete.darkModeAppTheme.appBarTheme.backgroundColor,
            appBar: AppBar(
              title: const Text('Edit Community'),
              actions: [
                TextButton(
                  onPressed: () {
                    save(community, context);
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
            body: !isLoading
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: selectBannerImage,
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(10),
                                  dashPattern: const [10, 4],
                                  strokeCap: StrokeCap.round,
                                  color: Pallete.darkModeAppTheme.textTheme
                                      .titleMedium!.color!,
                                  child: Container(
                                      alignment: Alignment.center,
                                      height: 150,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: bannerImage != null
                                          ? Image.file(File(bannerImage!.path))
                                          : community.banner.isEmpty ||
                                                  community.banner ==
                                                      Constants.bannerDefault
                                              ? const Icon(
                                                  Icons.camera_alt_outlined,
                                                  size: 40,
                                                )
                                              : Image.network(
                                                  community.banner)),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                left: 20,
                                child: GestureDetector(
                                  onTap: selectProfileImage,
                                  child: profleImage != null
                                      ? CircleAvatar(
                                          backgroundImage: FileImage(
                                              File(profleImage!.path)),
                                          radius: 32,
                                        )
                                      : CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(community.avatar),
                                          radius: 32,
                                        ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                : const Loader(),
          ),
          error: (error, stackTrace) => ErrorText(errorText: error.toString()),
          loading: () => const Loader(),
        );
  }
}
