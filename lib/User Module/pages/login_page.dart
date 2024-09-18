import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safify/User%20Module/pages/home_page.dart';
import 'package:safify/db/database_helper.dart';
import 'package:safify/utils/alerts_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Action Team Module/pages/action_team_home_page.dart';
import '../../Admin Module/admin_pages/admin_home_page.dart';
import '../../services/UserServices.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController cuserid = TextEditingController();
  final TextEditingController cpassword = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UserServices userServices = UserServices();

  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    checkUserSession();
  }

  void checkUserSession() async {
    final jwt = await userServices.getJwt();
    final role = await userServices.getRole();

    if (jwt != null && role != null) {
      // Use the JWT and role to authenticate and route the user
      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminHomePage()),
        );
      } else if (role == 'user') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage2()),
        );
      } else if (role == 'action_team') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ActionTeamHomePage()),
        );
      } else {
        Fluttertoast.showToast(msg: 'Unknown role');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: ListView(children: [
          // SizedBox(
          //   height: 20,
          // ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/safify_logo.png',
                  width: 300,
                  height: 300,
                ),
                const SizedBox(
                  height: 0,
                ),
                const Text(
                  'Login',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                makeInput(
                  label: 'Enter your registered id',
                  controller_val: cuserid,
                ),
                const SizedBox(
                  height: 12,
                ),
                makeInput(
                    label: 'Enter password',
                    controller_val: cpassword,
                    obscureText: true),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: OverflowBar(
                    alignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            closeApp();
                          },
                          child: const Text('CANCEL')),
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.05,
                        // width: MediaQuery.sizeOf(context).height * 0.1,
                        child: ElevatedButton(
                            onPressed: isSubmitting
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      handleLoginButton(context);
                                    }
                                  },
                            child: isSubmitting
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Loading'),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.025,
                                        width:
                                            MediaQuery.sizeOf(context).height *
                                                0.025,
                                        child: const CircularProgressIndicator(
                                          color: Colors.grey,
                                          // strokeWidth: 3,
                                        ),
                                      ),
                                    ],
                                  )
                                : const Text('Login')),
                      )
                    ],
                  ),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "BETA - Version 1.0",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          )
        ]),
      )),
    );
  }

  Widget makeInput({
    String? label,
    TextEditingController? controller_val,
    bool obscureText = false,
    //String? Function(String?)? validator,
  }) {
    return TextFormField(
        controller: controller_val,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          return null;
        } // Add the validation function
        );
  }

  void handleLoginButton(BuildContext context) async {
    setState(() {
      isSubmitting = true;
    });

    UserServices userServices = UserServices();
    final result = await userServices.login(
      cuserid.text.toString().trim(),
      cpassword.text.toString(),
    );

    if (result['success']) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("user_id", cuserid.text);

      final dbHelper = DatabaseHelper();
      final userId = await dbHelper.getLastUserId();
      if (userId['last_login_user_id'] != null) {
        if (userId['last_login_user_id'] != cuserid.text) {
          await dbHelper.clearDBdata();
          print("removed db data");
        }
      }

      await dbHelper.setLastUserId(cuserid.text);

      final role = await userServices.getRole();
      if (role != null) {
        if (role.trim() == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminHomePage()),
          );
        } else if (role.trim() == 'user') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage2()),
          );
        } else if (role.trim() == 'action_team') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ActionTeamHomePage()),
          );
        } else {
          Alerts.customAlertWidget(context, 'Unknown role', () {});
        }
      }
    } else {
      Alerts.customAlertWidget(context, result['message'], () {});
    }

    setState(() {
      isSubmitting = false;
    });
  }

  void closeApp() {
    SystemNavigator.pop(); // This will close the app
  }
}
