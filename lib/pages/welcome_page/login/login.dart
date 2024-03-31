import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../home_page/homepage.dart';

class LoginPage2 extends StatefulWidget {
  const LoginPage2({super.key});

  @override
  State<LoginPage2> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage2> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  double height = 0;
  double width = 0;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future signIn() async {
    try {
      log("hhhhhhhhhhh");
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
    } on FirebaseAuthException catch (e) {
      log("message");
      debugPrint(e.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("ไม่มีอีเมลนี้")));
    }
  }

  void navigateToHomePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          bottomOpacity: 0.0,
          elevation: 0.0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFFFF914D),
              size: 32,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: SizedBox(
            height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                bodyLoging(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bodyLoging() {
    return Column(children: [
      const Text(
        "เข้าสู่ระบบ",
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Container(
          height: 400,
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(255, 197, 197, 197),
              width: 2.0,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(30.0),
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
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.mail,
                          color: Color.fromARGB(255, 124, 124, 124)),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 241, 241, 241),
                      hintText: 'อีเมล',
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30),
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
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.key,
                          color: Color.fromARGB(255, 124, 124, 124)),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 241, 241, 241),
                      hintText: 'รหัสผ่าน',
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30),
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
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50,
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () {
                      log("singin");
                      signIn;
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFFF914D), // สีพื้นหลังเริ่มต้น

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'เข้าสู่ระบบ',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'หรือ',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50,
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFDB4437), // สีพื้นหลังเริ่มต้น

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          PhosphorIcon(
                            PhosphorIcons.googleLogo(),
                          ).icon,
                          size: 30,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          'เข้าสู่ระบบด้วยGoogle',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
    ]);
  }
}
