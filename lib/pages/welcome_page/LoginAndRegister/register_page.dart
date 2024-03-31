import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../home_page/homepage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cfpasswordController = TextEditingController();
  double height = 0;
  double width = 0;
  final textFieldFocusNode = FocusNode();
  final textFieldFocusNode2 = FocusNode();
  bool _obscured = true;
  bool _obscured2 = true;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus) {
        return; // If focus is on text field, dont unfocus
      }
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  void _toggleObscured2() {
    setState(() {
      _obscured2 = !_obscured2;
      if (textFieldFocusNode2.hasPrimaryFocus) {
        return; // If focus is on text field, dont unfocus
      }
      textFieldFocusNode2.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future signUp() async {
    // final isValid = formKey.currentState!.validate();
    if (formKey.currentState!.validate()) {
      log("singnup");
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim());
        await FirebaseAuth.instance.currentUser!
            .updateEmail(_emailController.text.trim());
        await FirebaseFirestore.instance
            .collection('MeowMeowCat')
            .doc('Users')
            .collection(_emailController.text.trim())
            .doc('Profile')
            .set({
          'email': _emailController.text.trim(),
          'first_name': _firstnameController.text.trim(),
          'last_name': _lastnameController.text.trim(),
          'imgProfile': 'NoImg'
        }).then((value) => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomePage()),
                (Route<dynamic> route) => false));
      } on FirebaseAuthException catch (e) {
        debugPrint(e.toString());
        if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("มีอีเมลนี้แล้ว กรุณาใช้อีเมลอื่น")));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          bottomOpacity: 0.0,
          elevation: 0.0,
          iconTheme: const IconThemeData(color: Color(0xFFFF914D)),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: SizedBox(
                // height: size.height,
                // width: size.width,
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
      ),
    );
  }

  Widget bodyRegister() {
    // var logoProvider = context.read<LogoProvider>();
    return Column(children: [
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          "ลงทะเบียนเข้าสู่ระบบ",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                            borderSide:
                                BorderSide(width: 2, color: Colors.grey),
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
                            borderSide:
                                BorderSide(width: 2, color: Colors.grey),
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
                            borderSide:
                                BorderSide(width: 2, color: Colors.grey),
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
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _obscured,
                        focusNode: textFieldFocusNode,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          suffixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                            child: GestureDetector(
                              onTap: _toggleObscured,
                              child: Icon(
                                _obscured
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                                size: 24,
                              ),
                            ),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          isDense: true,
                          counterText: ' ',
                          hintText: 'รหัสผ่าน',
                          enabledBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.grey),
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
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _obscured2,
                        focusNode: textFieldFocusNode2,
                        controller: _cfpasswordController,
                        decoration: InputDecoration(
                          suffixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                            child: GestureDetector(
                              onTap: _toggleObscured2,
                              child: Icon(
                                _obscured2
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                                size: 24,
                              ),
                            ),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          isDense: true,
                          counterText: ' ',
                          hintText: 'ยืนยันรหัสผ่าน',
                          enabledBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.grey),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "กรุณากรอกยืนยันรหัสผ่าน";
                          } else if (value != _passwordController.text) {
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
        height: 30,
      ),
      Container(
        height: 50,
        width: 250,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xFFFFA500),
            Color(0xFFFF6347),
          ]),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: ElevatedButton(
          onPressed: () {
            log("signUp");
            signUp();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          child: const Text(
            "สมัครสมาชิก",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ]);
  }
}
