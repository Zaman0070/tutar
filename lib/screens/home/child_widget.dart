import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_app/Provider/user_provider.dart';
import 'package:tutor_app/admin/group_chats/group_chat_screen.dart';
import 'package:tutor_app/screens/chat/chat_screen.dart';
import 'package:tutor_app/screens/home/home.dart';
import 'package:tutor_app/screens/profile/profile.dart';
import 'package:tutor_app/screens/task/task_screen.dart';
import 'package:tutor_app/services/firbaseservice.dart';

class ChildWidget extends StatelessWidget {
  final AvailableNumber? number;
  final int? index;

  const ChildWidget({Key? key, this.number,required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    FirebaseServices services =FirebaseServices();
    String file = "";
    if (number == AvailableNumber.First) {
      return Home(index: index,);
    } else if (number == AvailableNumber.Second) {
      return TaskScreen(index: index,);

    } else if (number == AvailableNumber.Third){
      return  GroupChatHomeScreen(index: index,);
    }
    else{
      return Profile(index: index,);
    }
  }
}

enum AvailableNumber { First, Second, Third ,Forth}