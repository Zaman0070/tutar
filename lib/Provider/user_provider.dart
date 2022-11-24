import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {

  DocumentSnapshot? studentData;
  QuerySnapshot? riderDetails;
  List<String> urlList = [];

  getImage(url) {
    urlList.add(url);
    notifyListeners();
  }

  getStudentDetails(details) {
    studentData = details;
    notifyListeners();
  }

  riderGetData(details){
    riderDetails = details;
    notifyListeners();
  }
}
