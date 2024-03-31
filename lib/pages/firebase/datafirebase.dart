import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'readdata.dart';

class DataFirebase extends StatefulWidget {
  const DataFirebase({super.key});

  @override
  State<DataFirebase> createState() => _DataFirebaseState();
}

class _DataFirebaseState extends State<DataFirebase> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    Future<void> addUser() {
      String name = nameController.text.trim();
      // Call the user's CollectionReference to add a new user
      return users
          .add({"name": name})
          .then((value) => debugPrint("User Added"))
          .catchError((error) => debugPrint("Failed to add user: $error"));
    }

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 300,
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(255, 85, 84, 84),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            TextButton(
              onPressed: addUser,
              child: const Text(
                "Add User",
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReadData()),
                );
              },
              child: const Text(
                "Read User",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
