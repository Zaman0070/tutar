import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tutor_app/admin/admin_main.dart';


import '../../Provider/user_provider.dart';
import 'manage_shedual/manage_schedual.dart';

class Setting extends StatefulWidget {
  final int index;
  const Setting({Key? key,required this.index}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  var linController = TextEditingController();
  var completeClassesController = TextEditingController();
  var totalClassesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    var data = userProvider.studentData;
    List<dynamic> attendees = data!['attendees'];
    linController.text = data['link'];
   // completeClassesController.text = data['completeClasses'];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text('Setting',style:  GoogleFonts.poppins(
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
            color: Colors.black
          ),
        ),),
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.black),

      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
         widget.index==0?   Text('Enter Link',style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  color: Colors.black),
            ),): Container(),
            SizedBox(height: 1.h,),
            widget.index==0?   Container(
                height: 7.h,
                width: 100.w,
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffE1E9FC),),
                    // boxShadow:  const [
                    //   BoxShadow(color:Colors.black12,spreadRadius: 0,offset: Offset(0, 3),blurRadius: 1)
                    // ],
                    color: const Color(0xffE1E9FC),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      height: 7.h,
                      width: 65.w,
                      child:  TextFormField(
                        controller: linController,
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return 'Enter Link';
                          }
                        },
                        style:const TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                        ),
                        decoration:const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 14.0),
                          prefixIcon: Icon(
                            Icons.link,
                            color: Color(0xff27C1F9),
                          ),
                          hintText: 'Enter Link',
                          //  hintStyle: kHintTextStyle,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w,),
                    InkWell(
                      onTap: (){
                        data.reference.update({
                          'link':linController.text,
                        });
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>const AdminMainScreen()), (route) => false);
                      },
                      child: Text('Enter',style:  GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: Colors.black
                        ),
                      ),),
                    ),
                  ],
                )
            ):Container(),
            SizedBox(height: 2.h,),
            Text('Enter Completed Classes',style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  color: Colors.black),
            ),),
            SizedBox(height: 1.h,),
            Container(
                height: 7.h,
                width: 100.w,
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffE1E9FC),),
                    // boxShadow:  const [
                    //   BoxShadow(color:Colors.black12,spreadRadius: 0,offset: Offset(0, 3),blurRadius: 1)
                    // ],
                    color: const Color(0xffE1E9FC),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      height: 7.h,
                      width: 65.w,
                      child:  TextFormField(
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        keyboardType: TextInputType.number,
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return 'Enter classes';
                          }
                        },
                      controller: completeClassesController,
                        style:const TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(top: 14.0),
                          prefixIcon: const Icon(
                            Icons.class_outlined,
                            color: Color(0xff27C1F9),
                          ),
                          hintText: data['completeClasses'].toString(),
                          //  hintStyle: kHintTextStyle,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w,),
                    InkWell(
                      onTap: (){
                        data.reference.update({
                          'completeClasses':int.parse(completeClassesController.text)
                        });
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>const AdminMainScreen()), (route) => false);

                      },
                      child: Text('Enter',style:  GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: Colors.black
                        ),
                      ),),
                    ),
                  ],
                )
            ),
            SizedBox(height: 2.h,),
            Text('Enter Total Classes',style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  color: Colors.black),
            ),),
            SizedBox(height: 1.h,),
            Container(
                height: 7.h,
                width: 100.w,
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffE1E9FC),),
                    // boxShadow:  const [
                    //   BoxShadow(color:Colors.black12,spreadRadius: 0,offset: Offset(0, 3),blurRadius: 1)
                    // ],
                    color: const Color(0xffE1E9FC),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      height: 7.h,
                      width: 65.w,
                      child:  TextFormField(
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return 'Enter classes';
                          }
                        },
                        controller: totalClassesController,
                        style:const TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 14.0),
                          prefixIcon: Icon(
                            Icons.class_outlined,
                            color: Color(0xff27C1F9),
                          ),
                          hintText:  data['totalClasses'],
                          //  hintStyle: kHintTextStyle,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w,),
                    InkWell(
                      onTap: (){
                        data.reference.update({
                          'totalClasses':totalClassesController.text
                        });
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>const AdminMainScreen()), (route) => false);

                      },
                      child: Text('Enter',style:  GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: Colors.black
                        ),
                      ),),
                    ),
                  ],
                )
            ),
            SizedBox(height: 2.h,),
            InkWell(
              onTap: (){
                userProvider.getStudentDetails(data);
                Navigator.push(context, MaterialPageRoute(builder: (_)=> Calender()));
              },
              child: Container(
                height: 7.h,
                width: 100.w,
                decoration: BoxDecoration(
                  // boxShadow:  const [
                  //   BoxShadow(color:Colors.black12,spreadRadius: 0,offset: Offset(0, 3),blurRadius: 1)
                  // ],
                    color: const Color(0xffE1E9FC),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  children: [
                    SizedBox(width: 3.w,),
                    Text('Manage Schedule',style:  GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                          color: Colors.black
                      ),
                    ),),
                  ],
                )
              ),
            ),
            SizedBox(height: 2.h,),
            InkWell(
              onTap: (){
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(15),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          height: 20.h,
                          child: Column(
                            // mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Are you sure Delete ?',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  SizedBox(width: 5.w),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                       data.reference.delete();
                                      });
                                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>const AdminMainScreen()), (route) => false);

                                    },
                                    child: const Text('Delete'),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    });
              },
              child: Container(
                  height: 7.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    // boxShadow:  const [
                    //   BoxShadow(color:Colors.black12,spreadRadius: 0,offset: Offset(0, 3),blurRadius: 1)
                    // ],
                      color: const Color(0xffE1E9FC),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 3.w,),
                      Text('Delete this user',style:  GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: Colors.black
                        ),
                      ),),
                    ],
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
