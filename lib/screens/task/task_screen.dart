import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tutor_app/services/firbaseservice.dart';
import 'package:tutor_app/widget/task_student.dart';

import '../../Provider/user_provider.dart';

class TaskScreen extends StatefulWidget {
  int? index;

  TaskScreen({Key? key, required this.index}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  var taskController = TextEditingController();

  FirebaseServices services = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xff3B6EE9),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 2.h),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: widget.index == 0 ? 8.h : 4.h,
                    ),
                    widget.index == 0
                        ? Row(
                            children: [
                              Text(
                                'Your',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 30.sp,
                                      color: Colors.white),
                                ),
                              ),
                              Text(
                                ' Tasks',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 30.sp,
                                      color: const Color(0xffE9CE0F)),
                                ),
                              ),
                            ],
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ' Assign',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 30.sp,
                                        color: Colors.white),
                                  ),
                                ),
                                Text(
                                  ' Tasks',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 30.sp,
                                        color: const Color(0xffE9CE0F)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 30.0, left: widget.index == 1 ? 45 : 0),
                  child: Image.asset(
                    'assets/images/6.png',
                    height: 16.h,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 69.h,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: Colors.white),
            child: widget.index == 0
                ? FutureBuilder<QuerySnapshot>(
                    future: services.task
                        .doc(services.user!.uid)
                        .collection('tasks')
                        .get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.data == null) {
                        return Container();
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                              Theme.of(context).primaryColor),
                        ));
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.size,
                            itemBuilder: (BuildContext context, int index) {
                              var data = snapshot.data!.docs[index];
                              return Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 1.h),
                                    child: Container(
                                      height: 10.h,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: const Color(0xffD7DDEC)
                                              .withOpacity(0.4)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 3.h,
                                            ),
                                            Image.asset(
                                              'assets/icons/tsk.png',
                                              height: 5.h,
                                            ),
                                            SizedBox(
                                              width: 3.h,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 2.h),
                                                Text(
                                                  'Prepare your task',
                                                  style: GoogleFonts.lato(
                                                    textStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 14.sp,
                                                        color: const Color(
                                                            0xff305F72)),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 0.4.h,
                                                ),
                                                Container(
                                                    width: 60.w,
                                                    child: Text(
                                                      data['task'],
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 11.5.sp,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ))
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                      );
                    })
                : FutureBuilder<DocumentSnapshot>(
                    future: services.getUserData(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.data == null) {
                        return Container();
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.blue),
                        ));
                      }
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!['students'].length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return FutureBuilder<QuerySnapshot>(
                                future: services.users
                                    .where('uid',
                                        isEqualTo: snapshot.data!['students']
                                            [index])
                                    .get(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return const Text('Some things wrong');
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ));
                                  }
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      physics: const ScrollPhysics(),
                                      itemCount: snapshot.data!.size,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        var data = snapshot.data!.docs[index];
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 3.h, vertical: 1.h),
                                          child: Container(
                                            height: 10.h,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: const Color(0xffD7DDEC)
                                                    .withOpacity(0.4)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 2.h,
                                                      ),
                                                      CachedNetworkImage(
                                                        imageBuilder: (context,imageProvider)=>CircleAvatar(
                                                          radius: 25,
                                                          backgroundImage: imageProvider,
                                                        ),
                                                        cacheManager: CacheManager(Config(
                                                            'customCacheKey',
                                                            stalePeriod: const Duration(days: 500)

                                                        )),
                                                        imageUrl: data['url'],

                                                      ),
                                                      SizedBox(
                                                        width: 3.h,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height:
                                                                widget.index ==
                                                                        0
                                                                    ? 2.h
                                                                    : 3.5.h,
                                                          ),
                                                          Text(
                                                            "${data['name']} ${data['secondName']}",
                                                            style: GoogleFonts
                                                                .lato(
                                                              textStyle: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize:
                                                                      14.sp,
                                                                  color: const Color(
                                                                      0xff305F72)),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 0.4.h,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  CircleAvatar(
                                                      radius: 3.h,
                                                      backgroundColor:
                                                          const Color(
                                                              0xff3B6EE9),
                                                      child: IconButton(
                                                          onPressed: () {
                                                            userProvider
                                                                .getStudentDetails(
                                                                    data);
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (_) =>
                                                                        const StudentTask()));
//
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
                                        );
                                      });
                                });
                          });
                    }),
          ),
        ],
      ),
    );
  }
}
