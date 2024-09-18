import 'package:flutter/material.dart';
import 'package:safify/User%20Module/pages/home_page.dart';
import 'package:safify/User%20Module/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TermsAndConditionsPage extends StatelessWidget {
  final double mainHeaderSize = 18;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text("Terms and Conditions",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: mainHeaderSize,
              color: Theme.of(context).secondaryHeaderColor,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection(
                      title: 'Liability',
                      body:
                          'We are not responsible for any injuries or financial losses incurred during the use of this application.',
                    ),
                    _buildSection(
                      title: 'User Responsibility',
                      body:
                          'Users are expected to refrain from submitting spam reports and should use the application to contribute to a safer environment.',
                    ),
                    _buildSection(
                      title: 'Privacy Policy',
                      body:
                          'Your data will remain confidential and may be analyzed to improve the application.',
                    ),
                    _buildSection(
                      title: 'Copyright and Ownership',
                      body:
                          'Users must use the application legally. Unauthorized commercial use or sale of the application will result in copyright infringement claims.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('acceptedTerms', true);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: const Text('Agree'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String body}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            body,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
