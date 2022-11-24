import 'dart:math';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:tutor_app/admin/admin_main.dart';
import 'package:tutor_app/services/firbaseservice.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

class CreateGroup extends StatefulWidget {
  final List<Map<String, dynamic>> membersList;

  const CreateGroup({required this.membersList, Key? key}) : super(key: key);

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final TextEditingController _groupName = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseServices services = FirebaseServices();
  bool isLoading = false;
  var imageString;

  XFile? _image;
  String? imageUrl;
  String groupId = Uuid().v1();
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

  void createGroup() async {
    if (imageUrl != null) {
      setState(() {
        isLoading = true;
      });
      await _firestore.collection('groups').doc(groupId).set({
        "members": widget.membersList,
        "id": groupId,
        'lastMsg': '',
        'read': false,
        'senderId': '',
      });

      for (int i = 0; i < widget.membersList.length; i++) {
        String uid = widget.membersList[i]['uid'];

        await _firestore
            .collection('users')
            .doc(uid)
            .collection('groups')
            .doc(groupId)
            .set({
          "name": _groupName.text,
          "id": groupId,
          'url': imageString
        });
      }

      await _firestore.collection('groups').doc(groupId)
          .collection('chats')
          .add({
        "message": "${_auth.currentUser!.displayName}Admin Created This Group.",
        "type": "notify",
      });

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const AdminMainScreen()), (
          route) => false);
    } else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image not uploaded')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title:const Text('New Group',style: TextStyle(color: Colors.black),),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: isLoading
          ? Container(
              height: size.height,
              width: size.width,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
          : Column(
              children: [
                SizedBox(
                  height: size.height / 12,
                ),

                CircleAvatar(
                  radius: 7.5.h,
                  backgroundColor: Colors.white,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 100,
                        backgroundColor: const Color(0xff576064),
                        child: ClipOval(
                          child: SizedBox(
                            width: 180.0,
                            height: 180.0,
                            child: (_image !=null)?Image.file(File(
                              _image!.path,),
                              fit: BoxFit.fill,
                            ):Icon(Icons.group,color: const Color(0xff8E9496),size: 11.h,)
                          ),
                        ),
                      ),
                      Positioned(
                        top: 30,
                        left: 35,
                        child: Column(
                          children: [
                            IconButton(
                                onPressed: () {
                                  bottomSheet();
                                },
                                icon:const  Icon(
                                    Icons.add_a_photo_rounded,
                                    size: 25,
                                    color: Colors.white
                                )),
                             const Text(
                              textAlign: TextAlign.center,
                              'Add Group\nImage',style: TextStyle(color: Colors.white,fontSize: 11),)

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height / 15,
                ),

                Container(
                  height: size.height / 14,
                  width: size.width,
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: size.height / 14,
                    width: size.width / 1.15,
                    child: TextField(
                      controller: _groupName,
                      decoration: const InputDecoration(
                        hintText: "Group Subject",
                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(10),
                        // ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height / 50,
                ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(15.0),

                backgroundColor: const Color(0xff3B6EE9),
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed:createGroup,
              child: Text(
                'Create Group',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      letterSpacing: 1.1,
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                      color: Colors.white
                  ),
                ),
              ),
            ),
          ),
        ),
              ],
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
       imageString = await ref.getDownloadURL();

      setState(() {
        imageUrl = imageString;
      });

      for (int i = 0; i < widget.membersList.length; i++) {
        String uid = widget.membersList[i]['uid'];

        await _firestore
            .collection('users')
            .doc(uid)
            .collection('groups')
            .doc(groupId)
            .set({
          "name": _groupName.text,
          "id": groupId,
          'url': imageString
        });
      }
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


//