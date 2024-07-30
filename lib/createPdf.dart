// ignore_for_file: must_be_immutable

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:image/image.dart' as img;

class CreatePdf extends StatefulWidget {
  List<String> list;
  Uint8List previewImage;
  CreatePdf({Key? key, required this.list, required this.previewImage})
      : super(key: key);

  @override
  State<CreatePdf> createState() => _CreatePdfState();
}

class _CreatePdfState extends State<CreatePdf> {
  late Uint8List previewImage;
  double explosion = 0.5;

  Uint8List applyColorCorrection(Uint8List imageFile, double explosure) {
    final img.Image image = img.decodeImage(imageFile)!;
    img.adjustColor(
      image,
      exposure: explosure,
    );
    return Uint8List.fromList(img.encodeJpg(image));
  }

  @override
  void initState() {
    super.initState();

    previewImage = applyColorCorrection(widget.previewImage, explosion);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                    width: 250,
                    child: Text(
                      "on click Preview it will take some time",
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                      width: 250,
                      height: 300,
                      child: Image.memory(
                        previewImage,
                        fit: BoxFit.fill,
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Slider(
                    value: explosion,
                    min: 0,
                    max: 1,
                    onChanged: (newValue) {
                      setState(() {
                        explosion = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return PdfPreview(
                                    build: (format) {
                                      return createPdf(context,
                                          list: widget.list,
                                          exposure: explosion);
                                    },
                                  );
                                });
                          },
                          child: const Text("Apply")),
                      ElevatedButton(
                          onPressed: () {
                            previewImage = applyColorCorrection(
                                widget.previewImage, explosion);
                            setState(() {});
                          },
                          child: const Text("Preview")),
                    ],
                  )
                ]),
          ),
        ));
  }

  Future<Uint8List> createPdf(BuildContext context,
      {required List<String> list, required double exposure}) async {
    final pdf = pw.Document();
    for (var x in list) {
      Uint8List font = await File(x).readAsBytes();
      final img.Image image = img.decodeImage(font)!;
      img.adjustColor(
        image,
        exposure: exposure,
      );
      font = Uint8List.fromList(img.encodeJpg(image));
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return pw.Center(
              child: pw.Image(pw.MemoryImage(Uint8List.fromList(font)),
                  width: PdfPageFormat.a4.width * 0.9,
                  height: PdfPageFormat.a4.height * 0.9),
            );
          },
        ),
      );
    }

    return await pdf.save();
  }
}
