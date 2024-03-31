import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../home_page/homepage.dart';
import '../../provider/logo_provider.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  double height = 0;
  double width = 0;
  final textFieldFocusNode = FocusNode();
  bool _obscured = true;

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

  Future signIn() async {
    if (formKey.currentState!.validate()) {
      try {
        log("Login!!!!!!!!!!");
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim())
            .then((value) => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomePage()),
                (Route<dynamic> route) => false));
      } on FirebaseAuthException catch (e) {
        debugPrint(e.toString());
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("ไม่มีอีเมลนี้")));
        } else if (e.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("รหัสผ่านไม่ถูกต้อง")));
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
          child: SingleChildScrollView(
            // physics: const BouncingScrollPhysics(),
            child: bodyLoging(),
          ),
        ),
      ),
    );
  }

  Widget bodyLoging() {
    var logoProvider = context.read<LogoProvider>();
    return Column(children: [
      // Image.network(
      //   logoProvider.logo[0]['imgLogo'],
      //   height: 200,
      //   width: 200,
      // ),
      const Text(
        "เข้าสู่ระบบ",
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Container(
          height: 420,
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
                    style: const TextStyle(fontSize: 18),
                    controller: _emailController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                      prefixIcon: const Icon(Icons.mail,
                          color: Color.fromARGB(255, 124, 124, 124)),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 241, 241, 241),
                      hintText: 'อีเมล',
                      counterText: ' ',
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
                  child: SizedBox(
                    height: 100,
                    width: 400,
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: _obscured,
                      focusNode: textFieldFocusNode,
                      style: const TextStyle(fontSize: 18),
                      controller: _passwordController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
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
                        prefixIcon: const Icon(Icons.lock_rounded,
                            color: Color.fromARGB(255, 124, 124, 124)),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 241, 241, 241),
                        hintText: 'รหัสผ่าน',
                        counterText: ' ',
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
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        debugPrint('ลืม');
                      },
                      child: const Text(
                        'ลืมรหัสผ่าน ?',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
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
                      log("singin");
                      signIn();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: const Text(
                      "เข้าสู่ระบบ",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'ยังไม่เป็นสมาชิก? ',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage()),
                        );
                      },
                      child: const Text(
                        'สมัครสมาชิก',
                        style:
                            TextStyle(fontSize: 16, color: Color(0xFFFF6347)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
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
