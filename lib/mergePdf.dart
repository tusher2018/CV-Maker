// ignore_for_file: use_build_context_synchronously

import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:camscanner/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';
import 'package:pdf_render/pdf_render.dart' as render;

class MergePdf extends StatefulWidget {
  @override
  _MergePdfState createState() => _MergePdfState();
}

class _MergePdfState extends State<MergePdf> {
  List<Uint8List> pdfPages = [];
  List<String> filesPath = [];

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
    );

    if (result != null) {
      if (result.paths.first == null) {
        return;
      }
      print("\n\n................");
      render.PdfDocument doc =
          await render.PdfDocument.openFile(result.paths.first!);
      int num = doc.pageCount;
      print(num);
      for (int i = 1; i <= num; i++) {
        print(i);
        render.PdfPage page = await doc.getPage(i);
        render.PdfPageImage? pageImage = await page.render();

        ui.Image dartImage = await pageImage.createImageIfNotAvailable();
        ByteData? byteData =
            await dartImage.toByteData(format: ui.ImageByteFormat.png);

        pdfPages.add(byteData!.buffer.asUint8List());
        print(i);
        filesPath.add(result.paths.first!);
        setState(() {});
      }
    }
  }

  Future<Uint8List> _mergePdfs() async {
    final pdf = pw.Document();
    for (Uint8List imageBytes in pdfPages) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) => pw.Center(
            child: pw.Image(pw.MemoryImage(imageBytes), fit: pw.BoxFit.contain),
          ),
        ),
      );
    }
    pdfPages = [];
    return await pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Merge PDFs'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  shrinkWrap: true,
                  itemCount: filesPath.length,
                  itemBuilder: (context, index) {
                    return commonText(filesPath[index],
                        overflow: TextOverflow.ellipsis,
                        alignment: TextAlign.left);
                  },
                ),
              ),
            ),
            Expanded(
                child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _pickFiles,
                    child: const Text('Select PDF Files'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (pdfPages.isEmpty) {
                        return;
                      }

                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => PdfPreview(
                          build: (format) => _mergePdfs(),
                        ),
                      );
                    },
                    child: const Text('Merge PDFs'),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
