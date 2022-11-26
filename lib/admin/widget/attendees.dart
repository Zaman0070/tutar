import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tutor_app/Provider/user_provider.dart';
import 'package:tutor_app/admin/widget/attendees_list.dart';
import 'package:tutor_app/services/firbaseservice.dart';

class Attendees extends StatefulWidget {
  const Attendees({Key? key}) : super(key: key);

  @override
  State<Attendees> createState() => _AttendeesState();
}

class _AttendeesState extends State<Attendees> {
  FirebaseServices services =FirebaseServices();
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
          title: Text('Attendees',  style: GoogleFonts.poppins(
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
                future: services.users.where('type',isEqualTo: 'student').get(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                        return     InkWell(
                          onTap: (){
                            userProvider.getStudentDetails(data);
                            Navigator.push(context, MaterialPageRoute(builder: (_)=>const AttendeesList()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 15),
                            child: Container(
                              height: 7.h,
                              width: 100.w,
                              decoration: BoxDecoration(
                                // boxShadow:  const [
                                //   BoxShadow(color:Colors.black12,spreadRadius: 0,offset: Offset(0, 3),blurRadius: 1)
                                // ],
                                  color: const Color(0xffE1E9FC),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("${data['name']} ${data['secondName']}",  style:  GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.sp,
                                      ),
                                    ),),
                                    Text('See Attendance', style:  GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13.sp,
                                        color: const Color(0xff305F72),
                                      ),)),

                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                  );
                }),
            FutureBuilder<QuerySnapshot>(
                future: services.users.where('type',isEqualTo: 'faculty').get(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                        return     InkWell(
                          onTap: (){
                            userProvider.getStudentDetails(data);
                            Navigator.push(context, MaterialPageRoute(builder: (_)=>const AttendeesList()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 15),
                            child: Container(
                              height: 7.h,
                              width: 100.w,
                              decoration: BoxDecoration(
                                // boxShadow:  const [
                                //   BoxShadow(color:Colors.black12,spreadRadius: 0,offset: Offset(0, 3),blurRadius: 1)
                                // ],
                                  color: const Color(0xffE1E9FC),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("${data['name']} ${data['secondName']}",  style:  GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.sp,
                                      ),
                                    ),),
                                    Text('See Attendees', style:  GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13.sp,
                                        color: const Color(0xff305F72),
                          ),)),

                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                  );
                }),
          ],
        )
      ),
    );
  }
}
