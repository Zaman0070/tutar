import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:sizer/sizer.dart';
import 'package:tutor_app/screens/navigation_page/user_nevigation_page.dart';
import 'package:tutor_app/screens/splash_screen/on_board_screen.dart';
import 'package:tutor_app/services/firbaseservice.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>with WidgetsBindingObserver {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseServices services = FirebaseServices();
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    setStatus('Online');
    Timer(
      const Duration(seconds: 4),
          () =>
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: ((context) => const UserNavigationPage()))),
    );
    super.initState();
  }

  void setStatus(String status)async{
    await _firestore.collection('users').doc(services.user!.uid).update({
      'status':status,
    });
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    if(state == AppLifecycleState.resumed){
      setStatus('Online');
    }else{
      setStatus('Offline');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 4.h,
          ),
          Center(
            child: Hero(
              tag: 'logo',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    child: Image.asset(
                      'assets/logo/logo.png',
                      fit: BoxFit.cover,
                      height: 16.h,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
        ],
      ),
    );
  }
}
