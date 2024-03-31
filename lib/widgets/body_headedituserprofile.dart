import 'package:flutter/material.dart';

class MyAppbarEditProfile extends StatelessWidget
    implements PreferredSizeWidget {
  const MyAppbarEditProfile({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(66);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Transform.translate(
        offset: const Offset(0.0, 5.0),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFFFF914D),
            size: 32,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      leadingWidth: 80,
      iconTheme: const IconThemeData(color: Color(0xFFFF914D)),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      title: const Padding(
        padding: EdgeInsets.only(top: 10),
        child: Text(
          "แก้ไขข้อมูลของฉัน",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
          ),
        ),
      ),
      centerTitle: true,
      actions: [
        Transform.translate(
            offset: const Offset(-10, 20),
            child: InkWell(
              onTap: () {
                // do something
              },
              child: const Text(
                'บันทึก',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFFFF914D),
                ),
              ),
            )),
      ],
      elevation: 4.0, // กำหนดความสูงของเงา
      shadowColor: Colors.grey, // กำหนดสีของเงา
    );
  }
}
