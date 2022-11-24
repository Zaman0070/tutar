// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tutor_app/admin/widget/manage_shedual/utils.dart';
import 'package:intl/intl.dart';
import '../../../Provider/user_provider.dart';


class Calender extends StatefulWidget {
  @override
  _CalenderState createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {


  final ValueNotifier<List<Event>> _selectedEvents = ValueNotifier([]);

  // Using a `LinkedHashSet` is recommended due to equality comparison override
  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForDays(Set<DateTime> days) {
    // Implementation example
    // Note that days are in selection order (same applies to events)
    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }


  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    var data = userProvider.studentData;
    List<dynamic> attendees = data!['attendees'];
    void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
      setState(() {
        _focusedDay = focusedDay;
        // Update values in a Set
        if (_selectedDays.contains(selectedDay)) {
          _selectedDays.remove(selectedDay);
          data.reference.update({
            'schedule': FieldValue.arrayRemove([selectedDay]),
          });
        } else {
          _selectedDays.add(selectedDay);
          data.reference.update({
            'schedule': FieldValue.arrayUnion([selectedDay]),
          });
        }
      });


      _selectedEvents.value = _getEventsForDays(_selectedDays);
    }
    return Scaffold(
      backgroundColor: Colors.white,
appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black),
      centerTitle: true,
      title: Text('Manage Schedule',  style: GoogleFonts.poppins(
        textStyle: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black),
      )),
    ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TableCalendar<Event>(
              firstDay: kFirstDay,
              lastDay: kLastDay,
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              startingDayOfWeek: StartingDayOfWeek.monday,
              selectedDayPredicate: (day) {
                // Use values from Set to mark multiple days as selected
                return _selectedDays.contains(day);
              },
              onDaySelected: _onDaySelected,
              rowHeight: 35,
              sixWeekMonthsEnforced: false,
              daysOfWeekHeight: 35,
              headerStyle: HeaderStyle(
                titleCentered: true,
                rightChevronMargin:const EdgeInsets.only(right: 35.0),
                leftChevronMargin:const EdgeInsets.only(left: 35.0),
                formatButtonVisible:false,
                titleTextStyle:   GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      color: const Color(0xff3B6EE9)
                  ),
                ),
                leftChevronIcon: Image.asset('assets/icons/arr_back.png',height: 12,),
                rightChevronIcon: Image.asset('assets/icons/arr_far.png',height: 12,),
              ),
              daysOfWeekStyle:  DaysOfWeekStyle(
                dowTextFormatter: (date, locale) => DateFormat.E(locale).format(date)[0],
                weekdayStyle:   GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                      color: const Color(0xff3B6EE9)
                  ),
                ),
                weekendStyle: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                      color: const Color(0xff3B6EE9)
                  ),
                ),
              ),
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
          ),
          const SizedBox(height: 10.0),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10
                ),
                itemCount: data['schedule'].length,
                itemBuilder: (BuildContext ctx, index) {
                  var dateList = data['schedule'][index];
                  var day = DateTime.fromMicrosecondsSinceEpoch(
                      dateList.microsecondsSinceEpoch);
                  return InkWell(
                    onTap: (){
                      setState(() {
                        data.reference.update({
                          'schedule': FieldValue.arrayRemove([dateList]),
                        });
                      });
                    },
                    child: CircleAvatar(
                      child: Center(child: Text(day.day.toString())),
                    ),
                  );
                }),
          ),


        ],
      ),
    );
  }
}