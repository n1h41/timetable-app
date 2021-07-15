import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timetable_app/models/timetable_data_model.dart';
import 'package:timetable_app/models/user_model.dart';
import 'package:timetable_app/services/web_services.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  bool _isBodyLoading = false;
  List userList = [];
  @override
  void initState() {
    super.initState();
    getAllUsers();
  }

  getAllUsers() async {
    setState(() {
      _isBodyLoading = !_isBodyLoading;
    });
    final response = await Webservices().getAllUsers();
    print(response.body);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      setState(() {
        _isBodyLoading = !_isBodyLoading;
        userList = jsonData.map((user) => User.fromJson(user)).toList();
      });
    } else {
      {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff3EA6F2),
        title: Text('Admin Page'),
        centerTitle: true,
        elevation: 0,
      ),
      body: _isBodyLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: ListView.builder(
                itemCount: userList.length,
                itemBuilder: (BuildContext context, index) => ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ListDetail(user: userList[index]),
                      ),
                    );
                  },
                  tileColor: Colors.white,
                  title: Text(userList[index].name),
                  subtitle: Text(userList[index].email),
                ),
              ),
            ),
    );
  }
}

class ListDetail extends StatefulWidget {
  const ListDetail({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  _ListDetailState createState() => _ListDetailState();
}

class _ListDetailState extends State<ListDetail> {
  DateTime currentT = DateTime.now().toLocal();
  List entryList = [];
  bool _isBodyLoading = false;
  @override
  void initState() {
    super.initState();
    getUserEntries(widget.user.id);
  }

  getUserEntries(id) async {
    setState(() {
      _isBodyLoading = !_isBodyLoading;
    });
    final response = await Webservices().getUserEntries(id);
    print(response.body);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      setState(() {
        _isBodyLoading = !_isBodyLoading;
        entryList = jsonData.map((user) => TimetableData.fromJson(user)).toList();
      });
    } else {
      {
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
  }
double _calculateProgressValue(object) {
    var a = object.fromTime;
    var b = object.toTime;
    int totalTime = b.difference(a).inMinutes;
    int elapsedTime = currentT.difference(a).inMinutes;
    var x = elapsedTime / totalTime;
    return x;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff3EA6F2),
        title: Text('${widget.user.name}'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(child: Container(child: ListView.builder(
                itemCount: entryList.length,
                itemBuilder: (BuildContext context, index) => Container(
                                    padding: EdgeInsets.only(
                                        top: 18, left: 18, right: 18),
                                    margin: EdgeInsets.only(bottom: 20),
                                    width: double.infinity,
                                    height: 88,
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
                                                entryList[index]
                                                        .isLunchBreak
                                                    ? 'Lunch Break'
                                                    : entryList[index]
                                                        .title,
                                                style: GoogleFonts.roboto(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                '${DateFormat('hh:mm a').format(entryList[index].fromTime.toLocal())} - ${DateFormat('hh:mm a').format(entryList[index].toTime.toLocal())}',
                                                style: GoogleFonts.roboto(
                                                    color: Colors.grey),
                                              ),
                                              Container(
                                                child: LinearProgressIndicator(
                                                  backgroundColor:
                                                      Colors.grey[300],
                                                  valueColor: AlwaysStoppedAnimation(
                                                      _calculateProgressValue(
                                                                  entryList[
                                                                      index]) >
                                                              0.5
                                                          ? Colors.green
                                                          : Colors.yellow),
                                                  value:
                                                      _calculateProgressValue(
                                                          entryList[
                                                              index]),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: entryList[index]
                                                      .isLunchBreak
                                                  ? EdgeInsets.only(left: 90, bottom: 15) : null,
                                            child: Center(
                                              child: entryList[index]
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
              ),))
          ],
        ),
      ),
    );
  }
}
