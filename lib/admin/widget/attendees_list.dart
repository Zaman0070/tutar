import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tutor_app/Provider/user_provider.dart';
import 'package:intl/intl.dart';

class AttendeesList extends StatefulWidget {
  const AttendeesList({Key? key}) : super(key: key);

  @override
  State<AttendeesList> createState() => _AttendeesListState();
}

class _AttendeesListState extends State<AttendeesList> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    var data = userProvider.studentData;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text("${data!['name']}'s Attendance",  style: GoogleFonts.poppins(
          textStyle: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black),
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
            shrinkWrap:true,
            itemCount: data['attendees'].length>=30 ? 30: data['attendees'].length ,
            itemBuilder: (BuildContext context ,int index){

              var dateList = data['attendees'][(data['attendees'].length -1) - index];
              var day = DateTime.fromMicrosecondsSinceEpoch(
                  dateList.microsecondsSinceEpoch);
              String formattedTime1 = DateFormat.jm().format(DateTime.fromMicrosecondsSinceEpoch(
                  dateList!.microsecondsSinceEpoch));
              var header = DateFormat('MMMM, yyyy').format(DateTime.fromMicrosecondsSinceEpoch(
                  dateList.microsecondsSinceEpoch));
              return  Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Container(
                      height: 6.2.h,
                      width: 6.2.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:const Color(0xff3C67FF),
                      ),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                            children: [
                              Text(
                                day.day.toString(),
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16.sp,
                                      color: Colors.white),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Text(
                                  'th',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 3.h,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          header,
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15.sp,
                                color: const Color(0xff343674)),
                          ),
                        ),
                        Container(
                          width: 67.w,
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                                text:"Joined Session At "
                                ,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12.sp,
                                      color: Colors.grey[600]),
                                ),
                                children: [
                                  TextSpan(
                                    text: "$formattedTime1.",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12.sp,
                                          color: Colors.grey[600]),
                                    ),
                                  )
                                ]),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            }
        ),
      ),
    );
  }
}
