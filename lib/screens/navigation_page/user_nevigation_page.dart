import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutor_app/admin/admin_main.dart';


import '../../services/firbaseservice.dart';
import '../auth/login.dart';
import '../home/main.dart';
import '../splash_screen/on_board_screen.dart';

class UserNavigationPage extends StatefulWidget {
  const UserNavigationPage({Key? key}) : super(key: key);

  @override
  _UserNavigationPageState createState() => _UserNavigationPageState();
}

class _UserNavigationPageState extends State<UserNavigationPage> {
  FirebaseServices services = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder<DocumentSnapshot>(
        future: services.getUserData(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.data == null) {
            return const OnBoardScreen();
          }
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(
                      Theme.of(context).primaryColor),
                ));
          }
          var data= snapshot.data;
          return   StreamBuilder(

            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapShot) {
              if (data!['type']=='student') {
                return const MainScreen(index: 0,);
              }
               if (data['type']=='admin'){
                return const AdminMainScreen();
              }
              if (data['type']=='faculty'){
                return const MainScreen(index: 1);
              }
              return  data['type']=='student'? const LoginScreen(index: 0,):data['type']=='admin'? const AdminMainScreen():const MainScreen(index: 1,);

            },
            // Navigator.of(context).pop();
            //Navigator.push(context,  SlidingAnimationRoute(builder: (context) => landingPage));
          );
        });
  }
}
