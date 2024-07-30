// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:simple_fx/simple_fx.dart';

class NIDProvider extends ChangeNotifier {
  Uint8List? nidFontImage;
  Uint8List? nidBackImage;

  NIDProvider(this.nidFontImage, this.nidBackImage);

  double brightness = -50.0, opacity = 100.0, seturation = 100.0, hue = 50.0;
  List<double> chanels = SFXChannels.all;
  List<double> filter = SFXFilters.none;

  void colorCollection({
    double brightness = 0.0,
    double opacity = 100.0,
    double seturation = 100.0,
    List<double> chanels = SFXChannels.all,
    double hue = 0.0,
    List<double> filter = SFXFilters.none,
  }) {
    this.brightness = brightness;
    this.opacity = opacity;
    this.seturation = seturation;
    this.chanels = chanels;
    this.hue = hue;
    this.filter = filter;
    notifyListeners();
  }
}

class CreateNID extends StatelessWidget {
  final bool isCamera;
  Uint8List? nidFontImage;
  Uint8List? nidBackImage;
  final screenshotController = ScreenshotController();

  CreateNID(
      {Key? key,
      required this.isCamera,
      required this.nidBackImage,
      required this.nidFontImage})
      : super(key: key);

  Future<File?> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
    );
    if (pickedImage != null) {
      return File(pickedImage.path);
    }
    return null;
  }

  Future<Uint8List?> _addImage(BuildContext context) async {
    File? pickedImage = await _pickImage(context);
    if (pickedImage != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedImage.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
        ],
      );
      return File(croppedFile!.path).readAsBytes();
    } else {
      return null;
    }
  }

  Future<Uint8List> createPdf(BuildContext context) async {
    final pdf = pw.Document();
    // final nidProvider = Provider.of<NIDProvider>(context, listen: false);

    final imageFile = await screenshotController.capture();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Center(
            child: (imageFile != null)
                ? pw.Image(pw.MemoryImage(imageFile),
                    width: PdfPageFormat.a4.width,
                    height: PdfPageFormat.a4.height)
                : pw.Text("Sorry! Please try again"),
          );
        },
      ),
    );
    return await pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NIDProvider(nidFontImage, nidBackImage),
      child: Consumer<NIDProvider>(
        builder: (context, nidProvider, _) => Stack(
          children: [
            screenShoot(nidProvider: nidProvider),
            Scaffold(
              backgroundColor: Colors.amber,
              appBar: AppBar(
                title: const Text('Create a NID'),
                centerTitle: true,
              ),
              body: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      if (nidProvider.nidFontImage != null)
                        Container(
                          width: 250,
                          height: 170,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F2F2),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: Colors.blue),
                          ),
                          child: SimpleFX(
                            brightness: nidProvider.brightness,
                            channels: nidProvider.chanels,
                            hueRotation: nidProvider.hue,
                            opacity: nidProvider.opacity,
                            saturation: nidProvider.seturation,
                            filter: nidProvider.filter,
                            imageSource: Image.memory(
                              nidProvider.nidFontImage!,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      if (nidFontImage != null && nidBackImage != null)
                        const SizedBox(height: 20),
                      if (nidProvider.nidBackImage != null)
                        Container(
                          width: 250,
                          height: 200,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F2F2),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: Colors.blue),
                          ),
                          child: SimpleFX(
                            brightness: nidProvider.brightness,
                            channels: nidProvider.chanels,
                            hueRotation: nidProvider.hue,
                            opacity: nidProvider.opacity,
                            saturation: nidProvider.seturation,
                            filter: nidProvider.filter,
                            imageSource: Image.memory(
                              nidProvider.nidBackImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      const SizedBox(height: 40),
                      (nidProvider.nidFontImage != null ||
                              nidProvider.nidBackImage != null)
                          ? SizedBox(
                              height: 100,
                              width: MediaQuery.sizeOf(context).width * 0.9,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  colorDesign(
                                      value: nidProvider,
                                      name: "Magic",
                                      function: () {
                                        nidProvider.colorCollection(
                                            hue: 50, brightness: -50);
                                      }),
                                  colorDesign(
                                      value: nidProvider,
                                      name: "Normal",
                                      function: () {
                                        nidProvider.colorCollection();
                                      }),
                                  colorDesign(
                                      value: nidProvider,
                                      name: "dark",
                                      function: () {
                                        nidProvider.colorCollection(
                                          brightness: -20,
                                        );
                                      }),
                                  colorDesign(
                                      value: nidProvider,
                                      name: "bright",
                                      function: () {
                                        nidProvider.colorCollection(
                                          brightness: 15,
                                        );
                                      }),
                                  colorDesign(
                                      value: nidProvider,
                                      name: "high bright",
                                      function: () {
                                        nidProvider.colorCollection(
                                          brightness: 25,
                                        );
                                      }),
                                  colorDesign(
                                      value: nidProvider,
                                      name: "deep",
                                      function: () {
                                        nidProvider.colorCollection(
                                            brightness: -50,
                                            hue: 30,
                                            seturation: 50,
                                            opacity: 100);
                                      }),
                                  colorDesign(
                                      value: nidProvider,
                                      name: "Light dark",
                                      function: () {
                                        nidProvider.colorCollection(
                                          brightness: -15,
                                        );
                                      }),
                                  colorDesign(
                                      value: nidProvider,
                                      name: "Seturation",
                                      function: () {
                                        nidProvider.colorCollection(
                                            hue: 150, brightness: -50);
                                      }),
                                  colorDesign(
                                      value: nidProvider,
                                      name: "Seturation2",
                                      function: () {
                                        nidProvider.colorCollection(
                                            hue: 270, brightness: -50);
                                      }),
                                ],
                              ),
                            )
                          : const SizedBox(),
                      ElevatedButton(
                        onPressed: () async {
                          if (nidProvider.nidFontImage == null &&
                              nidProvider.nidBackImage == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "To create a NID document, you must upload an image"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            return;
                          }

                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => PdfPreview(
                              build: (format) => createPdf(context),
                            ),
                          );
                        },
                        child: const Text("Preview"),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget colorDesign(
      {required function,
      required NIDProvider value,
      name,
      double brightness = 0.0,
      opacity = 100.0,
      seturation = 100.0,
      List<double> filter = SFXFilters.none,
      hue = 0.0,
      List<double> chanels = SFXChannels.all}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: function,
        child: SizedBox(
          height: 80,
          child: Center(
            child: Column(
              children: [
                Container(
                  color: Colors.red,
                  height: 60,
                  child: (value.nidFontImage != null)
                      ? SimpleFX(
                          brightness: brightness,
                          opacity: opacity,
                          saturation: seturation,
                          channels: chanels,
                          hueRotation: hue,
                          filter: filter,
                          imageSource: Image.memory(
                            value.nidFontImage!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : SimpleFX(
                          imageSource: Image.memory(
                            value.nidBackImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                SizedBox(height: 20, child: Text(name)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  dynamic progressBarCustom(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context1) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget screenShoot({required NIDProvider nidProvider}) {
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
              if (nidProvider.nidFontImage != null)
                Card(
                  color: Colors.black54,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(31, 73, 73, 73),
                          width: 2,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: SimpleFX(
                        brightness: nidProvider.brightness,
                        opacity: nidProvider.opacity,
                        saturation: nidProvider.seturation,
                        channels: nidProvider.chanels,
                        hueRotation: nidProvider.hue,
                        filter: nidProvider.filter,
                        imageSource: Image.memory(nidProvider.nidFontImage!,
                            width: width, height: height, fit: BoxFit.fill),
                      ),
                    ),
                  ),
                ),
              if (nidProvider.nidFontImage != null &&
                  nidProvider.nidBackImage != null)
                const SizedBox(height: 50),
              if (nidProvider.nidBackImage != null)
                Card(
                  color: Colors.black54,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(31, 73, 73, 73),
                          width: 2,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: SimpleFX(
                        brightness: nidProvider.brightness,
                        opacity: nidProvider.opacity,
                        saturation: nidProvider.seturation,
                        channels: nidProvider.chanels,
                        hueRotation: nidProvider.hue,
                        filter: nidProvider.filter,
                        imageSource: Image.memory(nidProvider.nidBackImage!,
                            width: width, height: height, fit: BoxFit.fill),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
