import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BodyLogin extends StatefulWidget {
  const BodyLogin({super.key});

  @override
  State<BodyLogin> createState() => _BodyLogin();
}

class _BodyLogin extends State<BodyLogin> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  double height = 0;
  double width = 0;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
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
        Image.asset(
          'assets/images/logo2.png',
          height: 200,
          width: 200,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              const Text(
                'เข้าสู่ระบบ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.mail,
                      color: Color.fromARGB(255, 124, 124, 124)),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 241, 241, 241),
                  hintText: 'EMAIL',
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                obscureText: true,
                buildCounter: (BuildContext context,
                        {int? currentLength,
                        int? maxLength,
                        bool? isFocused}) =>
                    null,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.key,
                      color: Color.fromARGB(255, 124, 124, 124)),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 241, 241, 241),
                  hintText: 'PASSWORD',
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(160, 10, 20, 10),
                child: Text(
                  'forgot Password',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const MapPage()),
                  // );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFFF914D), // สีพื้นหลังเริ่มต้น
                  minimumSize: const Size(400, 50), // ขนาดเริ่มต้น
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'เข้าสู่ระบบ',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'or Login using social Media',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: Image.asset(
                      'assets/images/google.png',
                      height: 30,
                      width: 29,
                    ),
                    onTap: () {
                      // โค้ดที่ต้องการให้ทำงานเมื่อคลิกรูป
                    },
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  GestureDetector(
                    child: Image.asset(
                      'assets/images/facebook.png',
                      height: 30,
                      width: 29,
                    ),
                    onTap: () {
                      // โค้ดที่ต้องการให้ทำงานเมื่อคลิกรูป
                    },
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  GestureDetector(
                    child: Image.asset(
                      'assets/images/line.png',
                      height: 30,
                      width: 29,
                    ),
                    onTap: () {
                      // โค้ดที่ต้องการให้ทำงานเมื่อคลิกรูป
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
