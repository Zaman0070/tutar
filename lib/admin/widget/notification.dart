import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tutor_app/admin/widget/custom_notification.dart';
import 'package:tutor_app/services/firbaseservice.dart';

import '../../Provider/user_provider.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  FirebaseServices services = FirebaseServices();
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
          title: Text('Notification',  style: GoogleFonts.poppins(
            textStyle: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black),
          )),
          bottom:  TabBar(
            labelStyle: GoogleFonts.poppins(
              textStyle: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 16.sp,
                  color:  Colors.black
              ),
            ),
            labelColor: Colors.black,

            indicatorColor: Theme.of(context).splashColor,
            tabs: const [
              Tab( text: 'Students'),
              Tab( text: 'Instructors')
            ],
          ),
        ),
        body: TabBarView(
          children: [


            FutureBuilder<QuerySnapshot>(
                future:
                services.users.where('type', isEqualTo: 'student').get(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Some things wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: snapshot.data!.size,
                      itemBuilder: (BuildContext context, int index) {
                        var data = snapshot.data!.docs[index];
                        return InkWell(
                          onTap: () {
                            // userProvider.getStudentDetails(data);
                            // Navigator.push(context, MaterialPageRoute(builder: (_)=>const AttendeesList()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 15),
                            child: Container(
                              height: 7.h,
                              width: 100.w,
                              decoration: BoxDecoration(
                                // boxShadow:  const [
                                //   BoxShadow(color:Colors.black12,spreadRadius: 0,offset: Offset(0, 3),blurRadius: 1)
                                // ],
                                  color: const Color(0xffE1E9FC),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${data['name']} ${data['secondName']}",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                    ),
                                    CircleAvatar(
                                        radius: 2.5.h,
                                        backgroundColor:
                                        const Color(
                                            0xff3B6EE9),
                                        child: IconButton(
                                            onPressed: () {
                                              userProvider.getStudentDetails(data);
                                              Navigator.push(context, MaterialPageRoute(builder: (_)=>const CustomNotifications()));
                                            },
                                            icon: const Icon(
                                              CupertinoIcons
                                                  .arrow_right_circle,
                                              color: Colors.white,
                                            )))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                }),
            FutureBuilder<QuerySnapshot>(
                future:
                services.users.where('type', isEqualTo: 'faculty').get(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Some things wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: snapshot.data!.size,
                      itemBuilder: (BuildContext context, int index) {
                        var data = snapshot.data!.docs[index];
                        return InkWell(
                          onTap: () {
                            // userProvider.getStudentDetails(data);
                            // Navigator.push(context, MaterialPageRoute(builder: (_)=>const AttendeesList()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 15),
                            child: Container(
                              height: 7.h,
                              width: 100.w,
                              decoration: BoxDecoration(
                                // boxShadow:  const [
                                //   BoxShadow(color:Colors.black12,spreadRadius: 0,offset: Offset(0, 3),blurRadius: 1)
                                // ],
                                  color: const Color(0xffE1E9FC),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${data['name']} ${data['secondName']}",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                    ),
                                    CircleAvatar(
                                        radius: 2.5.h,
                                        backgroundColor:
                                        const Color(
                                            0xff3B6EE9),
                                        child: IconButton(
                                            onPressed: () {
                                              userProvider.getStudentDetails(data);
                                              Navigator.push(context, MaterialPageRoute(builder: (_)=>const CustomNotifications()));
                                            },
                                            icon: const Icon(
                                              CupertinoIcons
                                                  .arrow_right_circle,
                                              color: Colors.white,
                                            )))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                }),
          ],
        ),

      ),
    );
  }
}
