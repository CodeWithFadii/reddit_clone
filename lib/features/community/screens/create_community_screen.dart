import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final createCommunityC = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    createCommunityC.dispose();
  }

  void createCommunity() {
    ref
        .read(communityControllerProvider.notifier)
        .createCommunity(createCommunityC.text.replaceAll(" ", ""), context);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(communityControllerProvider)
        ? const Loader()
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Create a community'),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Community name'),
                    const SizedBox(height: 10),
                    TextField(
                      onTapOutside: (event) =>
                          FocusScope.of(context).requestFocus(FocusNode()),
                      controller: createCommunityC,
                      decoration: const InputDecoration(
                        filled: true,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        hintText: 'r/community_name',
                      ),
                      maxLength: 21,
                    ),
                    const SizedBox(height: 30),
                    MaterialButton(
                      minWidth: double.infinity,
                      height: 48,
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: () {
                        createCommunity();
                      },
                      child: const Text(
                        'Create community',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
