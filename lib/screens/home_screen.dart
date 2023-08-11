import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController userInputTextEditingController =
      TextEditingController();
  final SpeechToText speechToText = SpeechToText();
  String recordedAudio = '';
  bool isLoading = false;
  bool isListening = false;
  String modeOpenAi = 'chat';

  void InitializeSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  void StartListeningNow() async {
    FocusScope.of(context).unfocus();
    await speechToText.listen(onResult: onSpeechToTextResult);
    setState(() {});
  }

  void StopListeningNow() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechToTextResult(SpeechRecognitionResult recognitionResult) {
    recordedAudio = recognitionResult.recognizedWords;

    print('speech result : ${recordedAudio}');
     sendRequestToOpenAI(recordedAudio);
  }

  Future<void> sendRequestToOpenAI(String userInput) async {
   speechToText.isListening? null: StopListeningNow();
   setState(() {
     isLoading = true;
   });
  }

  @override
  void initState() {
    super.initState();
    InitializeSpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: keyboardIsOpened
          ? null
          : FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.mic),
              backgroundColor: Color(0xff3ed8e6),
            ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      appBar: AppBar(
        title: const Text('Open AI'),
        actions: [
          InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Icon(Icons.volume_up_outlined),
              ))
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: LinearGradient(
              // begin: Alignment.topCenter,
              // end: Alignment.bottomCenter,
              colors: <Color>[Color(0xff3ed8e6), Colors.blue])),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            children: [
              InkWell(
                  onTap: () {
                    speechToText.isListening
                        ? StopListeningNow
                        : StartListeningNow();
                  },
                  child: speechToText.isListening
                      ? Center(
                          child: Padding(
                          padding: const EdgeInsets.all(100.0),
                          child: LoadingAnimationWidget.stretchedDots(
                              size: 100,
                              color: speechToText.isListening
                                  ? Colors.white
                                  : isListening
                                      ? Colors.white
                                      : Colors.red),
                        ))
                      : Lottie.asset('assets/animation/141714-ai-bot.json'))
              // Image.asset('assets/images/open_AI.PNG'),
              // const SizedBox(
              //   height: 20,
              // ),
              ,
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: userInputTextEditingController,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide:
                                BorderSide(width: 1, color: Colors.white),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1)),
                          labelText: 'How can I help You?',
                          labelStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white)),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                      onTap: () {
                        StopListeningNow();
                        print('input sent');
                      },
                      child: AnimatedContainer(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Color(0xff3ed8e6), shape: BoxShape.circle),
                        duration: Duration(milliseconds: 1000),
                        curve: Curves.bounceInOut,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
