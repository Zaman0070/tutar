import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tutor_app/admin/widget/setting.dart';
import 'package:tutor_app/services/firbaseservice.dart';

import '../../Provider/user_provider.dart';

class FacultyList extends StatefulWidget {
  const FacultyList({Key? key}) : super(key: key);

  @override
  State<FacultyList> createState() => _FacultyListState();
}

class _FacultyListState extends State<FacultyList> {
  FirebaseServices services = FirebaseServices();
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return FutureBuilder<QuerySnapshot>(
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
                                Navigator.push(context, MaterialPageRoute(builder: (_)=>const Setting(index: 1,)));
                              }, icon: const Icon(Icons.settings,color: Colors.grey,)),
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
