import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:tutor_app/admin/admin_main.dart';
import 'package:tutor_app/screens/splash_screen/widget/data.dart';

import 'option_screen.dart';
class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {

  List<SliderModel> mySlides = <SliderModel>[];
  int slideIndex = 0;
  PageController? controller;

  Widget _buildPageIndicator(bool isCurrentPage){
    return Container(
      margin:const EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 10.0 : 6.0,
      width: isCurrentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? const Color(0xff27C1F9) : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mySlides = getSlides();
    controller =  PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xff3C8CE7), Color(0xff00EAFF)])),
      child: Scaffold(

        body: Container(
          height: MediaQuery.of(context).size.height - 100,
          child: PageView(
            controller: controller,
            onPageChanged: (index) {
              setState(() {
                slideIndex = index;
              });
            },
            children: <Widget>[
              SlideTile(
                index: 0,
                imagePath: mySlides[0].getImageAssetPath(),
                title: mySlides[0].getTitle(),
                desc: mySlides[0].getDesc(),
              ),
              SlideTile(
                index: 1,
                imagePath: mySlides[1].getImageAssetPath(),
                title: mySlides[1].getTitle(),
                desc: mySlides[1].getDesc(),
              ),
            ],
          ),
        ),
        bottomSheet: slideIndex != 1 ? Padding(
          padding:  EdgeInsets.symmetric(horizontal: 8.h,vertical: 12),
          child: Container(
            height: 8.5.h,
            width: 100.w,
           decoration: BoxDecoration(
             color: const Color(0xff3B6EE9),
             borderRadius: BorderRadius.circular(45),
             boxShadow: [
               BoxShadow(spreadRadius: 2,color: const Color(0xff3B6EE9),offset: Offset(3, 3),blurRadius: 15)
             ]
           ),
            margin:  EdgeInsets.only(bottom: 6.h),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff3B6EE9),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45.0),
            ),
              ),
              onPressed: (){
                print("this is slideIndex: $slideIndex");
                controller!.animateToPage(slideIndex + 1, duration: const Duration(milliseconds: 500), curve: Curves.linear);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "NEXT",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    Image.asset('assets/icons/next.png',height: 5.h,),
                  ],
                ),
              ),
            ),
          ),
        ):Padding(
          padding:  EdgeInsets.symmetric(horizontal: 8.h,vertical: 15),
          child: Container(
            height: 8.5.h,
            width: 100.w,
            decoration: BoxDecoration(
                color: const Color(0xff3B6EE9),
                borderRadius: BorderRadius.circular(45),
                boxShadow: [
                  BoxShadow(spreadRadius: 2,color: const Color(0xff3B6EE9),offset: Offset(3, 3),blurRadius: 15)
                ]
            ),
            margin:  EdgeInsets.only(bottom: 6.h),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff3B6EE9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45.0),
                ),
              ),
              onPressed: (){
               // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const AdminMainScreen()));
                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const OptionScreen()));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Get Started",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    Image.asset('assets/icons/next.png',height: 5.h,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SlideTile extends StatelessWidget {
  String? imagePath, title, desc;
  int? index;


  SlideTile({Key? key, this.imagePath, this.title, this.desc,required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Container(
              height: 48.5.h,
              width: 100.w,
              decoration: BoxDecoration(
                color: Colors.white,
                  boxShadow:  [
                    BoxShadow(color:Colors.grey.shade100,spreadRadius: 0,offset: Offset(3, 3),blurRadius: 10)
                  ],
                borderRadius: BorderRadius.circular(38),
                // image: DecorationImage(
                //   image: AssetImage(imagePath!,),fit: BoxFit.cover,
                // )
              ),
          child:Column(
            children: [
              SizedBox(height: 8.h,),
              Image.asset(imagePath!,height:index==0? 40.h:35.h,),
            ],
          )
            ,),
           SizedBox(
            height: 3.4.h,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(title!, textAlign: TextAlign.center,style:  GoogleFonts.poppins(
              textStyle: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18.sp,
                color:const Color(0xff343674),
              ),
            )
            ),
          ),
           SizedBox(
            height: 1.h,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(desc!, textAlign: TextAlign.center,style:  GoogleFonts.mulish(
              textStyle: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 12.sp,
                color:const Color(0xff343674),
              ),
            )),
          )
        ],
      ),
    );
  }
}
