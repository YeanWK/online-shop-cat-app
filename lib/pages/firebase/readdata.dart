// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ReadData extends StatelessWidget {
//   const ReadData({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final Stream<DocumentSnapshot<Map<String, dynamic>>> firestore =
//         FirebaseFirestore.instance
//             .collection('Product')
//             .doc('Product1')
//             .snapshots();
//     return SafeArea(
//       child: Scaffold(
//         body: Center(
//           child: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   'Product',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 16),
//                 StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//                   stream: firestore,
//                   builder: (BuildContext context,
//                       AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
//                           snapshot) {
//                     if (snapshot.hasError) {
//                       return const Text('Something went wrong');
//                     }

//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const CircularProgressIndicator();
//                     }

//                     final data = snapshot.data?.data();
//                     if (data == null) {
//                       return const Text('No data available');
//                     }

//                     return ListTile(
//                       title: Text(data['name'] ?? 'No name available'),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Image.network(data['pathImg']),
//                           Text(data['detail']),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReadData extends StatelessWidget {
  const ReadData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> firestore =
        FirebaseFirestore.instance.collection('Product').snapshots();

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Product',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                StreamBuilder<QuerySnapshot>(
                  stream: firestore,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    return ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        return ListTile(
                          title: Text(data['name'] ?? 'No name available'),
                          subtitle: Image.network(data['pathImg']),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget product(List productPath) {
//   return GridView.builder(
//     physics: const NeverScrollableScrollPhysics(),
//     scrollDirection: Axis.vertical,
//     shrinkWrap: true,
//     itemCount: productPath.length, // จำนวนของ item ใน GridView
//     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//       crossAxisSpacing: 0,
//       mainAxisSpacing: 0,
//       crossAxisCount: 2, // จำนวนของแถว
//       childAspectRatio: 0.6, // อัตราส่วนของขนาดของแต่ละ Widget ใน GridView
//     ),
//     itemBuilder: (BuildContext context, int index) {
//       return GestureDetector(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => DetailProduct(
//                       item: productPath[index],
//                       // title: title,
//                       // name: name,
//                     )),
//           );
//         },
//         child: itemproduct(
//           productPath[index]["pathImg"],
//           productPath[index]["name"],
//           productPath[index]["price"],
//         ),
//       );
//     },
//   );
// }
