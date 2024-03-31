import 'package:flutter/material.dart';

class BodyRegister extends StatefulWidget {
  const BodyRegister({super.key});

  @override
  State<BodyRegister> createState() => _BodyRegisterState();
}

class _BodyRegisterState extends State<BodyRegister> {
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
                height: 10,
              ),
              const Text(
                'ลงทะเบียนสมาชิก',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              TextField(
                obscureText: true,
                buildCounter: (BuildContext context,
                        {int? currentLength,
                        int? maxLength,
                        bool? isFocused}) =>
                    null,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person,
                      color: Color.fromARGB(255, 124, 124, 124)),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 241, 241, 241),
                  hintText: 'ชื่อ',
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
                  prefixIcon: const Icon(Icons.person,
                      color: Color.fromARGB(255, 124, 124, 124)),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 241, 241, 241),
                  hintText: 'นามสกุล',
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
                  hintText: 'COMFIRM PASSWORD',
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
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFFF914D), // สีพื้นหลังเริ่มต้น
                  minimumSize: const Size(400, 50), // ขนาดเริ่มต้น
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'ลงทะเบียนสมาชิก',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
