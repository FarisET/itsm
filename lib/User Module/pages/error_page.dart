import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.error_outline,
              size: 100,
              color: Colors.red,
            ),
            const Text(
              'Oops, something went wrong!',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            const Text(
              'The page you are looking for could not be found.',
              style: TextStyle(fontSize: 16),
            ),
            // SizedBox(
            //   height: 100,
            // ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home_page');  
              },
              child: const Text('Go to Home Page'),
            ),
          ],
        ),
      ),
    );
  }
}
