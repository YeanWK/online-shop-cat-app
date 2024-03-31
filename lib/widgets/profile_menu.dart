import 'package:flutter/material.dart';

class ProfileMenu extends StatelessWidget {
  final String menu;
  final IconData icon;
  final VoidCallback onTap;

  const ProfileMenu({
    Key? key,
    required this.menu,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        child: InkWell(
          onTap: onTap, // เรียกใช้งานฟังก์ชันที่ได้รับเมื่อ Card ถูกคลิก
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 30.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  icon,
                  size: 30,
                  color: Colors.black,
                ),
                const SizedBox(width: 24.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      menu,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
