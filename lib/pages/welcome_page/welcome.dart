import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../provider/logo_provider.dart';
import 'LoginAndRegister/login_page.dart';
import 'LoginAndRegister/register_page.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _Welcome();
}

class _Welcome extends State<Welcome> {
  double height = 0;
  double width = 0;
  @override
  Widget build(BuildContext context) {
    var logoProvider = context.read<LogoProvider>();
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              height: height,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    logoProvider.logo.isEmpty
                        ? imgLogo()
                        : Image.network(
                            logoProvider.logo[0]['imgLogo'],
                            height: 200,
                            width: 200,
                          ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      'ยินดีต้อนรับสู่',
                      style: TextStyle(fontSize: 24),
                    ),
                    const Text(
                      '"MEOW MEOW CAT"',
                      style: TextStyle(
                        fontSize: 24,
                        color: Color(0xFFFF914D),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 255, 255, 255), // สีพื้นหลังเริ่มต้น
                        minimumSize: const Size(400, 50), // ขนาดเริ่มต้น
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: const BorderSide(color: Color(0xFFFF914D)),
                        ),
                      ),
                      child: const Text(
                        'เข้าสู่ระบบ',
                        style:
                            TextStyle(fontSize: 24, color: Color(0xFFFF914D)),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'หรือ',
                      style: TextStyle(fontSize: 24),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage()),
                        );
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
                        'ลงทะเบียนสมาชิก',
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget imgLogo() {
    final Stream<QuerySnapshot> firestore = FirebaseFirestore.instance
        .collection('MeowMeowCat')
        .doc('Shop')
        .collection('Logo')
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: firestore,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasData) {
          final logo = snapshot.data!.docs
              .map((DocumentSnapshot document) =>
                  document.data() as Map<String, dynamic>)
              .toList();
          context.read<LogoProvider>().addLogo(logo);
          return Image.network(
            logo[0]['imgLogo'],
            height: 200,
            width: 200,
          );
        } else {
          return const Text('Something went wrong');
        }
      },
    );
  }
}
