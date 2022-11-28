import 'dart:core';
import 'dart:io';
import 'dart:math';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tutor_app/screens/profile/attendus_List.dart';
import 'package:tutor_app/services/firbaseservice.dart';
import 'package:intl/intl.dart';

import '../../Provider/user_provider.dart';

class Profile extends StatefulWidget {
  int? index;
  Profile({Key? key, required this.index}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ScrollController _controller =  ScrollController(keepScrollOffset: true,initialScrollOffset: 0);
  FirebaseServices services = FirebaseServices();

  bool tick = false;
  XFile? _image;
  String? imageUrl;
  Future getImage(ImageSource source) async {
    var image = await picker.pickImage(source: source);
    setState(() {
      _uploadImageToFirebase(File(image!.path));
      setState(() {
        _image = image ;
        print('Image Path $_image');
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    var data = userProvider.studentData;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.5.h),
          child: Column(
            children: [
              SizedBox(
                height: 5.h,
              ),
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
                    return Container(
                      height: 15.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color(0xffE1E9FC),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 1.5.h,
                          ),
                      Stack(
                        children: [
                          CachedNetworkImage(
                            imageBuilder: (context,imageProvider)=>CircleAvatar(
                              radius: 5.h,
                              backgroundImage: imageProvider,
                            ),
                            cacheManager: CacheManager(Config(
                                'customCacheKey',
                                stalePeriod: const Duration(days: 500)

                            )),
                            imageUrl: snapshot.data!['url'],

                          ),
                          Positioned(
                            bottom:-14,
                            right:-12,

                            child: IconButton(icon:  Icon(Icons.add_a_photo_rounded,color: Colors.white.withOpacity(0.85),),onPressed: (){
                              bottomSheet();
                            },),
                          ),

                        ],
                      ),
                          SizedBox(
                            width: 3.h,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 4.h,
                              ),
                              Text(
                                "${snapshot.data!['name']} ${snapshot.data!['secondName']}",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 17.sp, color: Colors.black),
                                ),
                              ),
                              Text(
                                snapshot.data!['type'],
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 13.sp, color: Colors.black),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
              SizedBox(
                height: 2.h,
              ),
              Row(
                children: [
                  Text(
                    'Attendance',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h,),
             Container(
               height: 26.h,
               child: widget.index==0? FutureBuilder<DocumentSnapshot>(
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
                       controller: _controller,
                         shrinkWrap:true,
                         scrollDirection: Axis.vertical,
                         itemCount: snapshot.data!['attendees'].length >=3 ? 3:snapshot.data!['attendees'].length  ,
                         itemBuilder: (BuildContext context ,int index){


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
                                   height: 6.h,
                                   width: 6.h,
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
                                     RichText(
                                       text: TextSpan(
                                           text: "Joined Session At ",
                                           style: GoogleFonts.poppins(
                                             textStyle: TextStyle(
                                                 fontWeight: FontWeight.w300,
                                                 fontSize: 12.sp,
                                                 color: Colors.grey[600]),
                                           ),
                                           children: [
                                             TextSpan(
                                               text: formattedTime1,
                                               style: GoogleFonts.poppins(
                                                 textStyle: TextStyle(
                                                     fontWeight: FontWeight.w600,
                                                     fontSize: 12.sp,
                                                     color: Colors.grey[600]),
                                               ),
                                             )
                                           ]),
                                     )
                                   ],
                                 )
                               ],
                             ),
                           );
                         }
                     );
                   })
                   :FutureBuilder<DocumentSnapshot>(
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
                         controller: _controller,
                         shrinkWrap:true,
                         scrollDirection: Axis.vertical,
                         itemCount: snapshot.data!['attendees'].length >=3 ? 3:snapshot.data!['attendees'].length  ,
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
                                   height: 6.h,
                                   width: 6.h,
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
                                     RichText(
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
                                               text: formattedTime1,
                                               style: GoogleFonts.poppins(
                                                 textStyle: TextStyle(
                                                     fontWeight: FontWeight.w600,
                                                     fontSize: 12.sp,
                                                     color: Colors.grey[600]),
                                               ),
                                             )
                                           ]),
                                     )
                                   ],
                                 )
                               ],
                             ),
                           );
                         }
                     );
                   })

               // FutureBuilder<DocumentSnapshot>(
               //     future: services.getUserData(),
               //     builder: (BuildContext context,
               //         AsyncSnapshot<DocumentSnapshot> snapshot) {
               //       if (snapshot.data == null) {
               //         return Container();
               //       }
               //       if (snapshot.connectionState ==
               //           ConnectionState.waiting) {
               //         return const Center(
               //             child: CircularProgressIndicator(
               //               valueColor: AlwaysStoppedAnimation(
               //                   Colors.white),
               //             ));
               //       }
               //       return ListView.builder(
               //           shrinkWrap: true,
               //           itemCount: snapshot.data!['students'].length,
               //           itemBuilder: (BuildContext ctxt, int indexx){
               //             return FutureBuilder<QuerySnapshot>(
               //                 future: services.users
               //                     .where('uid',
               //                     isEqualTo: snapshot.data!['students'][indexx])
               //                     .get(),
               //                 builder: (BuildContext context,
               //                     AsyncSnapshot<QuerySnapshot> snapshot) {
               //                   if (snapshot.hasError) {
               //                     return const Text('Some things wrong');
               //                   }
               //                   if (snapshot.connectionState ==
               //                       ConnectionState.waiting) {
               //                     return const Center(
               //                         child: CircularProgressIndicator(color: Colors.white,));
               //                   }
               //                   return ListView.builder(
               //                       shrinkWrap: true,
               //                       physics: const ScrollPhysics(),
               //                       itemCount: snapshot.data!.size,
               //                       itemBuilder:
               //                           (BuildContext context, int index) {
               //                         var data = snapshot.data!.docs[index];
               //                         var dateList = data['attendees'].last;
               //                         var day = DateTime.fromMicrosecondsSinceEpoch(
               //                             dateList.microsecondsSinceEpoch);
               //                         String formattedTime1 = DateFormat.jm().format(DateTime.fromMicrosecondsSinceEpoch(
               //                             dateList!.microsecondsSinceEpoch));
               //                         var header = DateFormat('MMMM, yyyy').format(DateTime.fromMicrosecondsSinceEpoch(
               //                             dateList.microsecondsSinceEpoch));
               //
               //                         return Padding(
               //                           padding: const EdgeInsets.symmetric(vertical: 8),
               //                           child: Row(
               //                             children: [
               //                               Container(
               //                                 height: 6.h,
               //                                 width: 6.h,
               //                                 decoration: BoxDecoration(
               //                                   borderRadius: BorderRadius.circular(10),
               //                                   color:indexx == 0? const Color(0xff3C67FF):indexx == 1? const Color(0xffD66BAB).withOpacity(0.7): const Color(0xff7FD77D).withOpacity(0.7),
               //                                 ),
               //                                 child: Row(
               //                                   children: [
               //                                     SizedBox(
               //                                       width: 3.w,
               //                                     ),
               //                                     Text(
               //                                       day.day.toString(),
               //                                       style: GoogleFonts.poppins(
               //                                         textStyle: TextStyle(
               //                                             fontWeight: FontWeight.w800,
               //                                             fontSize: 17.sp,
               //                                             color: Colors.white),
               //                                       ),
               //                                     ),
               //                                     const Padding(
               //                                       padding: EdgeInsets.only(bottom: 10),
               //                                       child: Text(
               //                                         'th',
               //                                         style: TextStyle(
               //                                             fontSize: 10,
               //                                             color: Colors.white,
               //                                             fontWeight: FontWeight.bold),
               //                                       ),
               //                                     )
               //                                   ],
               //                                 ),
               //                               ),
               //                               SizedBox(
               //                                 width: 3.h,
               //                               ),
               //                               Column(
               //                                 crossAxisAlignment: CrossAxisAlignment.start,
               //                                 children: [
               //                                   Text(
               //                                     header,
               //                                     style: GoogleFonts.poppins(
               //                                       textStyle: TextStyle(
               //                                           fontWeight: FontWeight.w800,
               //                                           fontSize: 15.sp,
               //                                           color: const Color(0xff343674)),
               //                                     ),
               //                                   ),
               //                                   RichText(
               //                                     overflow: TextOverflow.ellipsis,
               //                                     text: TextSpan(
               //                                         text: widget.index == 0
               //                                             ? "Joined Session At "
               //                                             : "Joined ${data['name']} Session At ",
               //
               //                                         style: GoogleFonts.poppins(
               //                                           textStyle: TextStyle(
               //                                               fontWeight: FontWeight.w300,
               //                                               fontSize: 12.sp,
               //                                               color: Colors.grey[600]),
               //                                         ),
               //                                         children: [
               //                                           TextSpan(
               //                                             text: formattedTime1,
               //                                             style: GoogleFonts.poppins(
               //                                               textStyle: TextStyle(
               //                                                   fontWeight: FontWeight.w600,
               //                                                   fontSize: 12.sp,
               //                                                   color: Colors.grey[600]),
               //                                             ),
               //                                           )
               //                                         ]),
               //                                   )
               //                                 ],
               //                               )
               //                             ],
               //                           ),
               //                         );
               //                       });
               //                 });
               //           }
               //       );
               //     }),
             ),
              SizedBox(height: 2.h,),
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
                        return     InkWell(
                          onTap: (){
                            userProvider.getStudentDetails(snapshot.data);
                            Navigator.push(context, MaterialPageRoute(builder: (_)=>  SeeAttendees(index: widget.index!,)));
                          },
                          child: Text('See more',  style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 14.sp, color: Color(0xff343674),fontWeight: FontWeight.w600,),
                          ),),
                        );
                      }),

                ],
              ),
              SizedBox(height: 3.h,),
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
                    List<dynamic> attendees = snapshot.data!['attendees'];
                    return  Container(
                      height: 12.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: const Color(0xff3B6EE9),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 2.h,
                            ),
                            Row(
                              children: [
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        tick == true;
                                      });
                                    },
                                    child: tick == true
                                        ? Image.asset(
                                      'assets/icons/tick.png',
                                      height: 3.5.h,
                                    )
                                        : Image.asset(
                                      'assets/icons/tick.png',
                                      height: 3.5.h,
                                    )),
                                SizedBox(
                                  width: 2.h,
                                ),
                                Text(
                                  'Class Completed',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 15.sp, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5.5.h),
                              child: Row(
                                children: [
                                  Text(
                                    snapshot.data!['completeClasses'].toString(),
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22.sp,
                                          color: Colors.white),
                                    ),
                                  ),
                                  Text(
                                    ' / ',
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 22.sp,
                                          color: Color(0xffbdbdbd)),
                                    ),
                                  ),
                                  Text(
                                    snapshot.data!['totalClasses'],
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22.sp,
                                          color: const Color(0xffbdbdbd)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ],

          )),
    );
  }
  Future bottomSheet(){
    return showAdaptiveActionSheet(
      context: context,
      actions: <BottomSheetAction>[
        BottomSheetAction(
          title: const Text('Camera'),
          onPressed:  (BuildContext context)  {
            setState(() {
              getImage(ImageSource.camera).whenComplete((){
              }
              );
            });
            Navigator.pop(context);
          },
        ),
        BottomSheetAction(
          title: const Text('Gallery'), onPressed: (BuildContext context)    {
          setState(() {
            getImage(ImageSource.gallery);
          });
          Navigator.pop(context);
        },

        ),
      ],
      cancelAction: CancelAction(title: const Text('Cancel')),
    );
  }

  final picker = ImagePicker();


  Future<void> _uploadImageToFirebase(File image) async {
    try {
      // Make random image name.
      int randomNumber = Random().nextInt(100000);
      String imageLocation = 'images/image$randomNumber.jpg';

      // Upload image to firebase.
      final Reference storageReference =
      FirebaseStorage.instance.ref().child(imageLocation);
      final UploadTask uploadTask = storageReference.putFile(image);
      await uploadTask;
      setState(() {
        _addPathToDatabase(imageLocation);
      });
    } catch (e) {

    }
  }


  Future<void> _addPathToDatabase(String text) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(text);
      var imageString = await ref.getDownloadURL();

      setState(() {
        imageUrl = imageString;
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(services.user!.uid)
          .update({
        'url': imageString,
      });
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text('ok'),
            );
          });
    }
  }
}
//               FutureBuilder<DocumentSnapshot>(
//                   future: services.getUserData(),
//                   builder: (BuildContext context,
//                       AsyncSnapshot<DocumentSnapshot> snapshot) {
//                     if (snapshot.data == null) {
//                       return Container();
//                     }
//
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(
//                           child: CircularProgressIndicator(
//                         valueColor: AlwaysStoppedAnimation(Colors.white),
//                       ));
//                     }
//
//
//                     Timestamp? day1 = snapshot.data!['attendees'][0];
//                     // Timestamp? day2 = snapshot.data!['attendees'][1];
//                     // Timestamp? day3 = snapshot.data!['attendees'][2];
//                     /// time

//                     // String formattedTime2 = DateFormat.jm().format(DateTime.fromMicrosecondsSinceEpoch(
//                     //     day2!.microsecondsSinceEpoch));
//                     // String formattedTime3 = DateFormat.jm().format(DateTime.fromMicrosecondsSinceEpoch(
//                     //     day3!.microsecondsSinceEpoch));
//                     /// day //////////
//
//

//                     // var snd = DateTime.fromMicrosecondsSinceEpoch(
//                     //     day2.microsecondsSinceEpoch);
//                     // var trd = DateTime.fromMicrosecondsSinceEpoch(
//                     //     day3.microsecondsSinceEpoch);
//
// /// date //////////
//

//                     // var second = DateFormat('MMMM, yyyy').format(DateTime.fromMicrosecondsSinceEpoch(
//                     //     day2.microsecondsSinceEpoch));
//                     // var third = DateFormat('MMMM, yyyy').format(DateTime.fromMicrosecondsSinceEpoch(
//                     //     trd.microsecondsSinceEpoch));
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [

//

//

//                         SizedBox(
//                           height: 1.h,
//                         ),
//                         Row(
//                           children: [
//                             Container(
//                               height: 6.h,
//                               width: 6.h,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 color:
//                               ),
//                               child: Row(
//                                 children: [
//                                   SizedBox(
//                                     width: 3.w,
//                                   ),
//                                   if(snapshot.hasData)  Text(
//                                     'snd.day.toString(),',
//                                     style: GoogleFonts.poppins(
//                                       textStyle: TextStyle(
//                                           fontWeight: FontWeight.w800,
//                                           fontSize: 17.sp,
//                                           color: Colors.white),
//                                     ),
//                                   ),
//                                   const Padding(
//                                     padding: EdgeInsets.only(bottom: 10),
//                                     child: Text(
//                                       'th',
//                                       style: TextStyle(
//                                           fontSize: 10,
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                             SizedBox(
//                               width: 3.h,
//                             ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'second',
//                                   style: GoogleFonts.poppins(
//                                     textStyle: TextStyle(
//                                         fontWeight: FontWeight.w800,
//                                         fontSize: 15.sp,
//                                         color: const Color(0xff343674)),
//                                   ),
//                                 ),
//                                 RichText(
//                                   text: TextSpan(
//                                       text: widget.index == 0
//                                           ? "Joined Session At "
//                                           : "Joined Ali's Session At ",
//                                       style: GoogleFonts.poppins(
//                                         textStyle: TextStyle(
//                                             fontWeight: FontWeight.w300,
//                                             fontSize: 12.sp,
//                                             color: Colors.grey[600]),
//                                       ),
//                                       children: [
//                                         TextSpan(
//                                           text: 'formattedTime2',
//                                           style: GoogleFonts.poppins(
//                                             textStyle: TextStyle(
//                                                 fontWeight: FontWeight.w600,
//                                                 fontSize: 12.sp,
//                                                 color: Colors.grey[600]),
//                                           ),
//                                         )
//                                       ]),
//                                 )
//                               ],
//                             )
//                           ],
//                         ),
//                         SizedBox(
//                           height: 1.h,
//                         ),
//                          Row(
//                           children: [
//                             Container(
//                               height: 6.h,
//                               width: 6.h,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 color:
//                               ),
//                               child: Row(
//                                 children: [
//                                   SizedBox(
//                                     width: 3.w,
//                                   ),
//                                   Text(
//                                    'trd.day.toString()',
//                                     style: GoogleFonts.poppins(
//                                       textStyle: TextStyle(
//                                           fontWeight: FontWeight.w800,
//                                           fontSize: 17.sp,
//                                           color: Colors.white),
//                                     ),
//                                   ),
//                                   const Padding(
//                                     padding: EdgeInsets.only(bottom: 10),
//                                     child: Text(
//                                       'th',
//                                       style: TextStyle(
//                                           fontSize: 10,
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                             SizedBox(
//                               width: 3.h,
//                             ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                 '  third',
//                                   style: GoogleFonts.poppins(
//                                     textStyle: TextStyle(
//                                         fontWeight: FontWeight.w800,
//                                         fontSize: 15.sp,
//                                         color: const Color(0xff343674)),
//                                   ),
//                                 ),
//                                 RichText(
//                                   text: TextSpan(
//                                       text: widget.index == 0
//                                           ? "Joined Session At "
//                                           : "Joined Ali's Session At ",
//                                       style: GoogleFonts.poppins(
//                                         textStyle: TextStyle(
//                                             fontWeight: FontWeight.w300,
//                                             fontSize: 12.sp,
//                                             color: Colors.grey[600]),
//                                       ),
//                                       children: [
//                                         TextSpan(
//                                           text: 'formattedTime3',
//                                           style: GoogleFonts.poppins(
//                                             textStyle: TextStyle(
//                                                 fontWeight: FontWeight.w600,
//                                                 fontSize: 12.sp,
//                                                 color: Colors.grey[600]),
//                                           ),
//                                         )
//                                       ]),
//                                 )
//                               ],
//                             )
//                           ],
//                         ),
//                         SizedBox(
//                           height: 2.h,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Text(
//                                 'See more',
//                                 style: GoogleFonts.poppins(
//                                   textStyle: TextStyle(
//                                       fontSize: 14.sp,
//                                       fontWeight: FontWeight.w600,
//                                       color: const Color(0xff343674)),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(
//                           height: 4.h,
//                         ),

//                       ],
//                     );
//                   }),
