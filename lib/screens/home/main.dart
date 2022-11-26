import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Provider/user_provider.dart';
import '../../services/firbaseservice.dart';
import 'child_widget.dart';
import 'home.dart';

class MainScreen extends StatefulWidget {
  final int? index;
  final String? type;
  const MainScreen({Key? key, required this.index, this.type})
      : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController(
    initialPage: 0,
  );
  int currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:  Container(
          decoration: const BoxDecoration(
            boxShadow:  [
              BoxShadow(color:Colors.black12,spreadRadius: 6,offset: Offset(0, 0),blurRadius: 10)
            ],
          ),
          child:  BottomNavigationBar(
            mouseCursor: MouseCursor.uncontrolled,
            unselectedItemColor: const Color(0xff7B8BB2),
            selectedItemColor: const Color(0xff376AED),
            currentIndex: currentIndex,
            // type: BottomNavigationBarType.shifting,
            onTap: (value) {
              setState(() {
                currentIndex = value;
                _pageController.animateToPage(
                  value,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.bounceInOut,
                );
              });
            },
            items: [
              BottomNavigationBarItem(
                icon:  Image.asset('assets/icons/home.png',height: 3.h,
                    color: currentIndex == 0 ? const Color(0xff376AED) : const Color(0xff7B8BB2)),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon:  Image.asset('assets/icons/task.png',height: 2.6.h,color: currentIndex == 1 ? const Color(0xff376AED) : const Color(0xff7B8BB2)),
                label: "Task",
              ),
              BottomNavigationBarItem(
                icon:  Image.asset('assets/chatt.png',height: 3.h,color: currentIndex == 2 ? const Color(0xff376AED) : const Color(0xff7B8BB2)),
                label: "Chat",
              ),
              BottomNavigationBarItem(
                icon:  Image.asset('assets/icons/profile.png',height: 3.2.h,color: currentIndex == 3 ? const Color(0xff376AED) : const Color(0xff7B8BB2)),
                label: "Menu",
              ),
            ],
          )
      ),
      body: ConnectivityWidgetWrapper(
        child: PageView(
          controller: _pageController,
          onPageChanged: (page) {
            setState(() {
              currentIndex = page;
            });
          },
          children: <Widget>[
            ChildWidget(
              number: AvailableNumber.First,
              index: widget.index,
            ),
            ChildWidget(
              number: AvailableNumber.Second,
              index: widget.index,
            ),
            ChildWidget(
              number: AvailableNumber.Third,
              index: widget.index,
            ),
            ChildWidget(
              number: AvailableNumber.Forth,
              index: widget.index,
            )
          ],
        ),
      ),
    );
  }
}
