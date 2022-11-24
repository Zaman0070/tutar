import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ConversationScreen extends StatelessWidget {
  const ConversationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 2.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 3.5.h,
                  backgroundImage:const AssetImage('assets/images/person.png'),
                ),
                SizedBox(width: 2.h,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Yousuf Saymon',style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w500),),
                    SizedBox(height: 0.5.h,),
                    Text('Student',style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w300),),

                  ],
                ),
              ],
            ),
            SizedBox(height: 44.h,),
            Image.asset('assets/images/chat.png'),
          ],
        ),
      ),
    );
  }
}
