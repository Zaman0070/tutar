import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tutor_app/Provider/user_provider.dart';
import 'package:tutor_app/admin/widget/setting.dart';
import 'package:tutor_app/services/firbaseservice.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentList extends StatefulWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  FirebaseServices services = FirebaseServices();
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return FutureBuilder<QuerySnapshot>(
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
            googleMeet() async {
              var url = data['link'];
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            }
            return     Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                      Row(
                        children: [
                          IconButton(onPressed: (){
                            userProvider.getStudentDetails(data);
                            Navigator.push(context, MaterialPageRoute(builder: (_)=>const Setting(index: 0,)));
                          }, icon: const Icon(Icons.settings,color: Colors.grey,)),
                          InkWell(
                            onTap: googleMeet,
                            child: Container(
                              height: 4.5.h,
                              width: 28.w,
                              decoration:  BoxDecoration(
                                  color:const Color(0xff3B6EE9),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child:  Center(child: Text('Join Class',    style:  GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11.sp,
                                    color:  Colors.white
                                ),
                              ),)) ,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }
      );
    });
  }
}
