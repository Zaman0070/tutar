import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tutor_app/screens/home/dwarer.dart';
import 'package:tutor_app/services/firbaseservice.dart';
import 'package:tutor_app/widget/calendar_screen.dart';
import 'package:tutor_app/widget/noti.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Provider/user_provider.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  int? index;
  Home({Key? key, required this.index}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var textController = TextEditingController();

  bool isLoading = false;
  var link  ='';
  var names  ='';
  var demand = '';
  var Uidadmin = '';
  var secondName = '';
  var fId = '';
  var title = '';
  var message = '';
  DateTime? selectedDate;

  @override
  void initState() {
    setState(() {
      selectedDate = DateTime.now();
    });
    super.initState();
    getUser();
    feedBack();
    adminUid();


  }

  Future getNotification() async {
    await _firestore
        .collection('notifications').where('uid',isEqualTo: services.user!.uid)
        .get()
        .then((value) {
      for (var element in value.docs) {
       title = element['title'];
       message = element['message'];
      }
    });

  }

  Future getUser() async {
    await _firestore
        .collection('users').doc(services.user!.uid)
        .get()
        .then((value) {
          setState(() {
            link = value['link'];
            names = value['name'];
            secondName = value['secondName'];
            fId = value['fId'];

          });
setState(() {});
    });

  }
  Future feedBack() async {
    await _firestore
        .collection('feedback').doc(services.user!.uid)
        .get()
        .then((chatMap) {

        demand= chatMap['feedback']  ;
      print(demand);
      isLoading = false;
      setState(() {});
    });
  }

  Future adminUid() async {
    await _firestore
        .collection('users').where('type',isEqualTo: 'admin')
        .get()
        .then((chatMap) {
      for (var element in chatMap.docs) {
        Uidadmin = element['uid'];
      }
    });
  }


  void showAlert(BuildContext context) {
if(demand == 'demand') {
  widget.index==0?showDialog(
   useSafeArea: true,
      context: context,
      builder: (context) =>
          FutureBuilder<DocumentSnapshot>(
              future: services.feedback.doc(services.user!.uid).get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.data == null) {
                  return Container();
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                        AlwaysStoppedAnimation(Colors.white),
                      ));
                }
                return AlertDialog(
                  title: Column(
                    children: [
                      Image.asset('assets/logo/a.png',height: 15.h,),
                      Text(
                          textAlign: TextAlign.center,
                          'Your feedback & Suggestions are important to us! 😃',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                                color: Colors.black),
                          )),
                    ],
                  ),
                  content: ListView(shrinkWrap: true,
                    children: [
                      RatingBar.builder(
                        initialRating: 0.5,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                        itemBuilder: (context, _) =>
                        const Icon(
                          Icons.star,
                          color: Color(0xffFDB640),
                        ),
                        onRatingUpdate: (rating) {
                          snapshot.data!.reference.update({
                            'rating':rating,
                          });
                        },
                      ),
                      SizedBox(height: 2.h,),
                      Text('Tell us what can be improved?',  style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                            color: Colors.black),
                      )),
                      SizedBox(height: 2.h,),
                      Container(
                        height: 22.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.grey.shade500)
                        ),
                        child: TextFormField(
                          style: TextStyle(fontSize: 20),
                          autofocus: false,
                          keyboardType: TextInputType.text,
                          maxLength: 200,
                          minLines: 9,
                          maxLines: 10,
                          controller: textController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                            // hintText: 'description',
                            hintStyle: TextStyle(color: Colors.black),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h,),
                  InkWell(
                    onTap: (){
                      snapshot.data!.reference.update({
                        'feedback':'done',
                        'text':textController.text,
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 5.5.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                          color: const Color(0xff3B6EE9),
                          borderRadius: BorderRadius.circular(6)),
                      child: Center(
                          child: Text(
                            'Submit',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13.sp,
                                  color: Colors.white),
                            ),
                          )),
                    ),
                  ),
                    ],
                  ),
                );
              }
                )

                ):Container();

}
  }



  final keyIsFirstLoaded = 'Is_First_Loaded';
  @override
  var day =  DateFormat('dd').format(DateTime.now());
  Widget? brandList({list,}){
      showMaterialModalBottomSheet(
        backgroundColor: Colors.white,
        shape:RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 1.h,),
              Container(
                height: 5,
                width: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              ),
              SizedBox(height: 3.h,),
              Image.asset('assets/logo/b.png',height: 12.h,),
              SizedBox(height: 2.h,),
              Padding(
                padding: const EdgeInsets.only(left: 15.0,right: 8),
                child: Text('Cloud Attendance',textAlign: TextAlign.center,  style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17.sp,
                      color: Colors.black),
                ),),
              ),
              SizedBox(height: 1.h,),
               Padding(
                padding: const EdgeInsets.only(left: 15.0,right: 8),
                child: Text(widget.index==0?'Please mark your attendance on time. The instructor would be 𝗮𝘂𝘁𝗼𝗺𝗮𝘁𝗶𝗰𝗮𝗹𝗹𝘆 𝗻𝗼𝘁𝗶𝗳𝗶𝗲𝗱 once the student entered the room.':"Please mark your attendance on time. The student would be 𝗮𝘂𝘁𝗼𝗺𝗮𝘁𝗶𝗰𝗮𝗹𝗹𝘆 𝗻𝗼𝘁𝗶𝗳𝗶𝗲𝗱 once the instructor entered the room.",textAlign: TextAlign.center,  style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 10.sp,
                      color: Colors.grey[600]),
                ),),
              ),
              ListView.builder(
                shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: ListTile(
                        onTap: () {
                          setState(() {
                          });
                          Navigator.pop(context);
                        },
                        title:list[index],

                      ),
                    );
                  }),
              SizedBox(height: 4.h,),
            ],
          );
        }
    );
  }
  final _advancedDrawerController = AdvancedDrawerController();
  FirebaseServices services = FirebaseServices();
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () => showAlert(context));
    DateTime dateToday = DateTime.now();
    String date = dateToday.toString().substring(0,10);

    List<Widget> join(BuildContext context,googleMeeting,name,id) => [
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
                    valueColor:
                    AlwaysStoppedAnimation(Colors.white),
                  ));
            }
            List<dynamic> dateList = snapshot.data!['date'];
            List<dynamic> attendees = snapshot.data!['attendees'];
            return dateList.contains("$date$name") ? InkWell(
              onTap: (){
                DateTime dateToday = DateTime.now();
                String date = dateToday.toString().substring(0,10);
                snapshot.data!.reference.update({
                  'attendees':FieldValue.arrayRemove([attendees.last]),
                  'date':FieldValue.arrayRemove(['$date$name'],),
                  'completeClasses' : snapshot.data!['completeClasses'] - 1,
                });
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Container(
                  height: 5.5.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                      color:  Colors.greenAccent.shade400,
                      borderRadius: BorderRadius.circular(6)),
                  child: const Center(
                      child: Icon(Icons.check_circle_outline,color: Colors.white,size: 30,)
                  ),
                ),
              ),
            ):InkWell(
              onTap: ()async{


                DateTime dateToday = DateTime.now();
                String date = dateToday.toString().substring(0,10);
                snapshot.data!.reference.update({

                  'attendees':FieldValue.arrayUnion([DateTime.now()]),
                  'date':FieldValue.arrayUnion(['$date$name'],),
                  'completeClasses' : snapshot.data!['completeClasses'] +1,
                });


                /// for notification
             _firestore.collection('attendees').doc().set(
                    {
                      'attendees': DateFormat('hh:mm')
                        .format(DateTime.fromMicrosecondsSinceEpoch(DateTime.now().microsecondsSinceEpoch)),
                      'adminId': Uidadmin,
                      'fId':fId,
                      'name':'$names $secondName'
                    });


                Navigator.pop(context);
              },
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Container(
                    height: 5.5.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                        color: const Color(0xffFD7F23),
                        borderRadius: BorderRadius.circular(6)),
                    child: Center(
                      child: Text(
                    'Mark Attendees',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13.sp,
                          color: Colors.white),
                    ),
                  )
              ),
            ),
            ),
            );
          }),

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
                    valueColor:
                    AlwaysStoppedAnimation(Colors.white),
                  ));
            }
            googleMeet() async {
              var url = googleMeeting;
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            }
            List<dynamic> dateList = snapshot.data!['date'];
            return dateList.contains('$date$name') ? InkWell(
              onTap: (){
              widget.index==1?  _firestore.collection('join').doc().set(
                    {
                      'attendees': DateFormat('hh:mm')
                          .format(DateTime.fromMicrosecondsSinceEpoch(DateTime.now().microsecondsSinceEpoch)),
                      'id': id,
                      'name':'$names $secondName'
                    }): null

                ;
                googleMeet();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Container(
                  height: 5.5.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                      color: const Color(0xff3B6EE9),
                      borderRadius: BorderRadius.circular(6)),
                  child: Center(
                      child: Text(
                        'Join Class',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13.sp,
                              color: Colors.white),
                        ),
                      )),
                ),
              ),
            ): Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                height: 5.5.h,
                width: 100.w,
                decoration: BoxDecoration(
                    color:  Colors.grey,
                    borderRadius: BorderRadius.circular(6)),
                child: Center(
                    child: Text(
                      'Join Class',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13.sp,
                            color: Colors.white),
                      ),
                    )),
              ),
            );
          }),


    ];
  
    return AdvancedDrawer(
      backdropColor: const Color(0xff3B6EE9),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      drawer: HomeDrawe(
        index: widget.index,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor:Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          iconTheme: const IconThemeData(color: Colors.black),
          leading: IconButton(
            onPressed: _handleMenuButtonPressed,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  key: ValueKey<bool>(value.visible),
                  child: value.visible
                      ? const Icon(Icons.clear)
                      : Image.asset('assets/icons/menu.png'),
                );
              },
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: FutureBuilder<DocumentSnapshot>(
                  future: services.getUserData(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.data == null) {
                      return Container();
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                            valueColor:
                            AlwaysStoppedAnimation(Colors.white),
                          ));
                    }
                    return CachedNetworkImage(
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
            )
          ],
        ),
        body: SafeArea(
          child: ListView(
            children: [
              SizedBox(
                height: 2.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26.0),
                child: FutureBuilder<DocumentSnapshot>(
                    future: services.getUserData(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.data == null) {
                        return Container();
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                              valueColor:
                              AlwaysStoppedAnimation(Colors.white),
                            ));
                      }
                      return  RichText(
                        text: TextSpan(
                            text: 'Welcome,',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22.sp,
                                  color: Colors.black),
                            ),
                            children: [
                              TextSpan(
                                text: ' ${snapshot.data!['name']}! 👋',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 22.sp,
                                      color: Colors.black),
                                ),
                              )
                            ]),
                      );
                    }),
              ),
              SizedBox(
                height: 0.h,
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
                            valueColor: AlwaysStoppedAnimation(Colors.blue),
                          ));
                    }
                   // Timestamp? DateStart = snapshot.data!['schedule'][0];
                    List<dynamic> DateEnd = snapshot.data!['schedule'];
                    // var start = DateTime.fromMicrosecondsSinceEpoch(
                    //     DateStart!.microsecondsSinceEpoch);
                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: CalendarScreen(
                        index: widget.index,
                       // rangeStart: start,
                        rangeEnd: DateEnd,
                      ),
                    );
                  }),



              SizedBox(
                height:widget.index==0? 1.h:3.h,
              ),
              widget.index == 1
                  ?  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: FutureBuilder<QuerySnapshot>(
                    future: services.announcement.where('uid',isEqualTo: services.user!.uid).get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.data == null) {
                        return Container();
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ));
                      }
                      return  ListView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: snapshot.data!.size,
                          itemBuilder:
                              (BuildContext context, int index) {
                            var data = snapshot.data!.docs[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0,),
                              child: Container(
                                height: 11.5.h,
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
                                              fontSize: 10.5.sp,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                      );
                    }
              ),
                  )
                  : Container(),
              SizedBox(
                height: widget.index==0? 2.h:2.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 33.0,vertical: 0),
                child: Row(
                  children: [
                    Text(
                      'Available class',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: widget.index==0? 2.h:2.h,
              ),
              widget.index == 0?
              InkWell(
                onTap: (){
                 brandList(list: join(context,link,names,''),);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [
                      Container(
                        height: 5.5.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                            color: const Color(0xff3B6EE9),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Text(
                              'Join Class',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.sp,
                                    color: Colors.white),
                              ),
                            )),
                      ),
                     // SizedBox(height: 2.5.h,),
                    ],
                  ),
                ),
              )
              : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: FutureBuilder<DocumentSnapshot>(
                    future: services.getUserData(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.data == null) {
                        return Container();
                      }
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                                  Colors.white),
                            ));
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                          itemCount: snapshot.data!['students'].length,
                          itemBuilder: (BuildContext ctxt, int index){
                            return FutureBuilder<QuerySnapshot>(
                                future: services.users
                                    .where('uid',
                                    isEqualTo: snapshot.data!['students'][index])
                                    .get(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return const Text('Some things wrong');
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator(color: Colors.white,));
                                  }
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      physics: const ScrollPhysics(),
                                      itemCount: snapshot.data!.size,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        var data = snapshot.data!.docs[index];
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 8),
                                          child: Container(
                                            height: 6.h,
                                            width: 100.w,
                                            decoration: BoxDecoration(
                                              // boxShadow:  const [
                                              //   BoxShadow(color: const Color(0xffE1E9FC) ,spreadRadius: 0.0,offset: Offset(0, 3),blurRadius: 1)
                                              // ],
                                                color: const Color(0xffE1E9FC),
                                                borderRadius: BorderRadius.circular(10)),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    '${data['name']} ${data['secondName']}',
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 13.sp,
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: (){
                                                      brandList(list: join(context,data['link'],data['name'],data['uid']));
                                                    },
                                                    child: Container(
                                                      height: 3.5.h,
                                                      width: 28.w,
                                                      decoration: BoxDecoration(
                                                          color: const Color(0xff3B6EE9),
                                                          borderRadius: BorderRadius.circular(10)),
                                                      child: Center(
                                                          child: Text(
                                                            'Join Class',
                                                            style: GoogleFonts.poppins(
                                                              textStyle: TextStyle(
                                                                  fontWeight: FontWeight.w600,
                                                                  fontSize: 11.sp,
                                                                  color: Colors.white),
                                                            ),
                                                          )),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                });
                          }
                      );
                    }),
              ),
              // SizedBox(
              //   height: 2.5.h,
              // ),
              widget.index == 0
                  ?   Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: FutureBuilder<QuerySnapshot>(
                    future: services.announcement.where('uid',isEqualTo: services.user!.uid).get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.data == null) {
                        return Container();
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ));
                      }
                      return  ListView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: snapshot.data!.size,
                          itemBuilder:
                              (BuildContext context, int index) {
                            var data = snapshot.data!.docs[index];
                            return Padding(
                              padding: const EdgeInsets.only(left: 14.0,top: 20,right: 14),
                              child: Container(
                                height: 11.h,
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
                                              fontSize: 10.5.sp,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                      );
                    }
              ),
                  )
                  : Container(),

              widget.index == 0
                  ?Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: FutureBuilder<QuerySnapshot>(
                    future: services.banner.get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.data == null) {
                        return Container();
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ));
                      }
                      return  ListView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: snapshot.data!.size,
                          itemBuilder:
                              (BuildContext context, int index) {
                            var data = snapshot.data!.docs[index];

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 20),
                              child: Container(
                                height: 10.h,
                                width: 100.w,
                                decoration: BoxDecoration(
                                  color:  Color(0xffF1D5D8),
                                  borderRadius: BorderRadius.circular(10),
                                  // image:DecorationImage(
                                  //     image: NetworkImage(data['url'],),fit: BoxFit.fitWidth
                                  //
                                  // ),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black12,
                                        spreadRadius: 1,
                                        offset: Offset(3, 3),
                                        blurRadius: 10)
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.fitWidth,
                                    cacheManager: CacheManager(Config(
                                        'customCacheKey',
                                      stalePeriod: const Duration(days: 500)

                                    )),
                                    imageUrl: data['url'],

                                  ),
                                ),
                              ),
                            );
                          }
                      );
                    }
              ),
                  )
                  : Container(),

            ],
          ),
        ),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
  bool value = false;

  }
