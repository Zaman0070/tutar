import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tutor_app/services/firbaseservice.dart';

import '../../Provider/user_provider.dart';

class SingleSudentAnnoun extends StatefulWidget {
  const SingleSudentAnnoun({Key? key}) : super(key: key);

  @override
  State<SingleSudentAnnoun> createState() => _SingleSudentAnnounState();
}

class _SingleSudentAnnounState extends State<SingleSudentAnnoun> {
  FirebaseServices services =FirebaseServices();
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    var data = userProvider.studentData;
    var announcmentController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    FirebaseServices services = FirebaseServices();

    Widget _buildAnnouncementTF() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            // alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xffE1E9FC),
            ),
            height: 20.h,
            child:  TextFormField(
              validator: (value){
                if(value == null || value.isEmpty){
                  return 'Enter Student Email';
                }
              },
              maxLines: 4,
              controller: announcmentController,
              keyboardType: TextInputType.text,
              style:const TextStyle(
                color: Colors.black,
                fontFamily: 'OpenSans',
              ),
              decoration:const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0,left: 10),

                hintText: 'Enter Any Situation',
                //  hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ],
      );
    }
    Widget _sbuildLoginBtn() {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 25.0),
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(15.0),

             backgroundColor: const Color(0xff376AED),
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),

          onPressed: (){
            services.announcement.doc(data!['uid']).set({
              "announcement" : announcmentController.text,
              'uid': data['uid']
            });
            setState(() {

            });
          },

          child: const Text(
            'Announcement',
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset:  false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text("${data!['name']} ${data['secondName']}",  style: GoogleFonts.poppins(
          textStyle: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black),
        )),
      ),
    body:  Column(
        children: [
          FutureBuilder<QuerySnapshot>(
              future: services.announcement.where('uid',isEqualTo: data['uid']).get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.data == null) {
                  return Container();
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.blue),
                      ));
                }
                return  ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: snapshot.data!.size,
                    itemBuilder:
                        (BuildContext context, int index) {
                          var data = snapshot.data!.docs[index];
                    return Stack(
                      children: [

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 20),
                          child: Container(
                            height: 12.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                              color: const Color(0xffF1D5D8),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black12,
                                    spreadRadius: 1,
                                    offset: Offset(3, 3),
                                    blurRadius: 10)
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 0.5.h,
                                  ),
                                  Text(
                                    'Announcements',
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13.sp,
                                          color: Colors.black),
                                    ),
                                  ),
                                  Text(
                                    data['announcement'],
                                    maxLines:2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(

                                          fontWeight: FontWeight.w300,
                                          fontSize: 11.sp,
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right:5,
                          top:-4,
                          child: IconButton(
                              onPressed: (){
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(15),
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.all(15),
                                          height: 20.h,
                                          child: Column(
                                            // mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                'Are you sure delete ?',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(height: 4.h),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Cancel'),
                                                  ),
                                                  SizedBox(width: 5.w),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        data.reference.delete();
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Delete'),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              }, icon:  Icon(Icons.delete,color: Colors.grey[700],size: 30,)),
                        ),
                      ],
                    );
                  }
                );
              }
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildAnnouncementTF(),
                _sbuildLoginBtn(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
