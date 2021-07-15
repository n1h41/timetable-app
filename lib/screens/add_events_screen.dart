import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timetable_app/models/timetable_data_model.dart';
import 'package:timetable_app/screens/home_screen.dart';
import 'package:timetable_app/services/web_services.dart';

class AddEventsScreen extends StatefulWidget {
  const AddEventsScreen({Key? key}) : super(key: key);

  @override
  _AddEventsScreenState createState() => _AddEventsScreenState();
}

class _AddEventsScreenState extends State<AddEventsScreen> {
  TextEditingController titleTEC = TextEditingController();
  bool _switchValue = false;
  List<String> _selectedDays = [];
  DateTime fromTime = DateTime.now();
  DateTime toTime = DateTime.now();
  List<String> _days = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ];
  void addEntry() async {
    if (_selectedDays.length >= 1) {
      final entry = new TimetableData(
          isLunchBreak: _switchValue,
          selectedDays: _selectedDays,
          title: titleTEC.text.length < 1 ? null : titleTEC.text,
          fromTime: fromTime,
          toTime: toTime);
      print(fromTime);
      final response = await Webservices().addEntry(timetableDataToJson(entry));
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Entry added'),
            backgroundColor: Colors.green,
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
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Select atleast 1 day'),
          backgroundColor: Colors.yellow[900],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.grey[300],
                  height: size.height * 0.077,
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HomeScreen(),
                            ),
                          ),
                          child: Container(
                            child: Center(
                              child: Text(
                                'CANCEL',
                                style: GoogleFonts.roboto(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            addEntry();
                          },
                          child: Container(
                            child: Center(
                              child: Text(
                                'SAVE',
                                style: GoogleFonts.roboto(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.025,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: _days
                        .map(
                          (day) => InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            child: ChoiceChip(
                                label: Text(day),
                                selected:
                                    _selectedDays.contains(day) ? true : false),
                            onTap: () {
                              setState(() {
                                if (_selectedDays.contains(day))
                                  _selectedDays.remove(day);
                                else
                                  _selectedDays.add(day);
                              });
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Divider(
                  thickness: 1,
                ),
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Lunch Break',
                        style: GoogleFonts.roboto(fontSize: size.height * 0.025),
                      ),
                      VerticalDivider(
                        indent: 2,
                        endIndent: 2,
                        thickness: 1,
                      ),
                      Switch(
                        value: _switchValue,
                        onChanged: (value) {
                          setState(() {
                            _switchValue = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 1,
                ),
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('From'),
                      VerticalDivider(
                        indent: 2,
                        endIndent: 2,
                        thickness: 1,
                      ),
                      Container(
                        height: 200,
                        width: 300,
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.time,
                          onDateTimeChanged: (DateTime value) {
                            setState(() {
                              fromTime = value.toLocal();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('To     '),
                      VerticalDivider(
                        indent: 2,
                        endIndent: 2,
                        thickness: 1,
                      ),
                      Container(
                        height: size.height * 0.3,
                        width: size.width * 0.767,
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.time,
                          onDateTimeChanged: (DateTime value) {
                            setState(() {
                              toTime = value.toLocal();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 1,
                ),
                Visibility(
                  visible: _switchValue ? false : true,
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          content: TextField(
                            controller: titleTEC,
                          ),
                          actions: [
                            FlatButton(
                              textColor: Colors.blue,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('CANCEL'),
                            ),
                            FlatButton(
                              textColor: Colors.blue,
                              onPressed: () {
                                setState(() {});
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      /* color: Colors.yellow, */
                      height: size.height * 0.08,
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Title',
                              style: GoogleFonts.roboto(fontSize: size.height * 0.025),
                            ),
                            Text(
                              titleTEC.text == '' ? 'None' : titleTEC.text,
                              style: GoogleFonts.roboto(
                                fontSize: size.height * 0.020,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
