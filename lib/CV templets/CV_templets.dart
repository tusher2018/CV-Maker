import 'package:camscanner/CV%20templets/CV_AI_input_field.dart';
import 'package:camscanner/common_widget.dart';
import 'package:flutter/material.dart';

class CvTemplatesPage extends StatelessWidget {
  // List of CV template images
  final List<String> cvTemplatesPath = [
    'assets/imges/t1.jpg',
    'assets/imges/t2.jpg',
    'assets/imges/t3.jpg',
    // Add more as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: commonText('CV Templates'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: cvTemplatesPath.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.6,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return CvAIInputField(templets: index + 1);
                  },
                ));
              },
              child: Card(
                elevation: 10,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.asset(
                          cvTemplatesPath[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Template ${index + 1}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
