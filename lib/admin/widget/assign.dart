import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tutor_app/Provider/user_provider.dart';
import 'package:tutor_app/services/firbaseservice.dart';

class Assign extends StatefulWidget {
  const Assign({Key? key}) : super(key: key);

  @override
  State<Assign> createState() => _AssignState();
}

class _AssignState extends State<Assign> {
  @override
  Widget build(BuildContext context) {
    FirebaseServices services = FirebaseServices();
    UserProvider userProvider =Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text('Assign',  style: GoogleFonts.poppins(
          textStyle: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black),
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FutureBuilder<QuerySnapshot>(
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
                    var dataStudent = snapshot.data!.docs[index];
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
                              Text('${dataStudent['name']} ${dataStudent['secondName']}',  style:  GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.sp,
                                ),
                              ),),
                             InkWell(
                                onTap: (){
                                  showDialog(
                                      context: context,
                                      builder: (ctxt) =>   AlertDialog(
                                        scrollable: true,
                                        title: const Text('List Of Instructor'),
                                       actions: [
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
                                              var dataFaculty = snapshot.data!.docs[index];
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
                                                        Text(dataFaculty['name'],  style:  GoogleFonts.poppins(
                                                          textStyle: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 13.sp,
                                                          ),
                                                        ),),
                                                        InkWell(
                                                          onTap: ()async{
                                                            if(dataStudent['assign']=='false') {
                                                              await dataFaculty
                                                                  .reference
                                                                  .update({
                                                                'students': FieldValue
                                                                    .arrayUnion(
                                                                    [
                                                                      dataStudent['uid']
                                                                    ]),
                                                              });
                                                              await dataStudent
                                                                  .reference
                                                                  .update(
                                                                  {
                                                                    'assign': 'true',
                                                                    'fId': dataFaculty['uid'],
                                                                  });
                                                              setState(() {});
                                                              Navigator.pop(
                                                                  context);
                                                            }else{
                                                              await dataFaculty
                                                                  .reference
                                                                  .update({
                                                                'students': FieldValue
                                                                    .arrayRemove(
                                                                    [
                                                                      dataStudent['uid']
                                                                    ]),
                                                              });
                                                              await dataStudent
                                                                  .reference
                                                                  .update(
                                                                  {
                                                                    'assign': 'false',
                                                                    'fId': '',
                                                                  });
                                                              setState(() {
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            }
                                                          },
                                                          child: Container(
                                                            height: 4.5.h,
                                                            width: 28.w,
                                                            decoration:  BoxDecoration(
                                                                color:const Color(0xff3B6EE9),
                                                                borderRadius: BorderRadius.circular(10)
                                                            ),
                                                            child:  Center(child: Text(dataStudent['assign']=='false'?'Assign':"Unassigned",    style:  GoogleFonts.poppins(
                                                              textStyle: TextStyle(
                                                                  fontWeight: FontWeight.w600,
                                                                  fontSize: 11.sp,
                                                                  color:  Colors.white
                                                              ),
                                                            ),)) ,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                        );
                                      })
                                       ],
                                      )
                                  );

                                },
                                child: Container(
                                  height: 4.h,
                                  width: 25.w,
                                  decoration:  BoxDecoration(
                                      color:const Color(0xff3B6EE9),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child:  Center(child: Text(dataStudent['assign']=='false'?'Assign':'Unassigned',    style:  GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11.sp,
                                        color:  Colors.white
                                    ),
                                  ),)) ,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
              );
            }),
      ),
    );
  }
}
