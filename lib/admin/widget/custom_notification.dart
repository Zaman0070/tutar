import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Provider/user_provider.dart';
import '../../services/firbaseservice.dart';

class CustomNotifications extends StatefulWidget {
  const CustomNotifications({Key? key}) : super(key: key);

  @override
  State<CustomNotifications> createState() => _CustomNotificationsState();
}

class _CustomNotificationsState extends State<CustomNotifications> {

  _resetStyle() {
    InAppNotifications.instance
      ..titleFontSize = 14.0
      ..descriptionFontSize = 14.0
      ..textColor = Colors.black
      ..backgroundColor = Colors.white
      ..shadow = true
      ..animationStyle = InAppNotificationsAnimationStyle.scale;
  }

  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  FirebaseServices services = FirebaseServices();
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    var data = userProvider.studentData;
    Widget _buildNameTF() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xffE1E9FC),
            ),
            height: 50.0,
            child:  TextFormField(
              validator: (value){
                if(value == null || value.isEmpty){
                  return 'Enter Title of Notification';
                }
              },
              controller: titleController,
              keyboardType: TextInputType.name,
              style:const TextStyle(
                color: Colors.black,
                fontFamily: 'OpenSans',
              ),
              decoration:const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.password,
                  size: 20,
                  color: Color(0xff376AED),
                ),
                hintText: 'Enter Notification Title',
                //  hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ],
      );
    }
    Widget _buildDesTF() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xffE1E9FC),
            ),
            height: 50.0,
            child:  TextFormField(
              validator: (value){
                if(value == null || value.isEmpty){
                  return 'Enter Message';
                }
              },
              controller: descriptionController,
              keyboardType: TextInputType.name,
              style:const TextStyle(
                color: Colors.black,
                fontFamily: 'OpenSans',
              ),
              decoration:const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.password,
                  size: 20,
                  color: Color(0xff376AED),
                ),
                hintText: 'Enter Message',
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
            _resetStyle();

            FirebaseFirestore.instance.collection('customNotification').doc().set({
              "title" : titleController.text,
              'message': descriptionController.text,
              'uid': data!['uid']
            });
            Navigator.pop(context);
          },

          child: const Text(
            'Send Notification',
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
    return  Scaffold(
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNameTF(),
            SizedBox(height: 2.h,),
            _buildDesTF(),
            SizedBox(height: 2.h,),
            _sbuildLoginBtn(),
          ],
        ),
      ),
    );
  }
}
