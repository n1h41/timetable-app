import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timetable_app/models/timetable_data_model.dart';
import 'package:timetable_app/screens/add_events_screen.dart';
import 'package:timetable_app/screens/admin_screen.dart';
import 'package:timetable_app/screens/login_screen.dart';
import 'package:timetable_app/services/web_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? role;
  double _progressValue = 0;
  DateTime currentT = DateTime.now().toLocal();
  bool _isBodyLoading = false;
  String _selectedDay = 'Mon';
  List<String> _days = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ];
  List _timetableDataList = [];
  @override
  void initState() {
    super.initState();
    _getTimetableDataList();
    getRole();
    /* startTimer(); */
  }

  getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getString('role');
    });
  }

  _getTimetableDataList() async {
    setState(() {
      _isBodyLoading = !_isBodyLoading;
    });
    final response = await Webservices().getEntryList();
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      setState(() {
        _timetableDataList =
            jsonData.map((item) => TimetableData.fromJson(item)).toList();
        _isBodyLoading = !_isBodyLoading;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.body),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isBodyLoading = !_isBodyLoading;
      });
    }
  }

  deleteEntry(id) async {
    final response = await Webservices().deleteEntry(id);
    if (response.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error occured'),
          backgroundColor: Colors.red,
        ),
      );
      print(response.body);
    }
  }

  double _calculateProgressValue(object) {
    var a = object.fromTime;
    var b = object.toTime;
    int totalTime = b.difference(a).inMinutes;
    int elapsedTime = currentT.difference(a).inMinutes;
    var x = elapsedTime / totalTime;
    return x;
  }

  logout() async {
    setState(() {
      _isBodyLoading = !_isBodyLoading;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    setState(() {
      _isBodyLoading = !_isBodyLoading;
    });
    return Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: AppBar(
        elevation: 0,
        leading: InkWell(
          child: Container(
            padding: EdgeInsets.all(12),
            child: SvgPicture.asset(
              'assets/hamburger-menu-icon.svg',
            ),
          ),
        ),
        backgroundColor: Color(0xff3EA6F2),
        title: Text(
          'Timetable',
          style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              size: size.height * 0.039, //30 h
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_outlined,
              size: size.height * 0.039, //30 h
            ),
          ),
          InkWell(
            onTap: () => null,
            child: Container(
              padding: EdgeInsets.all(size.height * 0.015),
              child: SvgPicture.asset(
                'assets/outline-more-vert.svg',
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff3EA6F2),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddEventsScreen(),
          ),
        ),
        child: Icon(Icons.add),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.038), // 15 w
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.046, // 35 h
            ),
            Container(
              height: size.height * 0.046, // 35 h
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(1.0, 1.0), //(x,y)
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _days
                    .map(
                      (day) => InkWell(
                        onTap: () {
                          setState(() {
                            _selectedDay = day;
                          });
                          print(_selectedDay);
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.020),
                          width: day == _selectedDay
                              ? size.width * 0.203
                              : size.width * 0.114,
                          decoration: BoxDecoration(
                            color: day == _selectedDay ? Colors.green : null,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              day,
                              style: TextStyle(
                                color: _selectedDay == day
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            SizedBox(
              height: size.height * 0.019, //15 h
            ),
            Visibility(
              visible: role == 'Admin' ? true : false,
              child: InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminScreen(),
                    )),
                child: Container(
                  height: size.height * 0.065,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15),
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
                      'ADMIN PAGE',
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                          fontSize: size.height * 0.023,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.013,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                child: _isBodyLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: _timetableDataList.length,
                        itemBuilder: (BuildContext context, index) {
                          return _timetableDataList[index]
                                      .selectedDays
                                      .contains(_selectedDay) ==
                                  true
                              ? Dismissible(
                                  /* background: Container(color: Colors.red), */
                                  key: Key(_timetableDataList[index].id),
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        top: 18, left: 18, right: 18),
                                    margin: EdgeInsets.only(bottom: 20),
                                    width: double.infinity,
                                    height: size.height * 0.115,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border:
                                          Border.all(color: Color(0xE4E4E4)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(1.0, 1.0), //(x,y)
                                          blurRadius: 5,
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                _timetableDataList[index]
                                                        .isLunchBreak
                                                    ? 'Lunch Break'
                                                    : _timetableDataList[index]
                                                        .title,
                                                style: GoogleFonts.roboto(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                '${DateFormat('hh:mm a').format(_timetableDataList[index].fromTime.toLocal())} - ${DateFormat('hh:mm a').format(_timetableDataList[index].toTime.toLocal())}',
                                                style: GoogleFonts.roboto(
                                                    color: Colors.grey),
                                              ),
                                              Container(
                                                child: LinearProgressIndicator(
                                                  backgroundColor:
                                                      Colors.grey[300],
                                                  valueColor: AlwaysStoppedAnimation(
                                                      _calculateProgressValue(
                                                                  _timetableDataList[
                                                                      index]) >
                                                              0.5
                                                          ? Colors.green
                                                          : Colors.yellow),
                                                  value:
                                                      _calculateProgressValue(
                                                          _timetableDataList[
                                                              index]),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: _timetableDataList[index]
                                                    .isLunchBreak
                                                ? EdgeInsets.only(
                                                    left: size.width * 0.229,
                                                    bottom: size.height * 0.02)
                                                : null,
                                            child: Center(
                                              child: _timetableDataList[index]
                                                      .isLunchBreak
                                                  ? SvgPicture.asset(
                                                      'assets/lunch-break-icon.svg',
                                                    )
                                                  : Text(
                                                      'Class: 7 Section: B',
                                                      style: GoogleFonts.roboto(
                                                          color: Colors.grey),
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onDismissed: (direction) {
                                    deleteEntry(_timetableDataList[index].id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Deleted'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    setState(() {
                                      _timetableDataList.removeAt(index);
                                    });
                                  },
                                )
                              : Container();
                        },
                      ),
              ),
            ),
            InkWell(
              onTap: () {
                logout();
              },
              child: Container(
                margin: EdgeInsets.only(bottom: size.height * 0.02),
                height: size.height * 0.065,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    'LOG OUT',
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                        fontSize: size.height * 0.023,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
