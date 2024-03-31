import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class UserProvider extends ChangeNotifier {
  List userdata = [];
  DocumentReference users = FirebaseFirestore.instance
      .collection('MeowMeowCat')
      .doc('Users')
      .collection(FirebaseAuth.instance.currentUser!.email.toString())
      .doc('Profile');
  void addListUser(List item) {
    userdata = item;
    log(userdata.toString());
  }

  void updateUser(String firstname, String lastname) {
    if (firstname.isNotEmpty && lastname.isNotEmpty) {
      users.update({"first_name": firstname, "last_name": lastname}).then(
          (value) {
        debugPrint("User Updated");
        userdata[0]['first_name'] = firstname;
        userdata[0]['last_name'] = lastname;
        notifyListeners();
      });
    }
  }

  void updateImg(String img) {
    if (img.isNotEmpty) {
      users.update({'imgProfile': img}).then((value) {
        debugPrint("User Updated");
        userdata[0]['imgProfile'] = img;

        notifyListeners();
      });
    }
  }

  void clearListUser() {
    userdata.clear();
  }
}
