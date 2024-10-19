// ignore_for_file: must_be_immutable, use_build_context_synchronously
import 'dart:io';
import 'dart:typed_data';

import 'package:camscanner/CV%20templets/CV_templets.dart';
import 'package:camscanner/CreateNID.dart';
import 'package:camscanner/common_widget.dart';
import 'package:camscanner/createPdf.dart';
import 'package:camscanner/mergePdf.dart';
import 'package:camscanner/removebd.dart';
import 'package:camscanner/splash_page.dart';
import 'package:camscanner/text_Recognaization.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';
import 'package:image/image.dart' as img;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:simple_fx/simple_fx.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final deviceInfo = await DeviceInfoPlugin().androidInfo;

  if (deviceInfo.version.sdkInt > 32) {
    await Permission.manageExternalStorage.request();
    await Permission.photos.request();
    await Permission.audio.request();
  } else {
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: SplashScreen());
  }
}

class MyHomePage extends StatelessWidget {
  List<Uint8List> uint8list = [];
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        screen(),
        Scaffold(
          appBar: AppBar(
            title: commonText('Scanner & CV Builder', size: 16),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              children: <Widget>[
                iconButtonWithText(
                  icon: "assets/imges/id.png",
                  text: 'Create NID Brighter',
                  function: () async {
                    Uint8List? font, back;
                    await DocumentScanner(
                      options: DocumentScannerOptions(
                        documentFormat:
                            DocumentFormat.jpeg, // set output document format
                        mode: ScannerMode
                            .filter, // to control what features are enabled
                        pageLimit:
                            2, // setting a limit to the number of pages scanned
                        isGalleryImport:
                            true, // importing from the photo gallery
                      ),
                    ).scanDocument().then((value) async {
                      for (var picture in value.images) {
                        if (font == null) {
                          font = await File(picture).readAsBytes();
                          final img.Image image = img.decodeImage(font!)!;
                          img.adjustColor(
                            image,
                            brightness: 1.2,
                          );
                          font = Uint8List.fromList(img.encodeJpg(image));
                        } else {
                          back = await File(picture).readAsBytes();
                          final img.Image image = img.decodeImage(back!)!;
                          img.adjustColor(
                            image,
                            brightness: 1.2,
                          );
                          back = Uint8List.fromList(img.encodeJpg(image));
                        }
                      }
                      if (font == null && back == null) {
                        return;
                      }

                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        if (font != null && back != null) {
                          return CreateNID(
                              isCamera: true,
                              nidBackImage: back,
                              nidFontImage: font);
                        } else {
                          return CreateNID(
                              isCamera: true,
                              nidBackImage: null,
                              nidFontImage: font);
                        }
                      }));
                    });
                    uint8list = [];
                  },
                ),
                iconButtonWithText(
                  icon: "assets/imges/id.png",
                  text: 'Create NID',
                  function: () async {
                    Uint8List? font, back;
                    await DocumentScanner(
                      options: DocumentScannerOptions(
                        documentFormat:
                            DocumentFormat.jpeg, // set output document format
                        mode: ScannerMode
                            .filter, // to control what features are enabled
                        pageLimit:
                            2, // setting a limit to the number of pages scanned
                        isGalleryImport:
                            true, // importing from the photo gallery
                      ),
                    ).scanDocument().then((value) async {
                      for (var picture in value.images) {
                        if (font == null) {
                          font = await File(picture).readAsBytes();
                        } else {
                          back = await File(picture).readAsBytes();
                        }
                      }

                      if (font == null && back == null) {
                        return;
                      }

                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        if (font != null && back != null) {
                          return CreateNID(
                              isCamera: true,
                              nidBackImage: back,
                              nidFontImage: font);
                        } else {
                          return CreateNID(
                              isCamera: true,
                              nidBackImage: null,
                              nidFontImage: font);
                        }
                      }));
                    });
                    uint8list = [];
                  },
                ),
                iconButtonWithText(
                  icon: "assets/imges/pdf.png",
                  text: 'Create PDF',
                  function: () async {
                    await DocumentScanner(
                      options: DocumentScannerOptions(
                        documentFormat:
                            DocumentFormat.jpeg, // set output document format
                        mode: ScannerMode
                            .filter, // to control what features are enabled
                        pageLimit:
                            10000, // setting a limit to the number of pages scanned
                        isGalleryImport:
                            true, // importing from the photo gallery
                      ),
                    ).scanDocument().then((value) async {
                      Uint8List priviewImage =
                          await File(value.images.elementAt(0)).readAsBytes();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => CreatePdf(
                                  list: value.images,
                                  previewImage: priviewImage))));
                    });
                  },
                ),
                iconButtonWithText(
                  icon: "assets/imges/removebg.png",
                  text: 'image bg Remove',
                  function: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const PassportPhotoScreen();
                    }));
                  },
                ),
                iconButtonWithText(
                  icon: "assets/imges/textRecognization.png",
                  text: 'Text Recognization',
                  function: () async {
                    File? page;
                    await DocumentScanner(
                      options: DocumentScannerOptions(
                        documentFormat:
                            DocumentFormat.jpeg, // set output document format
                        mode: ScannerMode
                            .filter, // to control what features are enabled
                        pageLimit:
                            1, // setting a limit to the number of pages scanned
                        isGalleryImport:
                            true, // importing from the photo gallery
                      ),
                    ).scanDocument().then((value) async {
                      for (var picture in value.images) {
                        page ??= File(picture);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return TextRecognization(
                            selectedMedia: page!,
                          );
                        }));
                      }
                    });
                  },
                ),
                iconButtonWithText(
                  icon: "assets/imges/pdf.png",
                  text: 'Merge PDF',
                  function: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return MergePdf();
                    }));
                  },
                ),
                iconButtonWithText(
                  icon: "assets/imges/cvMaker.png",
                  text: 'Make CV',
                  function: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return CvTemplatesPage();
                    }));
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  final screenshotController = ScreenshotController();

  Widget iconButtonWithText({
    required icon,
    function,
    required text,
  }) {
    return InkWell(
      onTap: function,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            icon,
            width: 40,
            height: 40,
          ),
          SizedBox(child: commonText(text, alignment: TextAlign.center)),
        ],
      ),
    );
  }

  Widget screen() {
    if (uint8list.isNotEmpty) {
      dynamic backimage;
      dynamic fontimage = Image.memory(uint8list[0]);
      if (uint8list.length > 1) {
        backimage = Image.memory(uint8list[1]);
      }
      double width = PdfPageFormat.a4.width / 2;
      double height = (PdfPageFormat.a4.width / 2) / (3 / 2);
      return Screenshot(
        controller: screenshotController,
        child: SizedBox(
          width: PdfPageFormat.a4.width,
          height: PdfPageFormat.a4.height,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (fontimage != null)
                  SimpleFX(
                    brightness: -50,
                    hueRotation: 50,
                    imageSource: Image.memory(uint8list[0],
                        width: width, height: height, fit: BoxFit.fill),
                  ),
                if (fontimage != null && backimage != null)
                  const SizedBox(height: 50),
                if (backimage != null)
                  SimpleFX(
                      brightness: -50,
                      hueRotation: 50,
                      imageSource: Image.memory(uint8list[1],
                          width: width, height: height, fit: BoxFit.fill)),
              ],
            ),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
