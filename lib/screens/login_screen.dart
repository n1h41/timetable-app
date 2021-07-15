import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timetable_app/components/custom_TF_Field.dart';
import 'package:timetable_app/models/user_model.dart';
import 'package:timetable_app/screens/admin_screen.dart';
import 'package:timetable_app/screens/home_screen.dart';
import 'package:timetable_app/screens/registration_screen.dart';
import 'package:timetable_app/services/web_services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, this.passedEmail, this.passedPasswd})
      : super(key: key);
  final passedEmail;
  final passedPasswd;
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  User? user;
  @override
  void initState() {
    super.initState();
    checkForPassedArgs();
  }

  checkForPassedArgs() {
    if (widget.passedEmail != null || widget.passedPasswd != null) {
      setState(() {
        emailTEC.text = widget.passedEmail;
        passwdTEC.text = widget.passedPasswd;
      });
    }
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailTEC = TextEditingController();
  TextEditingController passwdTEC = TextEditingController();
  String? Function(String?)? emailValidator = (value) {
    if (!value!.contains('.com') || !value.contains('@'))
      return 'Enter a valid email';
  };
  String? Function(String?)? passwdValidator = (value) {
    if (value!.length < 8) return 'Password must have atleast 8 characters';
  };
  void _loginBtnClicked() async {
    final userLoggingIn =
        new User(email: emailTEC.text, password: passwdTEC.text);
    /* print(userToJson(userLoggingIn)); */
    final response = await Webservices().userLogin(userToJson(userLoggingIn));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('auth-token', response.headers['auth-token']);
      prefs.setString('role', jsonData['role']);
      print(jsonData['role']);
      print(response.headers['auth-token']);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logged in'),
          backgroundColor: Colors.green,
        ),
      );
      user = User.fromJson(jsonData);
      print(user!.role);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(),
        ),
      );
    } else
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.body),
          backgroundColor: Colors.red,
        ),
      );
    return print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      /* floatingActionButton: FloatingActionButton(
        onPressed: () => print(50/size.height),
      ), */
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          color: Colors.white,
          child: Form(
            key: formKey,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.050), //20 w
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Login',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ropaSans(
                        fontSize: size.height * 0.052, //40 h
                        fontWeight: FontWeight.bold,
                        color: Color(0xff3EA6F2)),
                  ),
                  SizedBox(
                    height: size.height * 0.026, // 20 h
                  ),
                  CustomTFField(
                    validator: emailValidator!,
                    emailTEC: emailTEC,
                    label: 'Email',
                  ),
                  SizedBox(
                    height: size.height * 0.026, // 20 h
                  ),
                  CustomTFField(
                    validator: passwdValidator!,
                    emailTEC: passwdTEC,
                    label: 'Password',
                  ),
                  SizedBox(
                    height: size.height * 0.026, // 20 h
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Dont have an account ? ',
                          style: GoogleFonts.ropaSans()),
                      InkWell(
                        child: Text(
                          'Register',
                          style: GoogleFonts.ropaSans(color: Colors.blue),
                        ),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => RegistrationScreen())),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.019, //15 h
                  ),
                  InkWell(
                    onTap: () {
                      if (formKey.currentState!.validate()) _loginBtnClicked();
                    },
                    enableFeedback: true,
                    child: Container(
                      width: double.infinity,
                      height: size.height * 0.065,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xFF73AEF5),
                            Color(0xFF61A4F1),
                            Color(0xFF478DE0),
                            Color(0xFF398AE5),
                          ],
                          stops: [0.1, 0.4, 0.7, 0.9],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'LOGIN',
                          style: GoogleFonts.ropaSans(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: size.height * 0.026),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
