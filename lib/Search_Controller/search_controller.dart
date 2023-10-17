import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechController extends GetxController {

  SpeechToText speechToText = SpeechToText();
  RxString _lastWords = ''.obs;
  RxBool _hasNotSpoken = false.obs;
  RxBool _isListening = false.obs;

  bool get hasNotSpoken => _hasNotSpoken.value;

  bool get isListening => _isListening.value;

  // RxBool isListeningEnabled = false.obs;

  String get lastWord => _lastWords.value;

  RxString _speechText = ''.obs;

  String get speechText => _speechText.value;

  RxBool _speechEnabled = false.obs;

  bool get speechEnabled => _speechEnabled.value;

  RxBool isVisible = false.obs;

  final searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();

  void reset() {
    _hasNotSpoken.value = false;
    _isListening.value = false;
    _lastWords.value = '';
    _speechText.value = 'Say Something';
  }


  @override
  void onInit() {
    super.onInit();
    initSpeech();
  }

  void initSpeech() async {
    _speechEnabled.value = await speechToText.initialize(onStatus: (val) {
      debugPrint('valueStatus:${val}');
      if (val == 'done') {
        if (isListening) {
          if (speechToText.isNotListening &&
              (Get.isDialogOpen != null && Get.isDialogOpen!)) {
            Future.delayed(const Duration(milliseconds: 250), () {
              searchController.text = lastWord;
              Get.back();
              searchFocus.requestFocus();
              _isListening.value = false;
              _lastWords.value = '';
            });
          }
        } else {
          if (Get.isDialogOpen != null && Get.isDialogOpen!) {
            _speechText.value = "Didn't catch that,Try speaking again.";
            _hasNotSpoken.value = true;
            _isListening.value = false;
          }
        }
      }
    });
    if (speechEnabled) {
      _speechText.value = 'Say Something';
    } else {
      _speechText.value = "Speech Not Available";
    }
  }

  void startListening() async {
    debugPrint('start listening');
    await speechToText.listen(onResult: (SpeechRecognitionResult result) {
      _lastWords.value = result.recognizedWords;
      // _isListening.value = speechToText.isListening;
      _isListening.value = true;
      debugPrint('lastWord:$lastWord');
      debugPrint('isListening:$isListening');
    });
  }

  void stopListening() async {
    speechToText.stop();
  }




  // TextEditingController textController = TextEditingController();
  //
  // SpeechToText speechToText = SpeechToText();
  // RxString speechText = "say something".obs;
  //
  // void initSpeech() async {
  //   await speechToText.initialize( );
  //   startListening();
  // }
  //
  // void startListening() async {
  //   debugPrint("start listening..... ${speechToText.isListening}");
  //   await speechToText.listen(onResult: _onSpeechResult);
  // }
  //
  // void stopListening() async {
  //   debugPrint('stop listening....${speechToText.isNotListening}');
  //   await speechToText.stop();
  // }
  //
  // void _onSpeechResult(result) {
  //   var t = result.recognizedWords;
  //   debugPrint('status not:: ${speechToText.isNotListening}');
  //   debugPrint('status yes:: ${speechToText.isListening}');
  //   debugPrint('text $t');
  //   speechText.value = t;
  //   textController.text = t;
  //
  //   debugPrint('speech result: $t');
  // }
}
