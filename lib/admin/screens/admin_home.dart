import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:tutor_app/admin/widget/faculty_List.dart';
import 'package:tutor_app/admin/widget/student_list.dart';
import 'package:tutor_app/services/firbaseservice.dart';

import '../widget/setting.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  String admin = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAdminData();

  }

  Future getAdminData() async {
    await _firestore
        .collection('users').where('type',isEqualTo: 'admin')
        .get()
        .then((chatMap) {
      for (var element in chatMap.docs) {
        admin = element['url']  ;
      }
      print(admin);
      setState(() {

      });
    });
  }

  FirebaseServices services = FirebaseServices();


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            toolbarHeight: 120,
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
           // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            title: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FutureBuilder<DocumentSnapshot>(
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
                          return  CachedNetworkImage(
                            imageBuilder: (context,imageProvider)=>CircleAvatar(
                              radius: 25,
                              backgroundImage: imageProvider,
                            ),
                            cacheManager: CacheManager(Config(
                                'customCacheKey',
                                stalePeriod: const Duration(days: 500)

                            )),
                            imageUrl: snapshot.data!['url'],

                          );
                        }),
                  ],
                ),
                SizedBox(height: 2.h,),
                RichText(
                  text: TextSpan(
                      text: 'Welcome,',
                      style:  GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 23.sp,
                            color:  Colors.black
                        ),
                      ),
                      children: [
                        TextSpan(text: ' Admin! 👋', style:  GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 23.sp,
                              color:  Colors.black
                          ),
                        ),)
                      ]
                  ),
                ),
              ],
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
        body: TabBarView(children: [
          Container(
            height: 100.h,
            width: 100.w,
            child: const Padding(
              padding: EdgeInsets.all(25.0),
              child:StudentList(),
            ),
          ),
          Container(
            height: 100.h,
            width: 100.w,
            child: const Padding(
              padding: EdgeInsets.all(25.0),
              child: FacultyList(),
            ),
          ),
        ]),
        ));
  }
}
