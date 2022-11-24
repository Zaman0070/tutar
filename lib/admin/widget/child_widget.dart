import 'package:flutter/material.dart';
import 'package:tutor_app/admin/screens/admin_home.dart';
import 'package:tutor_app/admin/screens/admin_task.dart';
import 'package:tutor_app/admin/screens/profile_admin.dart';
import 'package:tutor_app/screens/chat/chat_screen.dart';
import 'package:tutor_app/screens/home/home.dart';
import 'package:tutor_app/screens/profile/profile.dart';
import 'package:tutor_app/screens/task/task_screen.dart';

import '../group_chats/group_chat_screen.dart';

class AdminChildWidget extends StatelessWidget {
  final AvailableNumber? number;


  const AdminChildWidget({Key? key, this.number,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String file = "";
    if (number == AvailableNumber.First) {
      return const AdminHome();
    } else if (number == AvailableNumber.Second) {
      return const AdminTask();
    } else if (number == AvailableNumber.Third){
      return  GroupChatHomeScreen(index: 3,);
    }
    else{
      return const AdminProfile();
    }
  }
}

enum AvailableNumber { First, Second, Third ,Forth}