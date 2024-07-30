import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:pdf/pdf.dart';

class TextRecognization extends StatefulWidget {
  final File selectedMedia;
  TextRecognization({Key? key, required this.selectedMedia}) : super(key: key);

  @override
  State<TextRecognization> createState() => _TextRecognizationState();
}

class _TextRecognizationState extends State<TextRecognization> {
  String extractedText = '';
  bool isEditing = false;
  bool isLoading = false;
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _extractTextWithGemini();
  }

  Future<void> _extractTextWithGemini() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await geminiApiCallWithImage(widget.selectedMedia);
      setState(() {
        print(response.text);
        extractedText = response.text ?? '';
        textEditingController.text = extractedText;
      });
    } catch (e) {
      // Handle errors
      setState(() {
        extractedText = 'Error extracting text: $e';
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Text Recognition"),
      ),
      body: _buildUI(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Clipboard.setData(ClipboardData(text: extractedText));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Copied to Clipboard')),
          );
        },
        child: const Icon(Icons.copy),
      ),
    );
  }

  Widget _buildUI() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: SizedBox(
          width: PdfPageFormat.a4.width,
          height: PdfPageFormat.a4.height,
          child: FittedBox(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _imageView(),
                if (isLoading) CircularProgressIndicator(),
                if (!isLoading) _extractTextView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageView() {
    return Center(
      child: Image.file(
        widget.selectedMedia,
        width: 200,
      ),
    );
  }

  Widget _extractTextView() {
    return Column(
      children: [
        if (isEditing)
          TextField(
            controller: textEditingController,
            maxLines: null,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Extracted Text',
            ),
          )
        else
          RichText(
            text: _parseExtractedText(extractedText),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isEditing = !isEditing;
                });
              },
              child: Text(isEditing ? 'Save' : 'Edit'),
            ),
          ],
        ),
      ],
    );
  }

  TextSpan _parseExtractedText(String text) {
    final List<TextSpan> children = [];
    final lines = text.split('\n');

    for (var line in lines) {
      TextStyle style = TextStyle(fontSize: 16, color: Colors.black);

      // Check for bold text
      if (line.contains('###')) {
        style = style.copyWith(fontWeight: FontWeight.bold);
        line = line.replaceAll('###', '');
      }
      if (line.contains('##')) {
        style = style.copyWith(fontWeight: FontWeight.w600);
        line = line.replaceAll('##', '');
      }
      // Check for italics
      if (line.contains('####')) {
        style = style.copyWith(fontStyle: FontStyle.italic);
        line = line.replaceAll('####', '');
      }

      children.add(
        TextSpan(
          text: '$line\n',
          style: style,
          recognizer: TapGestureRecognizer()
            ..onTap = () {}, // For handling taps if needed
        ),
      );
    }

    return TextSpan(children: children);
  }

  Future<GenerateContentResponse> geminiApiCallWithImage(File imageFile) async {
    final model = GenerativeModel(
      model: "gemini-1.5-flash-latest",
      apiKey: "AIzaSyC5JLEGLd2I3u1kqeJ82G7FmREx6z590m0",
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
      ],
    );

    final image = await imageFile.readAsBytes();
    String formatting = """
Extract and format the text from the given image.
Ignore non-text elements and provide only the text content, ensuring it is readable and well-structured.
If there are any figures, indicate their position with a placeholder [Figure X].

Ensure the text is formatted to closely resemble the original document's layout as closely as possible.
To do this use only (###) for bold text, (##) for semi-bold, (####) for italics.
don't add any additional info.
      """;

    final response = await model.generateContent([
      Content.multi([
        TextPart('Extract text from the image'),
        DataPart("image/jpeg", image),
        TextPart(formatting)
      ])
    ]);

    return response;
  }
}
