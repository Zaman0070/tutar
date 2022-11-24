import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'package:tutor_app/services/firbaseservice.dart';
import '../Provider/user_provider.dart';

class StudentTask extends StatefulWidget {
  const StudentTask({Key? key}) : super(key: key);

  @override
  State<StudentTask> createState() => _StudentTaskState();
}

class _StudentTaskState extends State<StudentTask> {
  FirebaseServices services = FirebaseServices();
  String? _setTime, _setDate;
  DateTime selectedDate = DateTime.now();
  TextEditingController pickDateController = TextEditingController();
  TextEditingController taskController = TextEditingController();
  TextEditingController newTaskController = TextEditingController();
  TextEditingController deadLineDateController = TextEditingController();
  Future<void> _pSelectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        pickDateController.text = DateFormat.yMd().format(selectedDate);
      });
    }
  }
  Future<void> _dSelectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        deadLineDateController.text = DateFormat.yMd().format(selectedDate);
      });
    }
  }

  @override
  void initState() {
    pickDateController.text = DateFormat.yMd().format(DateTime.now());
    deadLineDateController.text = DateFormat.yMd().format(DateTime.now());
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    var data = userProvider.studentData;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text('${data!['name']} Task List',  style: GoogleFonts.poppins(
          textStyle: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black),
        )),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        showDialog(
            context: context,
            builder: (ctxt) =>   AlertDialog(
              scrollable: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              title: const Text('New Task'),
              actions: [
                Container(
                  height: 20.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                      color: Theme.of(context).splashColor,
                      borderRadius: BorderRadius.circular(6),
                  ),
                  child: TextFormField(
                    style: TextStyle(fontSize: 18),
                    autofocus: false,
                    keyboardType: TextInputType.text,
                    maxLength: 350,
                    minLines: 6,
                    maxLines: 10,
                    controller: newTaskController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                       hintText: 'Enter Task',
                      hintStyle: TextStyle(color: Colors.grey,fontSize: 18),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 25.0),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(15.0),

                      backgroundColor: const Color(0xff376AED),
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: (){
                      services.task.doc(data['uid']).collection('tasks').doc().set(
                          {
                            'task':newTaskController.text,
                            'id': data['uid'],
                          });
                      Navigator.pop(context);
                      setState(() {

                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content:
                        Text('Successfully Assign task !'),
                        ),
                      );

                    },
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.5,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ),
                ),
              ],
            ));
      },child: const Icon(Icons.add),),
      body: ListView(
        children: [
          FutureBuilder<QuerySnapshot>(
              future: services.task.doc(data['uid']).collection('tasks').get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.data == null) {
                  return Container();
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ));
                }

                return   ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.size,

                  itemBuilder:(BuildContext context,int index){
                    var taskData =snapshot.data!.docs[index];
                    return Stack(
                      children: [
                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 3.h,vertical: 1.h),
                          child: Container(
                            height: 10.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color(0xffD7DDEC).withOpacity(
                                    0.4)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(width: 2.h,),
                                      Image.asset('assets/icons/tsk.png',height: 5.h,),

                                      SizedBox(width: 2.h,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 2.h,),
                                          Text( 'Prepare task',
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight
                                                      .w700,
                                                  fontSize: 14.sp,
                                                  color: const Color(
                                                      0xff305F72)
                                              ),
                                            ),),
                                          SizedBox(height: 0.4.h,),
                                          Container(
                                            width: 60.w,
                                            child: Text( taskData['task'],
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                                style: TextStyle(color: Colors.red,fontSize: 11.5.sp,fontWeight: FontWeight.w300),),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right:12,
                          top:-15,
                          child: IconButton(
                              onPressed: (){
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
                                                'Are you sure delete ?',
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
                                                        taskData.reference.delete();
                                                      });
                                                      Navigator.pop(context);
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
                              }, icon:  Icon(Icons.delete,color: Colors.redAccent,size: 25,)),
                        ),
                        Positioned(
                          right:48,
                          top:-15,
                          child: IconButton(
                              onPressed: (){
                                showDialog(
                                    context: context,
                                    builder: (ctxt) => AlertDialog(
                                      scrollable: true,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      title: const Text('Edit Task'),
                                      actions: [
                                        Container(
                                          height: 20.h,
                                          width: 100.w,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).splashColor,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: TextFormField(
                                            style: TextStyle(fontSize: 18),
                                            autofocus: false,
                                            keyboardType: TextInputType.text,
                                            maxLength: 350,
                                            minLines: 6,
                                            maxLines: 10,
                                            controller: taskController,
                                            decoration: const InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                                              hintText: 'Enter Task',
                                              hintStyle: TextStyle(color: Colors.grey,fontSize: 18),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(vertical: 25.0),
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              padding: const EdgeInsets.all(15.0),

                                              backgroundColor: const Color(0xff376AED),
                                              elevation: 5.0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                            ),
                                            onPressed: (){
                                              taskData.reference.update({
                                                'task': taskController.text,
                                              }).whenComplete(() => Navigator.pop(context));
                                            },
                                            child: const Text(
                                              'Done',
                                              style: TextStyle(
                                                color: Colors.white,
                                                letterSpacing: 1.5,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'OpenSans',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ));
                              }, icon:  Icon(Icons.edit,color: Colors.blueAccent,size: 25,)),
                        ),
                      ],
                    );
                  },
                );
              })

        ],
      ),
    );
  }
}
