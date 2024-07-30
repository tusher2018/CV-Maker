import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:image/image.dart' as img;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;
import 'package:printing/printing.dart';

class PassportPhotoScreen extends StatefulWidget {
  const PassportPhotoScreen({Key? key}) : super(key: key);

  @override
  _PassportPhotoScreenState createState() => _PassportPhotoScreenState();
}

class _PassportPhotoScreenState extends State<PassportPhotoScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final List<Color> backgroundColors = [Colors.blue, Colors.lightBlue];
  Color selectedColor = Colors.blue;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<Uint8List?> _removeBackground(File imageFile) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.remove.bg/v1.0/removebg'),
    );
    request.files
        .add(await http.MultipartFile.fromPath('image_file', imageFile.path));
    request.headers.addAll({'X-Api-Key': 'V8qioi4b8hofjjz4RNYm3J6Z'});

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBytes = await response.stream.toBytes();

      return responseBytes;
    } else {
      print('Remove.bg API error: ${response.statusCode}');
      return null;
    }
  }

  Future<Uint8List> _createPassportImage(
      Uint8List imageFile, Color backgroundColor) async {
    // final imageBytes = await imageFile.readAsBytes();
    // img.Image originalImage = img.decodeImage(
    //   imageFile,
    // )!;
    // img.Image resizedImage = img.copyResize(
    //   originalImage,
    //   width: 413,
    //   height: 531,
    // );

    return imageFile;

    // final tempDir = await getTemporaryDirectory();
    // final passportFile = File('${tempDir.path}/passport_image.png');
    // await passportFile.writeAsBytes(img.encodePng(finalImage));
    // return passportFile;
    // return File("");
  }

  Future<void> _generatePdf(Uint8List passportFile) async {
    final pdf = pw.Document();
    final image = pw.MemoryImage(passportFile);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
              child: pw.Container(
            color: PdfColors.blue,
            child: pw.Image(
              image,
              width: 413,
              height: 531,
            ),
          ));
        },
      ),
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => PdfPreview(
        build: (format) => pdf.save(),
      ),
    );

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('PDF Saved')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passport Photo Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_image != null)
              Image.file(
                _image!,
                width: 200,
                height: 200,
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: backgroundColors.map((color) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    color: color,
                    child: selectedColor == color
                        ? Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 16),
            if (_image != null)
              ElevatedButton(
                onPressed: () async {
                  final bgRemovedFile = await _removeBackground(_image!);
                  if (bgRemovedFile != null) {
                    final passportFile = await _createPassportImage(
                        bgRemovedFile, selectedColor);
                    await _generatePdf(passportFile);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Background removal failed')));
                  }
                },
                child: const Text('Generate Passport Photo PDF'),
              ),
          ],
        ),
      ),
    );
  }
}
