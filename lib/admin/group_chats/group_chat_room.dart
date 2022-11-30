import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:tutor_app/Provider/user_provider.dart';
import 'package:tutor_app/admin/widget/pdf_view.dart';
import 'package:tutor_app/services/firbaseservice.dart';
import 'package:uuid/uuid.dart';
import 'group_info.dart';

class GroupChatRoom extends StatefulWidget {
  final String groupChatId, groupName, groupUrl;
  final int index;
  final double docs;


  const GroupChatRoom(
      {required this.groupName,
        required this.index,
        required this.docs,
      required this.groupChatId,
      Key? key,
      required this.groupUrl})
      : super(key: key);

  @override
  State<GroupChatRoom> createState() => _GroupChatRoomState();
}

class _GroupChatRoomState extends State<GroupChatRoom> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final TextEditingController _message = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseServices services = FirebaseServices();

  ScrollController _controller = ScrollController();
  File? file;
  var name;
  bool isLoading = false;
  var userMap = '';
  var status = '';
  var url = '';
  var scndName = '';
  var type = '';

  var receiverId = '';
  var receiverId1 = '';
  var receiverId2 = '';


  List<String> msg = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGroupDetails();
    getmessage();
    getReceiverId();
  }

  Future getReceiverId() async {
    await _firestore
        .collection('groups')
        .doc(widget.groupChatId)
        .get()
        .then((chatMap) {
     setState(() {
       receiverId = chatMap['members'][0]['uid'];
       receiverId1 = chatMap['members'][1]['uid'];
       receiverId2 =chatMap['members'][2]['uid'];
     });
      print('gggggggggggggggggggggg$receiverId1');
      isLoading = false;
      setState(() {});
    });
  }


  Future getmessage() async {
    await _firestore
        .collection('groups')
        .doc(widget.groupChatId)
        .collection('chats')
        .where('type', isEqualTo: 'file')
        .get()
        .then((chatMap) {
      for (var element in chatMap.docs) {
        msg.add(element['message']);
      }
      print(msg);
      isLoading = false;
      setState(() {});
    });
  }

  Future getGroupDetails() async {
    await _firestore
        .collection('users')
        .doc(services.user!.uid)
        .get()
        .then((chatMap) {
      userMap = chatMap['name'];
      url = chatMap['url'];
      type = chatMap['type'];
      scndName = chatMap['secondName'];


      print(userMap);
      print(url);
      print(scndName);
      isLoading = false;
      setState(() {});
    });
  }

  File? imageFile;

  Future getImage() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }

  getfile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc'],
    );

    if (result != null) {
      File c = File(result.files.single.path.toString());
      setState(() {
        file = c;
        name = result.names.toString();
      });
      uploadFile();
    }
  }

  Future uploadImage() async {
    String fileName = const Uuid().v1();
    int status = 1;
if(services.user!.uid == receiverId) {
  await _firestore
      .collection('groups')
      .doc(widget.groupChatId)
      .collection('chats')
      .doc(fileName)
      .set({
    "sendId": services.user!.uid,
    "message": "",
    "sendBy": userMap,
    'url': url,
    'receiverId': receiverId1,
    'receiverId1': receiverId2,
    'secondName': scndName,
    'senderType': type,
    "type": "img",
    "time": DateTime
        .now()
        .microsecondsSinceEpoch,
  });
}else if(services.user!.uid == receiverId1){
  await _firestore
      .collection('groups')
      .doc(widget.groupChatId)
      .collection('chats')
      .doc(fileName)
      .set({
    "sendId": services.user!.uid,
    "message": "",
    "sendBy": userMap,
    'url': url,
    'receiverId': receiverId,
    'receiverId1': receiverId2,
    'secondName': scndName,
    'senderType': type,
    "type": "img",
    "time": DateTime
        .now()
        .microsecondsSinceEpoch,
  });
}
else{
  await _firestore
      .collection('groups')
      .doc(widget.groupChatId)
      .collection('chats')
      .doc(fileName)
      .set({
    "sendId": services.user!.uid,
    "message": "",
    "sendBy": userMap,
    'url': url,
    'receiverId': receiverId,
    'receiverId1': receiverId1,
    'secondName': scndName,
    'senderType': type,
    "type": "img",
    "time": DateTime
        .now()
        .microsecondsSinceEpoch,
  });
}
    var ref =
        FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");

    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      await _firestore
          .collection('groups')
          .doc(widget.groupChatId)
          .collection('chats')
          .doc(fileName)
          .delete();

      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();

      await _firestore
          .collection('groups')
          .doc(widget.groupChatId)
          .collection('chats')
          .doc(fileName)
          .update({"message": imageUrl});

      print(imageUrl);
    }
  }

  Future uploadFile() async {
    String fileName = const Uuid().v1();
    int status = 1;
if(services.user!.uid == receiverId) {
  await _firestore
      .collection('groups')
      .doc(widget.groupChatId)
      .collection('chats')
      .doc(fileName)
      .set({
    "sendId": services.user!.uid,
    "message": "",
    "sendBy": userMap,
    'url': url,
    'receiverId': receiverId1,
    'receiverId1': receiverId2,
    'secondName': scndName,
    'senderType': type,
    "type": "file",
    'name': name,
    "time": DateTime
        .now()
        .microsecondsSinceEpoch,
  });
}else if(services.user!.uid == receiverId1){
  await _firestore
      .collection('groups')
      .doc(widget.groupChatId)
      .collection('chats')
      .doc(fileName)
      .set({
    "sendId": services.user!.uid,
    "message": "",
    "sendBy": userMap,
    'url': url,
    'receiverId': receiverId,
    'receiverId1': receiverId2,
    'secondName': scndName,
    'senderType': type,
    "type": "file",
    'name': name,
    "time": DateTime
        .now()
        .microsecondsSinceEpoch,
  });
}
else{
  await _firestore
      .collection('groups')
      .doc(widget.groupChatId)
      .collection('chats')
      .doc(fileName)
      .set({
    "sendId": services.user!.uid,
    "message": "",
    "sendBy": userMap,
    'url': url,
    'receiverId': receiverId,
    'receiverId1': receiverId1,
    'secondName': scndName,
    'senderType': type,
    "type": "file",
    'name': name,
    "time": DateTime
        .now()
        .microsecondsSinceEpoch,
  });
}
    var ref = FirebaseStorage.instance.ref().child('file').child("/$name");

    var uploadTask = await ref.putFile(file!).catchError((error) async {
      await _firestore
          .collection('groups')
          .doc(widget.groupChatId)
          .collection('chats')
          .doc(fileName)
          .delete();

      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();

      await _firestore
          .collection('groups')
          .doc(widget.groupChatId)
          .collection('chats')
          .doc(fileName)
          .update({"message": imageUrl});

      print(imageUrl);
    }
  }

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      if(services.user!.uid == receiverId) {
        Map<String, dynamic> chatData = {
          'sendId': services.user!.uid,
          "sendBy": userMap,
          "message": _message.text,
          'url': url,
          'receiverId': receiverId1,
          'receiverId1': receiverId2,
          'secondName': scndName,
          'senderType': type,
          "type": "text",
          "time": DateTime
              .now()
              .microsecondsSinceEpoch,
        };
        _firestore.collection('groups').doc(widget.groupChatId).update({
          'read': false,
          'lastMsg': _message.text,
          'senderId': services.user!.uid,
        });
        _message.clear();
        await _firestore
            .collection('groups')
            .doc(widget.groupChatId)
            .collection('chats')
            .add(chatData);
      }
      else if(services.user!.uid == receiverId1){
        Map<String, dynamic> chatData = {
          'sendId': services.user!.uid,
          "sendBy": userMap,
          "message": _message.text,
          'url': url,
          'receiverId': receiverId,
          'receiverId1': receiverId2,
          'secondName': scndName,
          'senderType': type,
          "type": "text",
          "time": DateTime
              .now()
              .microsecondsSinceEpoch,
        };
        _firestore.collection('groups').doc(widget.groupChatId).update({
          'read': false,
          'lastMsg': _message.text,
          'senderId': services.user!.uid,
        });
        _message.clear();
        await _firestore
            .collection('groups')
            .doc(widget.groupChatId)
            .collection('chats')
            .add(chatData);
      }
      else{
        Map<String, dynamic> chatData = {
          'sendId': services.user!.uid,
          "sendBy": userMap,
          "message": _message.text,
          'url': url,
          'receiverId': receiverId,
          'receiverId1': receiverId1,
          'secondName': scndName,
          'senderType': type,
          "type": "text",
          "time": DateTime
              .now()
              .microsecondsSinceEpoch,
        };
        _firestore.collection('groups').doc(widget.groupChatId).update({
          'read': false,
          'lastMsg': _message.text,
          'senderId': services.user!.uid,
        });
        _message.clear();
        await _firestore
            .collection('groups')
            .doc(widget.groupChatId)
            .collection('chats')
            .add(chatData);
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        toolbarHeight: 70,
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        title: Row(
          children: [
            CachedNetworkImage(
              imageBuilder: (context, imageProvider) => CircleAvatar(
                radius: 25,
                backgroundImage: imageProvider,
              ),
              cacheManager: CacheManager(Config('customCacheKey',
                  stalePeriod: const Duration(days: 500))),
              imageUrl: widget.groupUrl,
            ),
            SizedBox(
              width: 4.w,
            ),
            SizedBox(
              width: 40.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.groupName,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                          color: Colors.black),
                    ),
                  ),
                  Text(
                    'group',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          letterSpacing: 1.1,
                          fontWeight: FontWeight.w400,
                          fontSize: 8.sp,
                          color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => GroupInfo(
                        groupUrl: widget.groupUrl,
                        groupName: widget.groupName,
                        groupId: widget.groupChatId,
                      ),
                    ),
                  ),
              icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width:  MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('groups')
                    .doc(widget.groupChatId)
                    .collection('chats')
                    .orderBy('time')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      reverse:  true,
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      controller: _controller,
                      itemCount: snapshot.data!.docs.length  ,
                      itemBuilder: (context, index) {
                        // if (index == snapshot.data!.docs.length) {
                        //   return Container(
                        //     height: 70,
                        //   );
                        // }

                        Map<String, dynamic> chatMap =
                            snapshot.data!.docs[snapshot.data!.docs.length - 1 -index].data()
                                as Map<String, dynamic>;

                        return InkWell(
                            onLongPress: () {
                           widget.index==3?   showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
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
                                                      snapshot.data!.docs[snapshot.data!.docs.length - 1 -index]
                                                          .reference
                                                          .delete();
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
                                  }):null;
                            },
                            child: messageTile(size, chatMap));
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Container(
              height: size.height / 10,
              width: size.width,
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: size.height / 10,
                width: size.width / 1.1,

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: size.height / 17,
                      width: size.width / 1.3,
                      child: TextFormField(
                        onTap: (){
                          _controller.jumpTo(0);
                        },
                        controller: _message,
                        decoration: InputDecoration(
                            contentPadding:  const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            suffixIcon: IconButton(
                              onPressed: (){
                                onSendMessage();
                                _controller.jumpTo(0);
                              },
                              icon: Image.asset(
                                'assets/img.png',
                                height: 26,
                              ),
                            ),
                            hintText: "Send Message",
                            border: InputBorder.none),
                      ),
                    ),
                    SpeedDial(
                      backgroundColor: Colors.grey.shade100,
                      iconTheme: const IconThemeData(color: Colors.black),
                      icon: Icons.attach_file,
                      elevation: 0,
                      mini: true,
                      children: [
                        SpeedDialChild(
                            child: const Icon(
                              Icons.image,
                              color: Colors.white,
                            ),
                            elevation: 0,
                            backgroundColor: Colors.indigo.shade400,
                            onTap: getImage),
                        SpeedDialChild(
                            child: const Icon(
                              Icons.file_present_rounded,
                              color: Colors.white,
                            ),
                            elevation: 0,
                            backgroundColor: Colors.purple.shade400,
                            onTap: getfile)
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messageTile(Size size, Map<String, dynamic> chatMap) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    String lastChatDate;
    var date = DateFormat('yyyy-MM-dd')
        .format(DateTime.fromMicrosecondsSinceEpoch(chatMap['time']));
    var today = DateFormat('yyyy-MM-dd').format(
        DateTime.fromMicrosecondsSinceEpoch(
            DateTime.now().microsecondsSinceEpoch));
    if (date == today) {
      lastChatDate = DateFormat('hh:mm')
          .format(DateTime.fromMicrosecondsSinceEpoch(chatMap['time']));
    } else {
      lastChatDate = date.toString();
    }
    return Builder(builder: (_) {
      if (chatMap['type'] == "text") {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: chatMap['sendId'] == services.user!.uid
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  chatMap['sendId'] != services.user!.uid
                      ? Stack(
                        children: [
                          CachedNetworkImage(
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                radius: 20,
                                backgroundImage: imageProvider,
                              ),
                              cacheManager: CacheManager(Config('customCacheKey',
                                  stalePeriod: const Duration(days: 500))),
                              imageUrl: chatMap['url'],
                            ),
                           Positioned(
                            bottom: 0,
                            right: 2,
                            child: StreamBuilder<DocumentSnapshot>(
                              stream: _firestore.collection('users').doc(chatMap['sendId']).snapshots(),
                                builder: (context,snapshot){
                                if(snapshot.data==null){
                                  return Container();
                                }
                               var data = snapshot.data;
                                    return data!['status']== "Offline" ?  const CircleAvatar(radius: 5,backgroundColor: Colors.grey,)
                                        : CircleAvatar(radius: 5,backgroundColor: Colors.green.shade400,)
                                    ;
                                }
                            ),
                          )
                        ],
                      )
                      : Container(),
                  SizedBox(
                    width: 1.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      chatMap['sendId'] != services.user!.uid?
                      RichText(
                        text: TextSpan(
                            text: chatMap['senderType']=='admin' ? "${chatMap['sendBy']}":"${chatMap['sendBy']} ${chatMap['secondName']} ",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey),
                            ),
                            children: [
                              TextSpan(
                                text:chatMap['senderType']=='admin' ? "(Mod)": chatMap['senderType']=='faculty'?"(Faculty)":"(Student)",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                      color:chatMap['senderType']=='admin' ? Colors.red.shade800:chatMap['senderType']=='faculty' ?Colors.yellow.shade900:Colors.blue.shade800),
                                ),
                              )
                            ]),
                      )
                      //     ? Text(chatMap['senderType']=='admin'?
                      //         "${chatMap['sendBy']}(𝗠𝗼𝗱)":
                      // "${chatMap['sendBy']}${chatMap['secondName']}(${chatMap['senderType']})",
                      //         style:
                      //             const TextStyle(fontSize: 13, color: Colors.grey),
                      //       )
                          : Column(),
                      ChatBubble(
                        elevation: 0.5,
                        alignment: chatMap['sendId'] == services.user!.uid
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        backGroundColor: chatMap['sendId'] == services.user!.uid
                            ? const Color(0xff1C80F9)
                            : Colors.white,
                        clipper: ChatBubbleClipper5(
                            type: chatMap['sendId'] == services.user!.uid
                                ? BubbleType.sendBubble
                                : BubbleType.receiverBubble),
                        child: Container(
                          constraints: chatMap['sendId'] == services.user!.uid
                              ? BoxConstraints(maxWidth: 85.w)
                              : BoxConstraints(maxWidth: 75.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                chatMap['message'],
                                style: TextStyle(
                                    color:
                                        chatMap['sendId'] == services.user!.uid
                                            ? Colors.white
                                            : Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 0.5.h,
              ),
              Align(
                alignment: chatMap['sendId'] == services.user!.uid
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Text(
                  lastChatDate,
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ],
          ),
        );

      } else if (chatMap['type'] == "img") {
        return InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ShowImage(
                imageUrl: chatMap['message'],
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: Container(
              margin: const EdgeInsets.all(1),
              height: size.height / 2.5,
              width: size.width / 2,
              alignment: chatMap['message'] != "" ? null : Alignment.center,
              child: ChatBubble(
                alignment: chatMap['sendId'] == services.user!.uid
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                backGroundColor: chatMap['sendId'] == services.user!.uid
                    ? const Color(0xff1C80F9)
                    : Colors.white,
                clipper: ChatBubbleClipper5(
                    type: chatMap['sendId'] == services.user!.uid
                        ? BubbleType.sendBubble
                        : BubbleType.receiverBubble),
                child: chatMap['message'] != ""
                    ? CachedNetworkImage(
                        cacheManager: CacheManager(Config('customCacheKey',
                            stalePeriod: const Duration(days: 500))),
                        imageUrl: chatMap['message'],
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
          ),
        );
      } else if (chatMap['type'] == "file") {
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => PdfView(
                          url: chatMap['message'],
                        )));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: chatMap['sendId'] == services.user!.uid
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    chatMap['sendId'] != services.user!.uid
                        ? Stack(
                      children: [
                        CachedNetworkImage(
                          imageBuilder: (context, imageProvider) =>
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: imageProvider,
                              ),
                          cacheManager: CacheManager(Config('customCacheKey',
                              stalePeriod: const Duration(days: 500))),
                          imageUrl: chatMap['url'],
                        ),
                        Positioned(
                          bottom: 0,
                          right: 2,
                          child: StreamBuilder<DocumentSnapshot>(
                              stream: _firestore.collection('users').doc(chatMap['sendId']).snapshots(),
                              builder: (context,snapshot){
                                if(snapshot.data==null){
                                  return Container();
                                }
                                var data = snapshot.data;
                                return data!['status']== "Offline" ?  const CircleAvatar(radius: 5,backgroundColor: Colors.grey,)
                                    : CircleAvatar(radius: 5,backgroundColor: Colors.green.shade400,)
                                ;
                              }
                          ),
                        )
                      ],
                    )
                        : Container(),
                    SizedBox(
                      width: 1.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        chatMap['sendId'] != services.user!.uid?
                        RichText(
                          text: TextSpan(
                              text: chatMap['senderType']=='admin' ? "${chatMap['sendBy']}":"${chatMap['sendBy']} ${chatMap['secondName']} ",
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey),
                              ),
                              children: [
                                TextSpan(
                                  text:chatMap['senderType']=='admin' ? "(Mod)": chatMap['senderType']=='faculty'?"(Faculty)":"(Student)",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                        color:chatMap['senderType']=='admin' ? Colors.red.shade800:chatMap['senderType']=='faculty' ?Colors.yellow.shade900:Colors.blue.shade800),
                                  ),
                                )
                              ]),
                        )
                            : Column(),
                        ChatBubble(
                          alignment: chatMap['sendId'] == services.user!.uid
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          backGroundColor: chatMap['sendId'] == services.user!.uid
                              ? const Color(0xff1C80F9)
                              : Colors.white,
                          clipper: ChatBubbleClipper5(
                              type: chatMap['sendId'] == services.user!.uid
                                  ? BubbleType.sendBubble
                                  : BubbleType.receiverBubble),
                          child: chatMap['message'] != ""
                              ? Row(
                            mainAxisSize:MainAxisSize.min ,
                            children: [
                              Icon(Icons.file_copy_sharp,color: Colors.grey.shade400,),
                              SizedBox(width: 1.w,),
                              Text(
                                chatMap['name'],
                                style: TextStyle(
                                    color: chatMap['sendId'] == services.user!.uid
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ],
                          )
                              : const CircularProgressIndicator(),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 0.5.h,
                ),
                Align(
                  alignment: chatMap['sendId'] == services.user!.uid
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Text(
                    lastChatDate,
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (chatMap['type'] == "notify") {
        return Container(
          width: size.width,
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(0),
              ),
              color: Colors.black38,
            ),
            child: Text(
              chatMap['message'],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        );
      } else {
        return const SizedBox();
      }
    });
  }
}

class ShowImage extends StatelessWidget {
  final String imageUrl;

  const ShowImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: CachedNetworkImage(
          cacheManager: CacheManager(
              Config('customCacheKey', stalePeriod: const Duration(days: 500))),
          imageUrl: imageUrl,
        ),
      ),
    );
  }
}
