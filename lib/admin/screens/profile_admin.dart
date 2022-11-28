import 'dart:io';
import 'dart:math';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:tutor_app/admin/add/add_faculty.dart';
import 'package:tutor_app/admin/add/add_student.dart';
import 'package:tutor_app/admin/widget/announcment.dart';
import 'package:tutor_app/admin/widget/assign.dart';
import 'package:tutor_app/admin/widget/attendees.dart';
import 'package:tutor_app/admin/widget/banner.dart';
import 'package:tutor_app/admin/widget/feedback.dart';
import 'package:tutor_app/admin/widget/notification.dart';
import 'package:tutor_app/services/firbaseservice.dart';

import '../../screens/splash_screen/on_board_screen.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({Key? key}) : super(key: key);

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  String url = '';
  String name = '';
  String type = '';

  Future getAdminData() async {
    await _firestore
        .collection('users').where('type',isEqualTo: 'admin')
        .get()
        .then((chatMap) {
      for (var element in chatMap.docs) {
        url = element['url']  ;
        name = element['name'];
        type = element['type'];
      }
      isLoading = false;
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAdminData();

  }

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
  FirebaseServices services = FirebaseServices();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.5.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.h,
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
                                "${snapshot.data!['name']} ",
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
          // Container(
          //   height: 15.h,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(30),
          //     color: Color(0xffE1E9FC),
          //   ),
          //   child: Row(
          //     children: [
          //       SizedBox(
          //         width: 1.5.h,
          //       ),
          //       CachedNetworkImage(
          //         imageBuilder: (context,imageProvider)=>CircleAvatar(
          //           radius: 30,
          //           backgroundImage: imageProvider,
          //         ),
          //         cacheManager: CacheManager(Config(
          //             'customCacheKey',
          //             stalePeriod: const Duration(days: 500)
          //
          //         )),
          //         imageUrl: url,
          //
          //       ),
          //       SizedBox(
          //         width: 3.h,
          //       ),
          //       Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           SizedBox(
          //             height: 4.h,
          //           ),
          //           Text(
          //             name,
          //             style: GoogleFonts.poppins(
          //               textStyle:
          //               TextStyle(fontSize: 17.sp, color: Colors.black),
          //             ),
          //           ),
          //           Text(
          //             type,
          //             style: GoogleFonts.poppins(
          //               textStyle:
          //               TextStyle(fontSize: 13.sp, color: Colors.black),
          //             ),
          //           )
          //         ],
          //       ),
          //     ],
          //   ),
          // ),

              SizedBox(
                height: 2.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>const AddStudent()));
                    },
                    child: Container(
                      height: 18.h,
                      width: 28.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xffE1E9FC),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 3.h,),
                          Image.asset('assets/icons/user.png',height: 8.h,),
                          SizedBox(height: 1.h,),
                          Text('Add Student', style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>const AddFaculty()));
                    },
                    child: Container(
                      height: 18.h,
                      width: 28.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xffE1E9FC),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 3.h,),
                          Image.asset('assets/icons/teacher.png',height: 8.h,),
                          SizedBox(height: 1.h,),
                          Text('Add Faculty', style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=>const Announcement())),
                    child: Container(
                      height: 18.h,
                      width: 28.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xffE1E9FC),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 3.h,),
                          Image.asset('assets/icons/ann.png',height: 8.h,),
                          SizedBox(height: 1.h,),
                          Text('Announcements', style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>const Assign()));
                    },
                    child: Container(
                      height: 18.h,
                      width: 28.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xffE1E9FC),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 3.h,),
                          Image.asset('assets/icons/ass.png',height: 8.h,),
                          SizedBox(height: 1.h,),
                          Text('Assign', style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>const Notifications()));
                    },
                    child: Container(
                      height: 18.h,
                      width: 28.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xffE1E9FC),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 3.h,),
                          Image.asset('assets/icons/bel.png',height: 7.h,),
                          SizedBox(height: 1.h,),
                          Text('Notification', style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>const Attendees()));
                    },
                    child: Container(
                      height: 18.h,
                      width: 28.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xffE1E9FC),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 3.h,),
                          Image.asset('assets/icons/calendar.png',height: 8.h,),
                          SizedBox(height: 1.h,),
                          Text('Attendance', style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>const Banners()));
                    },
                    child: Container(
                      height: 18.h,
                      width: 28.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xffE1E9FC),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 3.h,),
                          Image.asset('assets/icons/ads.png',height: 8.h,),
                          SizedBox(height: 1.h,),
                          Text('Banner', style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>const TakeFeedback()));
                    },
                    child: Container(
                      height: 18.h,
                      width: 28.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xffE1E9FC),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 3.h,),
                          Image.asset('assets/icons/feedback.png',height: 7.h,),
                          SizedBox(height: 1.h,),
                          Text('Take Feedback', style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 18.h,
                    width: 28.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child:  ListTile(
                      onTap: () {
                        setState(() {
                          FirebaseAuth.instance.signOut();
                        });
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const OnBoardScreen()));
                      },
                      title: Text('Logout',style: TextStyle(color: Colors.grey[200]),),
                    ),
                  ),
                ],
              ),


            ],
          ),
        ),
      ),
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
