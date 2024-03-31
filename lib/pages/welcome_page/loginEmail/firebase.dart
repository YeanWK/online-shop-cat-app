import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  static saveUser(String name, email, uidemail) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uidemail)
        .set({'email': email, 'name': name});
  }
}
