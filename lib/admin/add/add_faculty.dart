import 'dart:io';
import 'dart:math';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';


import 'package:sizer/sizer.dart';

import '../../services/firbaseservice.dart';

class AddFaculty extends StatefulWidget {
  const AddFaculty({Key? key,}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<AddFaculty> {

  TextEditingController passwordTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController scondNameTextController = TextEditingController();
  TextEditingController firstNameTextController = TextEditingController();
  FirebaseServices services = FirebaseServices();
  final formKey = GlobalKey<FormState>();



  Widget _buildNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xffE1E9FC),
          ),
          height: 50.0,
          child:  TextFormField(
            validator: (value){
              if(value == null || value.isEmpty){
                return 'Enter First Student Name';
              }
            },
            controller: firstNameTextController,
            keyboardType: TextInputType.name,
            style:const TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration:const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.password,
                size: 20,
                color: Color(0xff376AED),
              ),
              hintText: 'Enter Name',
              //  hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildPhone() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xffE1E9FC),
          ),
          height: 50.0,
          child:  TextFormField(

            validator: (value){
              if(value == null || value.isEmpty){
                return 'Enter your Last Name';
              }
              return null;
            },
            controller: scondNameTextController,
            keyboardType: TextInputType.name,
            style:const TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration:const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.password,
                size: 20,
                color: Color(0xff376AED),
              ),
              hintText: 'Enter Last Name ',
              //  hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xffE1E9FC),
          ),
          height: 50.0,
          child:  TextFormField(
            validator: (value){
              if(value == null || value.isEmpty){
                return 'Enter Student Email';
              }
            },
            controller: emailTextController,
            keyboardType: TextInputType.emailAddress,
            style:const TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration:const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                size: 20,
                color: Color(0xff376AED),
              ),
              hintText: 'Enter Email',
              //  hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xffE1E9FC),
          ),
          height: 50.0,
          child:  TextFormField(
            validator: (value){
              if(value == null || value.isEmpty){
                return 'Password';
              }
            },

            controller: passwordTextController,
            obscureText: true,
            style:const TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration:const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Color(0xff376AED),
              ),
              hintText: 'Password',
              //  hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildLoginBtn() {
    return Container(
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

          if(formKey.currentState!.validate()){
            if(imageUrl!=null){
              services.facultyRegister(emailTextController.text, passwordTextController.text, context, scondNameTextController.text,imageUrl,firstNameTextController.text);
            }
            else{
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Image not uploaded')),
              );
            }
          }
        },
        child: const Text(
          'Register',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }


  XFile? _image;
  String? imageUrl;
  Future getImage(ImageSource source) async {
    var image = await picker.pickImage(source: source);
    setState(() {
      _uploadImageToFirebase(File(image!.path));
      setState(() {
        _image = image ;
        print('Image Path $_image');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text('Register',  style: GoogleFonts.poppins(
          textStyle: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black),
        )),
      ),
      body: Form(
        key: formKey,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: const BoxDecoration(),
                ),
                Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 25.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 3.h,
                        ),
                        Text(
                          'Create Faculty Account',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                        ),
                        SizedBox(height: 3.h),
                        CircleAvatar(
                          radius: 4.5.h,
                          backgroundColor: Colors.white,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 100,
                                backgroundColor: Color(0xff476cfb),
                                child: ClipOval(
                                  child: SizedBox(
                                    width: 180.0,
                                    height: 180.0,
                                    child: (_image !=null)?Image.file(File(
                                      _image!.path,),
                                      fit: BoxFit.fill,
                                    ):Image.network(
                                      "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: -5,
                                right: -15,
                                child: IconButton(
                                    onPressed: () {
                                      bottomSheet();
                                    },
                                    icon:const  Icon(
                                        Icons.add_a_photo,
                                        size: 20,
                                        color: Color(0xff27C1F9)
                                    )),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        _buildNameTF(),
                        SizedBox(
                          height: 1.h,
                        ),

                        _buildPhone(),
                        SizedBox(
                          height: 1.h,
                        ),
                        _buildEmailTF(),
                        SizedBox(
                          height: 1.h,
                        ),
                        _buildPasswordTF(),
                        SizedBox(
                          height: 4.h,
                        ),
                        _buildLoginBtn(),
                        SizedBox(
                          height: 2.5.h,
                        ),
                        SizedBox(
                          height: 2.5.h,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future bottomSheet(){
    return showAdaptiveActionSheet(
      context: context,
      actions: <BottomSheetAction>[
        BottomSheetAction(
          title: const Text('Camera'),
          onPressed:  (BuildContext context)  {
            setState(() {
              getImage(ImageSource.camera).whenComplete((){
              }
              );
            });
            Navigator.pop(context);
          },
        ),
        BottomSheetAction(
          title: const Text('Gallery'), onPressed: (BuildContext context)    {
          setState(() {
            getImage(ImageSource.gallery);
          });
          Navigator.pop(context);
        },

        ),
      ],
      cancelAction: CancelAction(title: const Text('Cancel')),
    );
  }

  final picker = ImagePicker();


  Future<void> _uploadImageToFirebase(File image) async {
    try {
      // Make random image name.
      int randomNumber = Random().nextInt(100000);
      String imageLocation = 'images/image$randomNumber.jpg';

      // Upload image to firebase.
      final Reference storageReference =
      FirebaseStorage.instance.ref().child(imageLocation);
      final UploadTask uploadTask = storageReference.putFile(image);
      await uploadTask;
      setState(() {
        _addPathToDatabase(imageLocation);
      });
    } catch (e) {

    }
  }


  Future<void> _addPathToDatabase(String text) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(text);
      var imageString = await ref.getDownloadURL();

      setState(() {
        imageUrl = imageString;
      });
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text('ok'),
            );
          });
    }
  }
}
