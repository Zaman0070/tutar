
import 'package:adobe_xd/pinned.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:tutor_app/screens/auth/sign_up.dart';
import 'package:tutor_app/services/firbaseservice.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  final int? index;
  const LoginScreen({Key? key,required this.index}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  TextEditingController passwordTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  FirebaseServices services =FirebaseServices();
  final formKey = GlobalKey<FormState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false;
  List<String>? faculty  =[];
  List<String>? student  =[];
  List<String>? admin  =[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFaculty();
    getStudent();
    getAdmin();

  }
  googleMeet() async {
    var url = 'https://trial.talking2allah.com/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  Future getFaculty() async {
    await _firestore
        .collection('users').where('type',isEqualTo: 'faculty')
        .get()
        .then((chatMap) {
          for (var element in chatMap.docs) {
            faculty!.add(element['uid'])  ;
          }
      print(faculty);
      isLoading = false;
      setState(() {});
    });
  }
  Future getStudent() async {
    await _firestore
        .collection('users').where('type',isEqualTo: 'student')
        .get()
        .then((chatMap) {
      for (var element in chatMap.docs) {
        student!.add(element['uid'])  ;
      }
      print(student);
      isLoading = false;
      setState(() {});
    });
  }
  Future getAdmin() async {
    await _firestore
        .collection('users').where('type',isEqualTo: 'admin')
        .get()
        .then((chatMap) {
      for (var element in chatMap.docs) {
        admin!.add(element['uid'])  ;
      }
      print(admin);
      isLoading = false;
      setState(() {});
    });
  }
  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Text('Email',style: TextStyle(color: Colors.grey[700]),),
        ),
        TextFormField(
          controller: emailTextController,
          validator: (value){
            if(value == null || value.isEmpty){
              return 'Enter your Email';
            }
          },
          keyboardType: TextInputType.emailAddress,
          style:const TextStyle(
            color: Colors.black,
            fontFamily: 'OpenSans',
          ),
          decoration:const InputDecoration(
            contentPadding: EdgeInsets.only(top: 14.0),
            prefixIcon: Icon(
              Icons.email,
              size: 20,
              color: Color(0xff3B6EE9),
            ),
            hintText: 'Enter your Email',
            //  hintStyle: kHintTextStyle,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Text('Password',style: TextStyle(color: Colors.grey[700]),),
        ),
        TextFormField(
          controller: passwordTextController,
          validator: (value){
            if(value == null || value.isEmpty){
              return 'Enter your Password';
            }
            return null;
          },
          obscureText: true,
          style:const TextStyle(
            color: Colors.black,
            fontFamily: 'OpenSans',
          ),
          decoration:const InputDecoration(
            contentPadding: EdgeInsets.only(top: 14.0),
            prefixIcon: Icon(
              Icons.lock,
              color:   Color(0xff3B6EE9),
            ),
            hintText: 'Enter your Password',
            //  hintStyle: kHintTextStyle,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildLoginBtn() {
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
          onPressed: () {
            widget.index==0?
            services.userLogin(emailTextController.text, passwordTextController.text, context,student!): null;

            widget.index==1?
            services.facultyLogin(emailTextController.text, passwordTextController.text, context,faculty!): null;
            services.adminLogin(emailTextController.text, passwordTextController.text, context,admin!);

          },
          child: Text(
            'LOGIN',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                  color: Colors.white
              ),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: formKey,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                height: 22.h,
                width: 100.w,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(45),
                        bottomRight: Radius.circular(45)),
                    ),
                child: Stack(
                  children: [
                    Pinned.fromPins(
                      Pin(size: 170, start: 95),
                      Pin(size: 170.0, middle: 0.566),
                      child:Image.asset('assets/logo/logo1.png')
                    ),
                    Pinned.fromPins(
                      Pin(size: 28.0, end: 65.0),
                      Pin(size: 28.0, middle: 0.18),
                      child:
                      // Adobe XD layer: 'Ellipse 20' (shape)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          const BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                          border: Border.all(
                            width: 6.0,
                            color: const Color(0xff3B6EE9).withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),
                    Pinned.fromPins(
                      Pin(size: 15.0, middle: 0.22),
                      Pin(size: 15.0, start: 40.0),
                      child:
                      // Adobe XD layer: 'Ellipse 21' (shape)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          const BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                          border: Border.all(width: 4.0, color: const Color(0xff3B6EE9).withOpacity(0.4),),
                        ),
                      ),
                    ),
                    Pinned.fromPins(
                      Pin(size: 12.0, middle: 0.75),
                      Pin(size: 12.0, start: 120.0),
                      child:
                      // Adobe XD layer: 'Ellipse 21' (shape)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          const BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                          border: Border.all(
                            width: 4.0,
                            color: const Color(0xff3B6EE9).withOpacity(0.4),
                          ),
                        ),
                      ),
                    ),
                    Pinned.fromPins(
                      Pin(size: 35.0, middle: 0.22),
                      Pin(size: 35.0, start: 130.0),
                      child:
                      // Adobe XD layer: 'Ellipse 21' (shape)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          const BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                          border: Border.all(width: 6.0, color: const Color(0xff3B6EE9).withOpacity(0.3),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 1.h,),
              Container(
                height: 70.h,
                width: 100.w,
                decoration: const BoxDecoration(
                    color:  Color(0xff3B6EE9),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30)),
                ),
                child: ListView(
                  children: [
                    SizedBox(height: 2.5.h,),
                    Center(child: Text( widget.index == 0 ?"STUDENT LOGIN":"FACULTY LOGIN", style:  GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                        color: Colors.white
                      ),
                    ))),
                    SizedBox(height: 2.5.h,),
                    Container(
                      height: 65.h,
                      width: 100.w,
                      decoration: const BoxDecoration(
                        color:  Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            topLeft: Radius.circular(30)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35.0),
                        child: Column(
                          children: [
                            SizedBox(height: 7.h,),
                            _buildEmailTF(),
                            SizedBox(
                              height: 2.h,
                            ),
                            _buildPasswordTF(),
                            SizedBox(
                              height: 1.h,
                            ),
                            SizedBox(
                              height: 3.h,
                            ),
                            _buildLoginBtn(),
                            SizedBox(height: 5.h,),
                            Row(
                              children: [
                                Text('Note: ',style: TextStyle(fontWeight: FontWeight.w900),),
                                Text(widget.index==0?'If you are not an enrolled student, ':"Contact the administrator for portal access.",),
                                InkWell(
                                    onTap: googleMeet,
                                    child: Text(widget.index==0?'click here.':"",style: TextStyle(fontWeight: FontWeight.w900,color: Color(0xff343674)),)),
                              ],
                            ),
                              Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: widget.index ==0?const Divider(
                                color: Color(0xff343674),
                                indent: 250,
                                height: 5,
                                thickness: 2,
                              ):null,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
