import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:tutor_app/admin/widget/child_widget.dart';



class AdminMainScreen extends StatefulWidget {

  const AdminMainScreen({Key? key}) : super(key: key);

  @override
  _AdminMainScreenState createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
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
    Widget childWidget =  AdminChildWidget(
      number: AvailableNumber.First,
    );
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow:  [
            BoxShadow(color:Colors.black12,spreadRadius: 6,offset: Offset(0, 0),blurRadius: 10)
          ],
        ),
        child: BottomNavigationBar(
          selectedItemColor: const Color(0xff376AED),
          currentIndex: currentIndex,
          onTap: (value) {
            currentIndex = value;
            _pageController.animateToPage(
              value,
              duration: const Duration(milliseconds: 200),
              curve: Curves.bounceInOut,
            );

            setState(() {});
          },
          items: [
            BottomNavigationBarItem(
              icon:  Image.asset('assets/icons/home.png',height: 3.h,color: currentIndex == 0 ? const Color(0xff376AED) : const Color(0xff7B8BB2)),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon:  Image.asset('assets/icons/task.png',height: 2.6.h,color: currentIndex == 1 ? const Color(0xff376AED) : const Color(0xff7B8BB2)),
              label: "Task",
            ),
            BottomNavigationBarItem(
              icon:  Image.asset('assets/icons/chat.png',height: 3.h,color: currentIndex == 2 ? const Color(0xff376AED) : const Color(0xff7B8BB2)),
              label: "Chat",
            ),
            BottomNavigationBarItem(
              icon:  Image.asset('assets/icons/profile.png',height: 3.2.h,color: currentIndex == 3 ? const Color(0xff376AED) : const Color(0xff7B8BB2)),
              label: "Menu",
            ),
          ],
        ),
      ),
      body: ConnectivityWidgetWrapper(
        child: PageView(
          controller: _pageController,
          onPageChanged: (page) {
            setState(() {
              currentIndex = page;
            });
          },
          children:  <Widget>[
            AdminChildWidget(number: AvailableNumber.First,),
            AdminChildWidget(number: AvailableNumber.Second,),
            AdminChildWidget(number: AvailableNumber.Third,),
            AdminChildWidget(number: AvailableNumber.Forth,)
          ],
        ),
      ),
    );
  }
}




// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:sizer/sizer.dart';
// import 'package:tutor_app/screens/chat/chat_screen.dart';
// import 'package:tutor_app/screens/task/task_screen.dart';
//
// import '../profile/profile.dart';
// import 'home.dart';
//
//
//
//
// class MainScreen extends StatefulWidget {
//
//
//   const MainScreen({Key? key}) : super(key: key);
//
//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }
//
// class _MainScreenState extends State<MainScreen> {
//   Widget currentScreen = const Home();
//
//   int index = 0;
//
//   final PageStorageBucket _bucket = PageStorageBucket();
//
//
//   @override
//   Widget build(BuildContext context) {
//     Color color = Theme.of(context).splashColor;
//
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: WillPopScope(
//         onWillPop: (){
//           return Future.value(false);
//         },
//         child: ScrollConfiguration(
//           behavior: const ScrollBehavior(
//             androidOverscrollIndicator: AndroidOverscrollIndicator.glow,
//           ),
//           child: GlowingOverscrollIndicator(
//             axisDirection: AxisDirection.right,
//             color: const Color(0xff675492),
//             child:PageStorage(
//               bucket: _bucket,
//               child: currentScreen,
//             )
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         color: Theme.of(context).canvasColor,
//         shape: const CircularNotchedRectangle(),
//         child: Container(
//           height: 9.5.h,
//           width: 100.w,
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             boxShadow:  [
//               BoxShadow(color:Colors.black26,spreadRadius: 1,offset: Offset(3, 3),blurRadius: 10)
//             ],
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 MaterialButton(
//                   minWidth:20,
//                   onPressed: () {
//                     setState(() {
//                       index = 0;
//                       currentScreen = const Home();
//                     });
//                   },
//                     child:Column(
//                       children: [
//                         SizedBox(height: 1.2.h,),
//                         Image.asset('assets/icons/home.png',height: 3.h,color: index == 0 ? const Color(0xff376AED) :const Color(0xff7B8BB2)),
//                         SizedBox(height: 0.7.h,),
//                         Text('Home',style:  GoogleFonts.poppins(
//                           textStyle: TextStyle(
//                               fontSize: 11.sp,
//                               fontWeight: FontWeight.w500,
//                               color: index == 0 ? const Color(0xff376AED) :const Color(0xff7B8BB2)
//                           ),
//                         ),)
//                       ],
//                     )
//
//                 ),
//                 MaterialButton(
//                   minWidth:20,
//                   onPressed: () {
//                     setState(() {
//                       index = 1;
//                       currentScreen =const TaskScreen();
//                     });
//                   },
//                     child:Column(
//                       children: [
//                         SizedBox(height: 1.2.h,),
//                         Image.asset('assets/icons/task.png',height: 3.h,color: index == 1 ? const Color(0xff376AED) : const Color(0xff7B8BB2)),
//                         SizedBox(height: 0.7.h,),
//                         Text('Task',style:  GoogleFonts.poppins(
//                           textStyle: TextStyle(
//                               fontSize: 11.sp,
//                               fontWeight: FontWeight.w500,
//                               color: index == 1 ? const Color(0xff376AED) :const Color(0xff7B8BB2)
//                           ),
//                         ),)
//                       ],
//                     )
//
//                 ),
//                 MaterialButton(
//                     minWidth: 20,
//                     onPressed: () {
//                       setState(() {
//                         index = 2;
//                         currentScreen =const Chat();
//                       });
//                     },
//                     child:Column(
//                       children: [
//                         SizedBox(height: 1.2.h,),
//                         Image.asset('assets/icons/chat.png',height: 3.h,color: index == 2 ? const Color(0xff376AED) : const Color(0xff7B8BB2)),
//                         SizedBox(height: 0.7.h,),
//                         Text('Chat',style:  GoogleFonts.poppins(
//                           textStyle: TextStyle(
//                               fontSize: 11.sp,
//                               fontWeight: FontWeight.w500,
//                               color: index == 2 ? const Color(0xff376AED) :const Color(0xff7B8BB2)
//                           ),
//                         ),)
//                       ],
//                     )
//                 ),
//                 MaterialButton(
//                   minWidth: 20,
//                   onPressed: () {
//                     setState(() {
//                       index = 3;
//                       currentScreen =const Profile();
//                     });
//                   },
//                     child:Column(
//                       children: [
//                         SizedBox(height: 1.2.h,),
//                         Image.asset('assets/icons/profile.png',height: 3.h,color: index == 3 ? const Color(0xff376AED) :const Color(0xff7B8BB2)),
//                         SizedBox(height: 0.7.h,),
//                         Text('Menu',style:  GoogleFonts.poppins(
//                           textStyle: TextStyle(
//                               fontSize: 11.sp,
//                               fontWeight: FontWeight.w500,
//                               color: index == 3 ? const Color(0xff376AED) :const Color(0xff7B8BB2)
//                           ),
//                         ),)
//                       ],
//                     )
//
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
