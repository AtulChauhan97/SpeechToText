import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_in_text/Search_Controller/search_controller.dart';

class SearchViewBYSpeech extends StatefulWidget {
  const SearchViewBYSpeech({super.key});

  @override
  State<SearchViewBYSpeech> createState() => _SearchViewBYSpeechState();
}

class _SearchViewBYSpeechState extends State<SearchViewBYSpeech> {
  SpeechController controller = Get.put(SpeechController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.red.shade900,
        centerTitle: true,
        title: searchField(),
        leading: const Icon(
          Icons.menu,
          color: Colors.white,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                onPressed: () async{
                  buildVoiceDialog(size);
                  Future.delayed(const Duration(milliseconds: 100), () {
                    controller.startListening();
                  });
                },
                icon: const Icon(
                  Icons.mic,
                  size: 28,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  }

  /*Future<void> buildDialog() {
    return Get.dialog(
      Dialog(
        shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(
            () => SizedBox(
              height: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Google'),
                  AvatarGlow(
                    endRadius: 70,
                    glowColor: Colors.blue,
                    duration: const Duration(milliseconds: 2000),
                    repeatPauseDuration: const Duration(milliseconds: 100),
                    repeat: true,
                    child: Container(
                      alignment: Alignment.center,
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          color: Colors.blue.shade900,
                          borderRadius: BorderRadius.circular(40)),
                      child: const Icon(
                        Icons.mic,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    controller.speechText.value,
                    maxLines: 5,
                  ),
                  const Text('English(India)')
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }*/

  Widget searchField() {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0, bottom: 18),
      child: TextField(
        controller: controller.searchController,
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintText: "search",
          prefixIcon: const Icon(
            Icons.search,
            size: 25,
            color: Colors.white,
          ),
          fillColor: Colors.blue.shade400,
          filled: true,
          contentPadding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: Colors.blue.shade400)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: Colors.blue.shade400)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: Colors.blue.shade400)),
        ),
      ),
    );
  }

  Future<void> buildVoiceDialog(Size size) {
    return Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
        child: Obx(
              () => Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                  borderRadius: BorderRadius.circular(5)
                ),
            height: 350,
            width: size.width,
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 30),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: size.height * 0.015),
                const Text(
                  'Google',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: size.height * 0.05),
                CircleAvatar(
                  radius: 48,
                  backgroundColor:
                  controller.hasNotSpoken ? Colors.red : Colors.white,
                  child: AvatarGlow(
                    animate: controller.hasNotSpoken
                        ? false
                        : controller.speechEnabled,
                    glowColor: Colors.blue,
                    endRadius: 60,
                    duration: const Duration(milliseconds: 2000),
                    repeat: true,
                    showTwoGlows: false,
                    repeatPauseDuration: const Duration(milliseconds: 200),
                    child: CircleAvatar(
                      radius: 42,
                      backgroundColor: controller.speechEnabled
                          ? controller.hasNotSpoken
                          ? Colors.white
                          : Colors.blue
                          : Colors.white,
                      child: Icon(
                        controller.speechEnabled ? Icons.mic : Icons.mic_none,
                        size: 35,
                        color: controller.speechEnabled
                            ? controller.hasNotSpoken
                            ? Colors.blue
                            : Colors.white
                            : Colors.blue, // Change the icon color
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                SizedBox(
                  height: 80,
                  child: Column(
                    children: [
                      Text(
                          controller.isListening
                              ? controller.lastWord
                              : controller.speechText,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400)),
                      controller.hasNotSpoken
                          ? OutlinedButton(
                          onPressed: () {
                            controller.reset();
                            controller.startListening();
                          },
                          child: const Text(
                            'Try again',
                            style: TextStyle(color: Colors.blue),
                          ))
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
                // SizedBox(height: size.height * 0.0),
                const Text('English(India)', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ),
      ),
    ).then((value) {
      debugPrint('dialog closed');
      controller.stopListening();
      controller.reset();
    });
  }
}