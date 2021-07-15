import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timetable_app/screens/home_screen.dart';
import 'package:timetable_app/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? authToken = prefs.getString('auth-token');
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Timetable',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: authToken == null ? LoginScreen() : HomeScreen(),
    ));
}