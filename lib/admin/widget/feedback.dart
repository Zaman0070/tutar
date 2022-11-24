import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tutor_app/Provider/user_provider.dart';
import 'package:tutor_app/services/firbaseservice.dart';

class TakeFeedback extends StatefulWidget {
  const TakeFeedback({Key? key}) : super(key: key);

  @override
  State<TakeFeedback> createState() => _TakeFeedbackState();
}

class _TakeFeedbackState extends State<TakeFeedback> {
  FirebaseServices services = FirebaseServices();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;


  bool isLoading = false;
  List<String>? feedback  =[];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    feedbacks();

  }

  Future feedbacks() async {
    await services.feedback.where('feedback',isEqualTo: 'done')
        .get()
        .then((chatMap) {
      for (var element in chatMap.docs) {
        feedback!.add(element.id);
      }
      print(feedback);
      isLoading = false;
      setState(() {});
    });
  }
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
            title: Text('Feedback',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                )),
            bottom: TabBar(
              labelStyle: GoogleFonts.poppins(
                textStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16.sp,
                    color: Colors.black),
              ),
              labelColor: Colors.black,
              indicatorColor: Theme.of(context).splashColor,
              tabs: const [
                Tab(text: 'Take Feedback'),
                Tab(text: 'View Feedback')
              ],
            ),
          ),
          body: TabBarView(
            children: [
              FutureBuilder<QuerySnapshot>(
                  future:
                      services.users.where('type', isEqualTo: 'student').get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
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
                          return InkWell(
                            onTap: () {
                              // userProvider.getStudentDetails(data);
                              // Navigator.push(context, MaterialPageRoute(builder: (_)=>const AttendeesList()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 15),
                              child: Container(
                                height: 7.h,
                                width: 100.w,
                                decoration: BoxDecoration(
                                    // boxShadow:  const [
                                    //   BoxShadow(color:Colors.black12,spreadRadius: 0,offset: Offset(0, 3),blurRadius: 1)
                                    // ],
                                    color: const Color(0xffE1E9FC),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${data['name']} ${data['secondName']}",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13.sp,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          services.feedback
                                              .doc(data['uid'])
                                              .set({
                                            'feedback': 'demand',
                                            'text': '',
                                            'rating': 0,
                                            'name':data['name'],
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'You are successfully send request of feedback'),
                                            ),
                                          );
                                          setState(() {

                                          });
                                        },
                                        child: Container(
                                          height: 4.5.h,
                                          width: 28.w,
                                          decoration: BoxDecoration(
                                              color: const Color(0xff3B6EE9),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Center(
                                              child: Text(
                                            'Take FeedBack',
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 9.sp,
                                                  color: Colors.white),
                                            ),
                                          )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  }),
              FutureBuilder<QuerySnapshot>(
                  future:
                      services.users.where('type', isEqualTo: 'student').get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
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
                          return feedback!.contains(data.id)? InkWell(
                            onTap: () {
                              // userProvider.getStudentDetails(data);
                              // Navigator.push(context, MaterialPageRoute(builder: (_)=>const AttendeesList()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 15),
                              child: Container(
                                height: 7.h,
                                width: 100.w,
                                decoration: BoxDecoration(
                                    // boxShadow:  const [
                                    //   BoxShadow(color:Colors.black12,spreadRadius: 0,offset: Offset(0, 3),blurRadius: 1)
                                    // ],
                                    color: const Color(0xffE1E9FC),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${data['name']} ${data['secondName']}",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13.sp,
                                          ),
                                        ),
                                      ),
                                      FutureBuilder<DocumentSnapshot>(
                                          future: services.feedback.doc(data['uid'])
                                              .get(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<DocumentSnapshot>
                                                  snapshot) {
                                            if (snapshot.hasError) {
                                              return const Text(
                                                  'Some things wrong');
                                            }
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }
                                           // double rating = double.parse(snapshot.data!['rating']);
                                            return   InkWell(
                                              onTap: () {
                                                showDialog(
                                                    useSafeArea: true,
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                          actionsAlignment: MainAxisAlignment.start,
                                                          title: Text(
                                                              textAlign: TextAlign.center,
                                                              '${snapshot.data!['name']}feedback',
                                                              style: GoogleFonts.poppins(
                                                                textStyle: TextStyle(
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 13.sp,
                                                                    color: Colors.black),
                                                              )),
                                                          content:  Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              RatingBar.builder(
                                                                initialRating: snapshot.data!['rating'].toDouble(),
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

                                                                },
                                                              ),
                                                              SizedBox(height: 1.h,),
                                                              Text('feedback',   style: GoogleFonts.poppins(
                                                                textStyle: TextStyle(
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 13.sp,
                                                                    color: Colors.black),
                                                              )),
                                                            ],
                                                          ),
                                                          actions: [

                                                            Center(child: Text(snapshot.data!['text'],textAlign: TextAlign.center,softWrap: true,))
                                                          ],
                                                        ),

                                                );
                                              },
                                              child: Container(
                                                height: 4.5.h,
                                                width: 28.w,
                                                decoration: BoxDecoration(
                                                    color: const Color(0xff3B6EE9),
                                                    borderRadius:
                                                    BorderRadius.circular(10)),
                                                child: Center(
                                                    child: Text(
                                                      'View FeedBack',
                                                      style: GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 9.sp,
                                                            color: Colors.white),
                                                      ),
                                                    )),
                                              ),
                                            );
                                          }),

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ):Container();
                        });
                  }),
            ],
          )),
    );
  }
}
