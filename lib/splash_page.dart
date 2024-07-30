import 'package:camscanner/main.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var progress = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startLoading();
  }

  void startLoading() {
    Future.delayed(
      const Duration(milliseconds: 30),
      () => updateProgress(),
    );
    setState(() {});
  }

  void updateProgress() {
    if (progress < 1) {
      progress += 0.01;
      startLoading();
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return MyHomePage();
        },
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/imges/logo.jpg',
              width: 150,
              height: 150,
            ),
            Container(
              width: 253,
              height: 8,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: LinearProgressIndicator(
                backgroundColor: Colors.redAccent,
                borderRadius: BorderRadius.circular(10),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                value: progress,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
