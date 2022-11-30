import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:tutor_app/services/firbaseservice.dart';

import '../../Provider/user_provider.dart';

class SeeAttendees extends StatefulWidget {
  int index;
   SeeAttendees({Key? key,required this.index}) : super(key: key);

  @override
  State<SeeAttendees> createState() => _SeeAttendeesState();
}

class _SeeAttendeesState extends State<SeeAttendees> {
  FirebaseServices services = FirebaseServices();
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
        title: Text('Last 30 Days 🗓️',  style: GoogleFonts.poppins(
          textStyle: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black),
        )),
      ),
      body: widget.index==0? Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
            shrinkWrap:true,
            itemCount: data!['attendees'].length>=30 ? 30: data['attendees'].length ,
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
                      child: Row(
                        children: [
                          SizedBox(
                            width: 3.w,
                          ),
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
      ):Padding(
        padding: const EdgeInsets.all(12.0),
        child: FutureBuilder<DocumentSnapshot>(
            future: services.getUserData(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.data == null) {
                return Container();
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ));
              }

              return ListView.builder(
                  shrinkWrap:true,
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!['attendees'].length >=30 ? 30:snapshot.data!['attendees'].length  ,
                  itemBuilder: (BuildContext context ,int index){
                    var name = snapshot.data!['date'][(snapshot.data!['date'].length -1) - index];
                    var dateList = snapshot.data!['attendees'][(snapshot.data!['attendees'].length -1) - index];
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
                              color:index == 0? const Color(0xff3C67FF):index == 1? const Color(0xffD66BAB).withOpacity(0.7): const Color(0xff7FD77D).withOpacity(0.7),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 3.w,
                                ),
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
                                      text:"Joined ${name.replaceAll('0', '').replaceAll('1', '').replaceAll('2', '').replaceAll('3', '').replaceAll('4', '').replaceAll('5', '').replaceAll('6', '')
                                          .replaceAll('7', '').replaceAll('8', '').replaceAll('9', '').replaceAll('-', '')}'s Session At ",
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
              );
            })
      ),
    );
  }
}
