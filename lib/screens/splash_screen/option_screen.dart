import 'package:adobe_xd/pinned.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sizer/sizer.dart';

import '../auth/login.dart';

class OptionScreen extends StatefulWidget {
  const OptionScreen({Key? key}) : super(key: key);

  @override
  State<OptionScreen> createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 48.5.h,
            decoration:  BoxDecoration(
                boxShadow: [
                  BoxShadow(color:Colors.grey.shade300,spreadRadius: 4,offset: const Offset(3, 3),blurRadius: 10)
                ],
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(38),
                  bottomLeft: Radius.circular(38),
                ),
                image: const DecorationImage(
                    image: AssetImage('assets/1.gif'),fit: BoxFit.cover
                )
            ),
          ),
          SizedBox(height: 5.h,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to the',
                    style:  GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 28.sp,
                        color:Colors.black,
                      ),
                    )
                ),
                Row(
                  children: [
                    Text(
                      'Future.',
                        style:  GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 28.sp,
                            color: const Color(0xff3B6EE9)
                          ),
                        )
                    ),
                    Image.asset('assets/emojy.gif',height: 6.h,),
                  ],
                ),
                SizedBox(
                  height: 1.h,
                ),
                Text(
                  'Login as a',
                  style: TextStyle(
                      fontSize: 15.sp,),
                ),
                SizedBox(
                  height: 3.h,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      index = 0;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const LoginScreen(
                                  index: 0,
                                )));
                  },
                  child: Container(
                    height: 8.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      color:  index == 0 ? const Color(0xff3B6EE9):Colors.white,
                      border: Border.all(color:index == 0 ?  Colors.white : const Color(0xff3B6EE9),width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Student',
                          style:  GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15.sp,
                              color:index == 0 ? Colors.white: const Color(0xff3B6EE9),
                            ),
                          )
                        // style: TextStyle(
                        //   fontSize: 15.sp, fontWeight: FontWeight.w600,color:index == 0 ? Colors.white: const Color(0xff3B6EE9),),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 1.h,),
                InkWell(
                  onTap: (){
                    setState(() {
                      index = 1;
                    });

                    Navigator.push(context, MaterialPageRoute(builder: (_)=>const LoginScreen(index: 1,)));
                  },
                  child: Container(
                    height: 8.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      color:  index == 1 ? const Color(0xff3B6EE9):Colors.white,
                      border: Border.all(color:index == 1 ?  Colors.white : const Color(0xff3B6EE9),width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Faculty',
                          style:  GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15.sp,
                              color:index == 1 ? Colors.white: const Color(0xff3B6EE9),
                            ),
                          )
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
