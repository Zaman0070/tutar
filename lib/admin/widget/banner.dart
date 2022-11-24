import 'dart:math';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:tutor_app/services/firbaseservice.dart';
import 'dart:io';

class Banners extends StatefulWidget {
  const Banners({Key? key}) : super(key: key);

  @override
  State<Banners> createState() => _BannersState();
}

class _BannersState extends State<Banners> {
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
  FirebaseServices services =FirebaseServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text('Banner',  style: GoogleFonts.poppins(
          textStyle: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black),
        )),
      ),
      body: Column(
        children: [
          FutureBuilder<QuerySnapshot>(
              future: services.banner.get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.data == null) {
                  return Container();
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.blue),
                      ));
                }
                return  ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: snapshot.data!.size,
                    itemBuilder:
                        (BuildContext context, int index) {
                      var data = snapshot.data!.docs[index];
                      return Stack(
                        children: [

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 20),
                            child: Container(
                              height: 10.h,
                              width: 100.w,
                              decoration: BoxDecoration(
                                color: const Color(0xffF1D5D8),
                                borderRadius: BorderRadius.circular(10),
                                image:DecorationImage(
                                    image: NetworkImage(data['url'],),fit: BoxFit.fitWidth

                          ),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black12,
                                      spreadRadius: 1,
                                      offset: Offset(3, 3),
                                      blurRadius: 10)
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            right:5,
                            top:-4,
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
                                                          data.reference.delete();
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
                                }, icon:  Icon(Icons.delete,color: Colors.grey[700],size: 30,)),
                          ),
                        ],
                      );
                    }
                );
              }
          ),
          InkWell(
            onTap: (){
              bottomSheet();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                height: 10.h,
                width: 100.w,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 1,
                        offset: Offset(3, 3),
                        blurRadius: 10)
                  ],
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: (_image !=null)?Image.file(File(
                      _image!.path,),
                      fit: BoxFit.fill,
                    ):const Icon(Icons.add,size: 50,)),
              ),
            ),
          )


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
      var imageString = await ref.getDownloadURL();

      setState(() {
        imageUrl = imageString;
      });

      await services.banner
          .doc()
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
