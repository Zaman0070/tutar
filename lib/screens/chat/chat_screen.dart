import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:tutor_app/screens/chat/conversation_screen.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title:const Text('Chat',style: TextStyle(color: Colors.black),),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: ListView(
          children: [
            InkWell(
              onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const ConversationScreen())),
              child: Row(
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
                      Text('so what up?',style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w300),),

                    ],
                  ),
                ],
              ),
            ),
            Divider(),
            InkWell(
              onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const ConversationScreen())),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 3.5.h,
                    child: Icon(Icons.groups,size: 30,),
                  ),
                  SizedBox(width: 2.h,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('group Chat',style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w500),),
                      SizedBox(height: 0.5.h,),
                      Text('so what up?',style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w300),),

                    ],
                  ),
                ],
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
