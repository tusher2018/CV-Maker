// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names, file_names, must_be_immutable

import 'dart:io';

import 'package:camscanner/CV%20templets/CV_Input_Field.dart';
import 'package:camscanner/common_widget.dart';
import 'package:camscanner/geminiApi.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class CvAIInputField extends StatefulWidget {
  CvAIInputField({super.key, required this.templets});
  int templets;

  @override
  State<CvAIInputField> createState() => _CvAIInputFieldState();
}

class _CvAIInputFieldState extends State<CvAIInputField> {
  List<File> imagefiles = [];
  List<File> audiofiles = [];
  TextEditingController AboutMeAIController = TextEditingController();
  String genaratedText = "";
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;

  @override
  void initState() {
    super.initState();
    print(_speechEnabled);
    initSpeech();
  }

  void initSpeech() async {
    if (!await Permission.microphone.isGranted) {
      await Permission.microphone.request();
    }
    if (await Permission.microphone.isGranted) {
      _speechEnabled = await _speechToText.initialize();
      print(_speechEnabled);
      setState(() {});
    }
  }

  void _startListening() async {
    await _speechToText.listen(
      onResult: _onSpeechResult,
    );
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      AboutMeAIController.text = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return CvMaker(
                    templets: widget.templets,
                  );
                },
              ));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: commonText("Do Manually", size: 14),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              commonText(
                  "Enter Informations about youself\n(You can upload images, audio files that contains informations about you and also text in the below fields):"),
              const SizedBox(
                height: 10,
              ),
              commonText(
                  // If listening is active show the recognized words
                  _speechToText.isListening
                      ? ""
                      : _speechEnabled
                          ? 'Tap the microphone to start listening...'
                          : 'Speech not available',
                  isBold: true),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    minLines: 5,
                    maxLines: 5,
                    controller: AboutMeAIController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "About Me",
                    )),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () async {
                  if (!await Permission.photos.isGranted) {
                    await Permission.photos.request();
                  }

                  await DocumentScanner(
                    options: DocumentScannerOptions(
                      documentFormat:
                          DocumentFormat.jpeg, // set output document format
                      mode: ScannerMode
                          .filter, // to control what features are enabled
                      pageLimit:
                          1, // setting a limit to the number of pages scanned
                      isGalleryImport: true, // importing from the photo gallery
                    ),
                  ).scanDocument().then((value) async {
                    for (var picture in value.images) {
                      imagefiles.add(File(picture));
                      setState(() {});
                    }
                  });
                },
                child: Container(
                    width: 250,
                    height: 80,
                    decoration: BoxDecoration(
                        color: Colors.yellow.shade300,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircleAvatar(child: Icon(Icons.add)),
                          commonText("Uploaded files ${imagefiles.length}")
                        ],
                      ),
                    )),
              ),
              const SizedBox(
                height: 10,
              ),
              ListView.separated(
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                shrinkWrap: true,
                itemCount: imagefiles.length,
                itemBuilder: (context, index) {
                  return commonText(imagefiles[index].path,
                      overflow: TextOverflow.ellipsis,
                      alignment: TextAlign.left);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () async {
                  if (imagefiles.isEmpty && AboutMeAIController.text.isEmpty) {
                    return;
                  }
                  print("clicked");
                  GenerateContentResponse response =
                      await geminiApiCallWithImage(
                          imageFile: imagefiles,
                          textData: AboutMeAIController.text,
                          oldResponse: genaratedText);

                  genaratedText = response.candidates.first.text
                      .toString()
                      .replaceAll('```json', '')
                      .replaceAll('```', '')
                      .trim();

                  print(genaratedText);
                  imagefiles = [];
                  setState(() {});
                },
                child: Container(
                    width: 150,
                    height: 40,
                    decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Center(
                        child: commonText("Submit",
                            color: Colors.white, size: 16, isBold: true))),
              ),
              const SizedBox(
                height: 10,
              ),
              Visibility(
                visible: genaratedText.isNotEmpty,
                child: Row(
                  children: [
                    commonText(
                        "AI Response:\n(if you setisfy with the data then continue)"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(genaratedText),
              ),
              Visibility(
                visible: genaratedText.isNotEmpty,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return CvMaker(
                          templets: widget.templets,
                          AIResponse: genaratedText,
                        );
                      },
                    ));
                  },
                  child: Container(
                      width: 150,
                      height: 40,
                      decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Center(
                          child: commonText("Continue",
                              color: Colors.white, size: 16, isBold: true))),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            _speechToText.isNotListening ? _startListening : _stopListening,
        tooltip: 'Listen',
        child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }
}
