import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timetable_app/components/custom_TF_Field.dart';
import 'package:timetable_app/models/user_model.dart';
import 'package:timetable_app/screens/login_screen.dart';
import 'package:timetable_app/services/web_services.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailTEC = TextEditingController();
  TextEditingController nameTEC = TextEditingController();
  TextEditingController passwdTEC = TextEditingController();
  String? Function(String?)? emailValidator = (value) {
    if (!value!.contains('.com') || !value.contains('@'))
      return 'Enter a valid email';
  };
  String? Function(String?)? nameValidator = (value) {
    if (value!.length < 4) return 'Name should be atleat 4 characters long';
  };
  String? Function(String?)? passwdValidator = (value) {
    if (value!.length < 8) return 'Password must have atleast 8 characters';
  };
  void _registerBtnClicked() async {
    final newUser = new User(
        name: nameTEC.text,
        email: emailTEC.text,
        password: passwdTEC.text,
        role: 'User');
    final response = await Webservices().registerUser(userToJson(newUser));
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registered'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(
          passedEmail: emailTEC.text,
          passedPasswd: passwdTEC.text,
        ),
      ),
    );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.body),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      /* floatingActionButton: FloatingActionButton(
        onPressed: () => print(50/size.height),), */
      body: SafeArea(
        child: GestureDetector(
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
                      'Register',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.ropaSans(
                          fontSize: size.height * 0.052, //40 h
                          fontWeight: FontWeight.bold,
                          color: Color(0xff3EA6F2)),
                    ),
                    SizedBox(
                      height: size.height * 0.026, // 20 h
                    ),
                    CustomTFField(
                      validator: nameValidator!,
                      emailTEC: nameTEC,
                      label: 'Name',
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
                        Text('Already have an account ? ',
                            style: GoogleFonts.ropaSans()),
                        InkWell(
                          child: Text(
                            'Login',
                            style: GoogleFonts.ropaSans(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LoginScreen(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.019, //15 h
                    ),
                    InkWell(
                      onTap: () {
                        if (formKey.currentState!.validate())
                          _registerBtnClicked();
                      },
                      enableFeedback: true,
                      child: Container(
                        width: double.infinity,
                        height: size.height * 0.065, // 50 h
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
                            'REGISTER',
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
      ),
    );
  }
}
