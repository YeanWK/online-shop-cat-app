import 'dart:developer';

import 'package:flutter/material.dart';

class BodyBottom extends StatefulWidget {
  const BodyBottom({super.key});

  @override
  State<BodyBottom> createState() => _BodyBottomState();
}

class _BodyBottomState extends State<BodyBottom> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    log('$index');
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: (BottomAppBar(
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFFFF914D),
          unselectedItemColor: Colors.black,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: "ร้านค้า",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.newspaper),
              label: "ข่่าวสาร",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: "ฉัน",
            ),
          ],
        ),
      )),
    );
  }
}


// class BodyBottom extends StatelessWidget {
//   const BodyBottom({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.5),
//             spreadRadius: 5,
//             blurRadius: 7,
//             offset: const Offset(0, 3), // changes position of shadow
//           ),
//         ],
//       ),
//       child: (BottomAppBar(
//         child: SizedBox(
//           height: 66,
//           child: BottomNavigationBar(
//             selectedItemColor: Colors.red,
//             unselectedItemColor: Colors.grey,
//             items: const [
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.shopping_cart),
//                 label: "SHOP",
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.newspaper),
//                 label: "NEWS",
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.account_circle),
//                 label: "ME",
//               ),
//             ],
//           ),
//         ),
//       )),
//     );
//   }
// }
