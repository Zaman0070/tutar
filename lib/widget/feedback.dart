import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:tutor_app/services/firbaseservice.dart';

class Feedbacks extends StatefulWidget {
  const Feedbacks({Key? key}) : super(key: key);

  @override
  State<Feedbacks> createState() => _FeedbacksState();
}

class _FeedbacksState extends State<Feedbacks> {
  var textController = TextEditingController();
  FirebaseServices services =FirebaseServices();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var name  ='';
  Future getUser() async {
    await _firestore
        .collection('users').doc(services.user!.uid)
        .get()
        .then((value) {
      setState(() {

        name = value['name'];
      });
    });
  }
  @override
  void initState() {
    getUser();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text('Feedback',  style: GoogleFonts.poppins(
          textStyle: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black),
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                textAlign: TextAlign.center,
                'Your feedback & Seggestion are important to us',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13.sp,
                      color: Colors.black),
                )),
            SizedBox(height: 2.h,),
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
              ), onRatingUpdate: ( value) {
              FirebaseFirestore.instance.collection('feedback').doc(services.user!.uid).set(
                  {
                    'feedback':'done',
                    'name':name,
                    'text':textController.text,
                    'rating':value,

                  });

            },

              // onRatingUpdate: (rating) {
              //   snapshot.data!.reference.update({
              //     'rating':rating,
              //   });
              // },
            ),
            SizedBox(height: 4.h,),
            Text('Care to Share more about it?',  style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                  color: Colors.black),
            )),
            SizedBox(height: 2.h,),
            Container(
              height: 30.h,
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
               FirebaseFirestore.instance.collection('feedback').doc(services.user!.uid).update(
                   {
                     'feedback':'done',
                     'name':name,
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
                      'Publish your feedback',
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
      ),
    );
  }
}
