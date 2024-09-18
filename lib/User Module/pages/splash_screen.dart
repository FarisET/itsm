import 'dart:async';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  final Widget initalWidget;
  const SplashScreen({super.key, required this.initalWidget});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => widget.initalWidget)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Image.asset('assets/images/safify_logo.png'),
            ),
            Lottie.asset(
              'assets/images/loading_lottie.json',
              height: MediaQuery.sizeOf(context).height * 0.25,
            ),
          ],
        ),
      ),
    );
  }
}
