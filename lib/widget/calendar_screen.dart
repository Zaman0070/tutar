import 'dart:collection';

import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_calendar/flutter_advanced_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:table_calendar/table_calendar.dart';

import '../services/firbaseservice.dart';

class CalendarScreen extends StatefulWidget {
  int? index;
//  DateTime? rangeStart;
  List<dynamic>? rangeEnd;
  CalendarScreen(
      {Key? key,
      required this.index,
      required this.rangeEnd,
     // required this.rangeStart
      })
      : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat weekFormat = CalendarFormat.twoWeeks;
  DateTime? selectedDate;

  @override
  void initState() {
    setState(() {
      selectedDate = DateTime.now();
    });
    super.initState();
  }


  FirebaseServices services = FirebaseServices();


  final _calendarControllerToday = AdvancedCalendarController.today();

  @override
  Widget build(BuildContext context) {
    final List<DateTime> events = List.generate(
        widget.rangeEnd!.length,
        (index) => DateTime.fromMicrosecondsSinceEpoch(
            widget.rangeEnd![index].microsecondsSinceEpoch));

    return AdvancedCalendar(
      innerDot: false,
      calendarTextStyle: TextStyle(color: Colors.red,fontSize: 50),
      controller: _calendarControllerToday,
      events: events,
      startWeekDay: 1,
      headerStyle: GoogleFonts.poppins(
        textStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 17.sp,
            color: Color(0xff3B6EE9)),
      ),
      todayStyle: GoogleFonts.poppins(
        textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
            color: Color(0xff3B6EE9)),
      ),
    );
  }
}
