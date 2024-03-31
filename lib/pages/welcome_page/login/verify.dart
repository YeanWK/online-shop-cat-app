import 'package:flutter/material.dart';

class OtpPage extends StatefulWidget {
  final String phoneNumber;

  const OtpPage({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: otpController,
              decoration: InputDecoration(
                labelText: 'OTP',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement OTP verification logic
              },
              child: const Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
