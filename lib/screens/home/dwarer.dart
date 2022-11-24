import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:sizer/sizer.dart';
import 'package:tutor_app/screens/home/main.dart';
import 'package:tutor_app/widget/feedback.dart';

import '../splash_screen/on_board_screen.dart';

class HomeDrawe extends StatefulWidget {
  int? index;
   HomeDrawe({Key? key,required this.index}) : super(key: key);

  @override
  State<HomeDrawe> createState() => _HomeDraweState();
}

class _HomeDraweState extends State<HomeDrawe> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  String url = '';
  String name = '';
  String secondName = '';
  String type = '';

  Future getAdminData() async {
    await _firestore
        .collection('users').doc(_auth.currentUser!.uid)
        .get()
        .then((chatMap) {

        url = chatMap['url']  ;
        name = chatMap['name'];
        secondName = chatMap['secondName'];
        type = chatMap['type'];

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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: ListTileTheme(
          textColor: Colors.white,
          iconColor: Colors.white,
          child: Padding(
            padding:  EdgeInsets.all(3.5.h),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
            CachedNetworkImage(
            imageBuilder: (context,imageProvider)=>CircleAvatar(
            radius: 3.5.h,
            backgroundImage: imageProvider,
          ),
          cacheManager: CacheManager(Config(
              'customCacheKey',
              stalePeriod: const Duration(days: 500)

          )),
          imageUrl: url,

        ),
                    SizedBox(width: 2.w,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("$name $secondName",style: TextStyle(fontSize: 17.sp,color: Colors.white),),
                        Text(type,style: TextStyle(fontSize: 13.sp,color: Colors.white),)
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                ListTile(
                  onTap: () =>Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>MainScreen(index: widget.index))),
                  leading: Image.asset('assets/icons/h.png',height: 3.h,),
                  title: Text('Home',style: TextStyle(color: Colors.grey[200]),),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>const Feedbacks()));
                  },
                  leading:Image.asset('assets/logo/feedback.png',height: 3.5.h,color: Colors.grey[200]),
                  title: Text('Feedback',style: TextStyle(color: Colors.grey[200]),),
                ),

                ListTile(
                  onTap: () {
                    setState(() {
                      FirebaseAuth.instance.signOut();
                    });
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const OnBoardScreen()));
                  },
                  leading:Image.asset('assets/icons/logout.png',height: 3.5.h,color: Colors.grey[200]),
                  title: Text('Logout',style: TextStyle(color: Colors.grey[200]),),
                ),
                const Spacer(),
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 16.0,
                    ),
                    child: const Text('Talking2Allah.com'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
