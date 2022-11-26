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
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  CalendarFormat weekFormat = CalendarFormat.twoWeeks;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? selectedDate;

  @override
  void initState() {
    setState(() {
      selectedDate = DateTime.now();
    });
    super.initState();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseServices services = FirebaseServices();

  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  final _calendarControllerToday = AdvancedCalendarController.today();
  final _calendarControllerCustom =
      AdvancedCalendarController.custom(DateTime(2022, 10, 23));

  @override
  Widget build(BuildContext context) {
    // return CalendarAppBar(
    //   selectedDate: DateTime.now(),
    //   accent: const Color(0xff3B6EE9),
    //   backButton: false,
    //   fullCalendar: true,
    //   firstDate: widget.rangeStart,
    //   onDateChanged: (value) => setState(() => selectedDate = value),
    //   lastDate:  DateTime.now(),
    // events: List.generate(
    //   widget.rangeEnd!.length
    // , (index) =>DateTime.fromMicrosecondsSinceEpoch(
    //     widget.rangeEnd![index].microsecondsSinceEpoch)),
    // );
    // return SfCalendar(
    //   showNavigationArrow: true,
    //   viewHeaderStyle: const ViewHeaderStyle(
    //     dayTextStyle: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold)
    //   ),
    //   headerHeight: 50,
    //   headerStyle: CalendarHeaderStyle(textAlign:TextAlign.center,textStyle: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 18.sp)) ,
    //   blackoutDatesTextStyle: const TextStyle(color: Colors.green,fontWeight: FontWeight.bold),
    //   blackoutDates: List.generate(widget.rangeEnd!.length, (index) => DateTime.fromMicrosecondsSinceEpoch(
    //     widget.rangeEnd![index].microsecondsSinceEpoch
    //   )),
    //   view: CalendarView.month,
    //   monthViewSettings: const MonthViewSettings(showAgenda: false),
    // );
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
