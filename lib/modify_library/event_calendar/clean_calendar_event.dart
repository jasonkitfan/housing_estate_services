import 'package:flutter/material.dart';

class CleanCalendarEvent {
  String summary;
  String description;
  String location;
  DateTime startTime;
  DateTime endTime;
  String animation;
  Color color;
  bool isAllDay;
  bool isDone;

  CleanCalendarEvent(this.summary,
      {this.description = '',
      this.location = '',
      required this.startTime,
      required this.endTime,
      required this.animation,
      this.color = Colors.blue,
      this.isAllDay = false,
      this.isDone = false});
}
