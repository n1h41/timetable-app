// To parse this JSON data, do
//
//     final timetableData = timetableDataFromJson(jsonString);

import 'dart:convert';

TimetableData timetableDataFromJson(String str) => TimetableData.fromJson(json.decode(str));

String timetableDataToJson(TimetableData data) => json.encode(data.toJson());

class TimetableData {
    TimetableData({
        this.id,
        this.selectedDays,
        this.title,
        this.isLunchBreak,
        this.fromTime,
        this.toTime,
        this.userId,
    });

    String? id;
    List<String>? selectedDays;
    String? title;
    bool? isLunchBreak;
    DateTime? fromTime;
    DateTime? toTime;
    String? userId;

    factory TimetableData.fromJson(Map<String, dynamic> json) => TimetableData(
        id: json["_id"] == null ? null : json["_id"],
        selectedDays: json["selectedDays"] == null ? null : List<String>.from(json["selectedDays"].map((x) => x)),
        title: json["title"] == null ? null : json["title"],
        isLunchBreak: json["isLunchBreak"] == null ? null : json["isLunchBreak"],
        fromTime: json["fromTime"] == null ? null : DateTime.parse(json["fromTime"]),
        toTime: json["toTime"] == null ? null : DateTime.parse(json["toTime"]),
        userId: json["userId"] == null ? null : json["userId"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "selectedDays": selectedDays == null ? null : List<dynamic>.from(selectedDays!.map((x) => x)),
        "title": title == null ? null : title,
        "isLunchBreak": isLunchBreak == null ? null : isLunchBreak,
        "fromTime": fromTime == null ? null : fromTime!.toIso8601String(),
        "toTime": toTime == null ? null : toTime!.toIso8601String(),
        "userId": userId == null ? null : userId,
    };
}
