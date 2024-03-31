import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class RegisterPage2 extends StatefulWidget {
  const RegisterPage2({super.key});

  @override
  State<RegisterPage2> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage2> {
  final formKey = GlobalKey<FormState>();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cfpasswordController = TextEditingController();
  double height = 0;
  double width = 0;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    log("singnup");
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
      addUser(
        _firstnameController.text,
        _lastnameController.text,
        _emailController.text,
      );
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("มีอีเมลนี้แล้ว กรุณาใช้อีเมลอื่น")));
    }
  }

  Future<void> addUser(
    String firstname,
    String lastname,
    String email,
  ) async {
    try {
      Map<String, dynamic> userData = {
        'first_name': firstname,
        'last_name': lastname,
        'email': email,
        'imgProfile': 'NoImg'
      };

      await FirebaseFirestore.instance
          .collection('MeowMeowCat')
          .doc('Users')
          .collection(email)
          .doc('Profile')
          .set(userData);

      debugPrint('User added successfully');
    } catch (error) {
      debugPrint('Error adding user: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              height: size.height,
              width: size.height,
              child: Column(
                children: [
                  // BodyRegister(),
                  bodyRegister()
                  //loginBody(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget bodyRegister() {
    // var logoProvider = context.read<LogoProvider>();
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  top: 10,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFFFF914D),
                      size: 32,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
              // logoProvider.logo.isEmpty
              //     ? imgLogo()
              //     : Image.network(
              //         logoProvider.logo[0]['imgLogo'],
              //         height: 200,
              //         width: 200,
              //       ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  "ลงทะเบียนเข้าสู่ระบบ",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Container(
                  height: 560,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 197, 197, 197),
                      width: 2.0,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 22,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ชื่อ*',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                controller: _firstnameController,
                                decoration: const InputDecoration(
                                  counterText: ' ',
                                  hintText: 'ชื่อ',
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.grey),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "กรุณากรอกชื่อ";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'นามสกุล*',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                              TextFormField(
                                controller: _lastnameController,
                                decoration: const InputDecoration(
                                  counterText: ' ',
                                  hintText: 'นามสกุล',
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.grey),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "กรุณากรอกนามสกุล";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'อีเมล*',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                              TextFormField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  counterText: ' ',
                                  hintText: 'อีเมล',
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.grey),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "กรุณากรอกอีเมล";
                                  } else if (!value.contains("@")) {
                                    return "กรุณากรอกอีเมลในรูปแบบที่ถูกต้อง";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'รหัสผ่าน*',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                              TextFormField(
                                controller: _passwordController,
                                decoration: const InputDecoration(
                                  counterText: ' ',
                                  hintText: 'รหัสผ่าน',
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.grey),
                                  ),
                                ),
                                validator: (value) {
                                  // RegExp regex = RegExp(
                                  //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                                  if (value!.isEmpty) {
                                    return "กรุณากรอกรหัสผ่าน";
                                  } else if (value.length < 6) {
                                    return "รหัสผ่านต้องมากกว่า 6 ตัว";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ยืนยันรหัสผ่าน*',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                              TextFormField(
                                controller: _cfpasswordController,
                                decoration: const InputDecoration(
                                  counterText: ' ',
                                  hintText: 'ยืนยันรหัสผ่าน',
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.grey),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "กรุณากรอกยืนยันรหัสผ่าน";
                                  } else if (value !=
                                      _passwordController.text) {
                                    return "กรุณากรอกรหัสผ่านให้ตรงกัน";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  signUp();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFFF914D), // สีพื้นหลังเริ่มต้น
                  minimumSize: const Size(360, 50), // ขนาดเริ่มต้น
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'ลงทะเบียน',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ]);
          }
          return const Text('Something went wrong');
        });
  }
}

  // Widget imgLogo() {
  //   final Stream<QuerySnapshot> firestore = FirebaseFirestore.instance
  //       .collection('MeowMeowCat')
  //       .doc('Logo')
  //       .collection('Logo')
  //       .snapshots();
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: firestore,
  //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //       if (snapshot.hasError) {
  //         return const Text('Something went wrong');
  //       }

  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const CircularProgressIndicator();
  //       }
  //       if (snapshot.hasData) {
  //         final logo = snapshot.data!.docs
  //             .map((DocumentSnapshot document) =>
  //                 document.data() as Map<String, dynamic>)
  //             .toList();
  //         context.read<LogoProvider>().addLogo(logo);
  //         return Image.network(
  //           logo[0]['imgLogo'],
  //           height: 200,
  //           width: 200,
  //         );
  //       } else {
  //         return const Text('Something went wrong');
  //       }
  //     },
  //   );
  // }

