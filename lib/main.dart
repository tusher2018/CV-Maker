// ignore_for_file: must_be_immutable

import 'dart:typed_data';

import 'package:camscanner/CV%20templets/CV_templets.dart';

import 'package:camscanner/common_widget.dart';

import 'package:camscanner/splash_page.dart';

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

  MyHomePage({super.key});
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
