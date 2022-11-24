
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tutor_app/Provider/user_provider.dart';
import 'package:tutor_app/services/firbaseservice.dart';

import 'create_group/add_members.dart';
import 'group_chat_room.dart';


class GroupChatHomeScreen extends StatefulWidget {
  int? index;
   GroupChatHomeScreen({Key? key,required this.index}) : super(key: key);

  @override
  _GroupChatHomeScreenState createState() => _GroupChatHomeScreenState();
}

class _GroupChatHomeScreenState extends State<GroupChatHomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseServices services = FirebaseServices();
  bool isLoading = true;

  List groupList = [];

  var groupId ;
  List lastMsg=[];

  @override
  void initState() {
    super.initState();
    getAvailableGroups();
    getLastChat();
  }

  void getAvailableGroups() async {
    String uid =services.user!.uid ;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('groups')
        .get()
        .then((value) {
      setState(() {
        groupList = value.docs;
        isLoading = false;
      });
      for (var element in value.docs) {
        groupId= element['id']  ;
      }
      print('groupId:${groupId}');

    });
  }
  double total=0.0;


  void getLastChat() async {
    await _firestore
        .collection('groups')
        .get()
        .then((chatMap) {
      setState(() {
        lastMsg = chatMap.docs;
        isLoading = false;
      });
      print(lastMsg);
    });
  }


  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title:const Text('Chat',style: TextStyle(color: Colors.black),),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: isLoading == true
          ? Container(
              height: size.height,
              width: size.width,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: groupList.length,
              itemBuilder: (context, index) {
                return FutureBuilder<QuerySnapshot>(
                  future: _firestore.collection('groups').doc(groupList[index]['id']).collection('chats').get(),
                  builder: (context, snapshot) {
                    if(snapshot.data==null){
                      return const CircularProgressIndicator(
                        color: Colors.white,
                      );
                    }
                    var docs = snapshot.data!.docs.length;
                    return Column(
                      children: [
                        ListTile(
                          onLongPress: (){
                         widget.index==3?   showDialog(
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
                                                    _firestore
                                                        .collection('users')
                                                        .doc(services.user!.uid)
                                                        .collection('groups').doc(groupList[index]['id']).get().then((value) {
                                                      setState(() {
                                                        value.reference.delete();
                                                      });
                                                    });
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
                          onTap: (){

                            _firestore.collection('groups').doc(groupList[index]['id']).update(
                                {
                                  'read':true,
                                });

                            Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => GroupChatRoom(
                                docs: docs.toDouble(),
                                index: widget.index!,
                                groupUrl: groupList[index]['url'],
                                groupName: groupList[index]['name'],
                                groupChatId: groupList[index]['id'],
                              ),
                            ),
                          );
              },
                          leading:Container(
                          height: 6.5.h,
                          width: 6.5.h,
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    ),
                            child:     CachedNetworkImage(
                              imageBuilder: (context,imageProvider)=>CircleAvatar(
                                radius: 25,
                                backgroundImage: imageProvider,
                              ),
                              cacheManager: CacheManager(Config(
                                  'customCacheKey',
                                  stalePeriod: const Duration(days: 500)

                              )),
                              imageUrl: groupList[index]['url'],

                            ),
                          ),

                          title: Text(groupList[index]['name']),
                         // subtitle:Text(lastMsg[index]['lastMsg'],style: TextStyle(fontWeight: lastMsg[index]['read']==false? FontWeight.bold:FontWeight.normal,color: Colors.green),),
                          subtitle:  FutureBuilder<DocumentSnapshot>(
                              future: _firestore.collection('groups').doc(groupList[index]['id']).get(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.data == null) {
                                  return Container();
                                }

                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(Colors.white),
                                      ));
                                }
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(snapshot.data!['lastMsg'],style: TextStyle(fontWeight: snapshot.data!['read']==false && snapshot.data!['senderId'] !=services.user!.uid? FontWeight.bold:FontWeight.normal,),),
                                    snapshot.data!['read']==false&&snapshot.data!['senderId'] !=services.user!.uid? CircleAvatar(radius: 5,):Container(),
                                  ],
                                );
                              }),


                        ),
                      Divider(),
                      ],
                    );
                  }
                );
              },
            ),
      floatingActionButton: widget.index==3?FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const AddMembersInGroup(),
          ),
        ),
        tooltip: "Create Group",
        child:  const Icon(Icons.group),
      ):Container(),
    );
  }
}
