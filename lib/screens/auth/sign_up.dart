import 'dart:io';
import 'dart:math';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';


import 'package:sizer/sizer.dart';

import '../../services/firbaseservice.dart';

class SignUp extends StatefulWidget {

  const SignUp({Key? key,}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignUp> {

  TextEditingController passwordTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  // TextEditingController phoneTextController = TextEditingController();
   TextEditingController nameTextController = TextEditingController();
  FirebaseServices services = FirebaseServices();
  final formKey = GlobalKey<FormState>();




  // Widget _buildPhone() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: <Widget>[
  //       Container(
  //         alignment: Alignment.centerLeft,
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(10),
  //           color: Theme.of(context).splashColor,
  //         ),
  //         height: 50.0,
  //         child:  TextFormField(
  //
  //           validator: (value){
  //             if(value == null || value.isEmpty){
  //               return 'Enter your phone number';
  //             }
  //             return null;
  //           },
  //           controller: phoneTextController,
  //           keyboardType: TextInputType.number,
  //           style:const TextStyle(
  //             color: Colors.black,
  //             fontFamily: 'OpenSans',
  //           ),
  //           decoration:const InputDecoration(
  //             border: InputBorder.none,
  //             contentPadding: EdgeInsets.only(top: 14.0),
  //             prefixIcon: Icon(
  //               Icons.phone,
  //               size: 20,
  //               color: Color(0xff27C1F9),
  //             ),
  //             hintText: 'Enter your phone number',
  //             //  hintStyle: kHintTextStyle,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
  Widget _buildNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).splashColor,
          ),
          height: 50.0,
          child:  TextFormField(
            validator: (value){
              if(value == null || value.isEmpty){
                return 'Enter your Name';
              }
            },
            controller: nameTextController,
            keyboardType: TextInputType.name,
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
                color: Color(0xff27C1F9),
              ),
              hintText: 'Enter your Name',
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
            color: Theme.of(context).splashColor,
          ),
          height: 50.0,
          child:  TextFormField(
            validator: (value){
              if(value == null || value.isEmpty){
                return 'Enter your Email';
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
                color: Color(0xff27C1F9),
              ),
              hintText: 'Enter your Email',
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
            color: Theme.of(context).splashColor,
          ),
          height: 50.0,
          child:  TextFormField(
            validator: (value){
              if(value == null || value.isEmpty){
                return 'Enter your Password';
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
                color: Color(0xff27C1F9),
              ),
              hintText: 'Enter your Password',
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

              services.adminRegister(emailTextController.text, passwordTextController.text, context,imageUrl,nameTextController.text,);
           }
            else{
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Image not uploaded')),
                );
              }
              }
        },
        child: const Text(
          'Sign-Up',
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


  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: (){

      },
      child: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: 'Already have an account? ',
              style: TextStyle(
                color: Color(0xff27C1F9),
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'login',
              style: TextStyle(
                color:Color(0xff27C1F9),
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
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
                SizedBox(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 105.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/logo/logo.png',
                          height: 10.h,
                          color: const Color(0xff27C1F9),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Text(
                          'create account',
                        //  widget.index==0?"Create an account":widget.index==1?'Create admin account': '',
                          style: TextStyle(
                            color:const Color(0xff27C1F9),
                            fontFamily: 'OpenSans',
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w400,
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
                            backgroundColor: const Color(0xff476cfb),
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
                     //   _buildPhone(),

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
                        _buildSignupBtn(),
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

      await FirebaseFirestore.instance
          .collection('users')
          .doc(services.user!.uid)
          .set({
        'url': imageString,
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
