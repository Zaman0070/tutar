import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tutor_app/admin/admin_main.dart';

import '../Model/token_model.dart';
import '../screens/home/main.dart';


class FirebaseServices{
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference announcement = FirebaseFirestore.instance.collection('announcement');
  CollectionReference banner = FirebaseFirestore.instance.collection('banner');
  CollectionReference feedback = FirebaseFirestore.instance.collection('feedback');
  CollectionReference task = FirebaseFirestore.instance.collection('task');
  CollectionReference event = FirebaseFirestore.instance.collection('event');





  User? user = FirebaseAuth.instance.currentUser;


  Future<void> addUser(context, uid)async{

    final QuerySnapshot  result = await users.where('uid',isEqualTo: uid).get();

    List<DocumentSnapshot> document = result.docs;

    if(document.isNotEmpty){
    //  Navigator.push(context, MaterialPageRoute(builder: (_)=>const MainScreen()));

    }else{


      return users.doc(user!.uid)
          .set({
        'uid':user!.uid,
        'email' : user!.email,
        'name' : user!.displayName,
        'url': user!.photoURL,
        // 'phone_number':user!.phoneNumber,
        // 'type':'user'
      }).then((value){
        //Navigator.push(context, MaterialPageRoute(builder: (_)=>const MainScreen()));

      })
          .catchError((error)=>print('failed to add user : $error'));
    }
  }
  Future<void> getUserName() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc((FirebaseAuth.instance.currentUser!).uid)
        .get()
        .then((value) {
      var email = user!.email;
      var name = user!.displayName;
      var url = user!.photoURL;
      var uid = user!.uid;
      var phone_number = user!.phoneNumber;
      var type = "user";
    });
  }



  userLogin(email,password, context,List<String> Uid)async{
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String? fcmToken = await firebaseMessaging.getToken();
    try{
      UserCredential userCredential =  await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      if(Uid.contains(userCredential.user!.uid)){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content:
          Text('Successfully login !'),
          ),
        );
        final tokenRef = users.doc(userCredential.user!.uid).collection('tokens').doc(fcmToken);
        await tokenRef.set(TokenModel(token: fcmToken! ,createdAt: FieldValue.serverTimestamp()).toJson());
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>const MainScreen(index: 0)), (route) => false);

      }

    }on FirebaseAuthException catch(e){
      if(e.code == 'user-not-found'){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content:
          Text('No user found for this email'),
          ),
        );
      }else if(e.code == 'wrong-password'){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content:
          Text('Wrong password provided for this user'),
          ),
        );
      }
    }
  }
  adminLogin(email,password, context,List<String> Uid)async{
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String? fcmToken = await firebaseMessaging.getToken();
    try{
      UserCredential userCredential =  await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      if(Uid.contains(userCredential.user!.uid)){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content:
          Text('Successfully login !'),
          ),
        );
        final tokenRef = users.doc(userCredential.user!.uid).collection('tokens').doc(fcmToken);
        await tokenRef.set(TokenModel(token: fcmToken! ,createdAt: FieldValue.serverTimestamp()).toJson());
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>const AdminMainScreen()), (route) => false);

      }

    }on FirebaseAuthException catch(e){
      if(e.code == 'user-not-found'){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content:
          Text('No user found for this email'),
          ),
        );
      }else if(e.code == 'wrong-password'){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content:
          Text('Wrong password provided for this user'),
          ),
        );
      }
    }
  }
  studentRegister(email,password, context,phone,url,name)async {
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
    try {
      UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email, password: password);
      final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      String? fcmToken = await firebaseMessaging.getToken();
      // if (userCredential.user!.uid.isNotEmpty) {

      if (userCredential.user!.uid.isNotEmpty) {
        // final tokenRef = users.doc(userCredential.user!.uid).collection('tokens').doc(userCredential.user!.uid);
        // await tokenRef.set(TokenModel(token: fcmToken! ,createdAt: FieldValue.serverTimestamp()).toJson());
        return users.doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': userCredential.user!.email,
          'secondName': phone,
          'name':name,
          'url':url,
          'link':'',
          'assign':'false',
          'completeClasses':0,
          'totalClasses':'',
          'task':'',
          'fId':'',
          'attendees':[],
          'status':'Offline',
          'date':[],
          'schedule':[
          ],
          'type':'student',
        }).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content:
            Text('Student Account has been successfully created !'),
            ),
          );
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>const AdminMainScreen()), (route) => false);

        });
      }
    }on FirebaseAuthException catch(e){
      if(e.code == 'email-already-in-use'){
        ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content:
          Text('The account already exists for that email '),
          ),
        );
      }
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content:
        Text('${e.toString()} '),
        ),
      );
    }
  }
  adminRegister(email,password, context,url,name)async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
     final String? fcmToken = await firebaseMessaging.getToken();
      // if (userCredential.user!.uid.isNotEmpty) {

      if (userCredential.user!.uid.isNotEmpty) {
        // final tokenRef = users.doc(userCredential.user!.uid).collection('tokens').doc(userCredential.user!.uid);
        // await tokenRef.set(TokenModel(token: fcmToken ,createdAt: FieldValue.serverTimestamp()).toJson());
        return users.doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': userCredential.user!.email,
          'name':name,
          'url':url,
          'status':'Offline',
          'type':'admin',
        }).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content:
            Text('Account has been successfully created !'),
            ),
          );
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const AdminMainScreen()));
        });
      }
    }on FirebaseAuthException catch(e){
      if(e.code == 'email-already-in-use'){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content:
          Text('The account already exists for that email '),
          ),
        );
      }
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content:
        Text('${e.toString()} '),
        ),
      );
    }
  }


  Future<DocumentSnapshot> getUserData() async {
    DocumentSnapshot doc = await users.doc(user!.uid).get();
    return doc;
  }

/// Rider
  facultyRegister(email,password, context,phone,url,name)async {
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);

    try {
      UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email, password: password);
      final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      String? fcmToken = await firebaseMessaging.getToken();
      if (userCredential.user!.uid.isNotEmpty) {
        // final tokenRef = users.doc(userCredential.user!.uid).collection('tokens').doc(userCredential.user!.uid);
        // await tokenRef.set(TokenModel(token: fcmToken! ,createdAt: FieldValue.serverTimestamp()).toJson());
        return users.doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': userCredential.user!.email,
          'secondName': phone,
          'name':name,
          'link':'',
          'completeClasses':0,
          'totalClasses':'',
          'status':'Offline',
          'schedule':[
          ],
          'attendees':[],
          'date':[],
          'students':[],
          'url':url,
          'type':'faculty',
        }).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content:
            Text('Account has been successfully created !'),
            ),
          );
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>const AdminMainScreen()), (route) => false);

        });
      }
    }on FirebaseAuthException catch(e){
      if(e.code == 'email-already-in-use'){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content:
          Text('The account already exists for that email '),
          ),
        );
      }
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content:
        Text('${e.toString()} '),
        ),
      );
    }
  }
  facultyLogin(email,password, context,List<String> Uid)async{
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String? fcmToken = await firebaseMessaging.getToken();
    try{
      UserCredential userCredential =  await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
      );

      if(Uid.contains(userCredential.user!.uid)){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content:
          Text('Successfully login !'),
          ),
        );
        final tokenRef = users.doc(userCredential.user!.uid).collection('tokens').doc(fcmToken);
        await tokenRef.set(TokenModel(token: fcmToken! ,createdAt: FieldValue.serverTimestamp()).toJson());
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>const MainScreen(index: 1)), (route) => false);


      }

    }on FirebaseAuthException catch(e){
      if(e.code == 'user-not-found'){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content:
          Text('No user found for this email'),
          ),
        );
      }else if(e.code == 'wrong-password'){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content:
          Text('Wrong password provided for this user'),
          ),
        );
      }
    }
  }




}