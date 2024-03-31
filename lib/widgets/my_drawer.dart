import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

import '../pages/profile_page/catprofile.dart';
import '../pages/profile_page/favourite_page.dart';
import '../pages/profile_page/userprofile.dart';
import '../pages/provider/user_provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    log('MyDrawer');
    var userprovider = context.read<UserProvider>();
    return Drawer(
      // backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          userprovider.userdata.isEmpty
              ? drawerhander()
              : SizedBox(
                  height: 150,
                  child: DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            backgroundImage: userprovider.userdata.isNotEmpty &&
                                    userprovider.userdata[0]["imgProfile"] !=
                                        'NoImg'
                                ? NetworkImage(
                                    userprovider.userdata[0]["imgProfile"])
                                : null,
                            child: userprovider.userdata.isNotEmpty &&
                                    userprovider.userdata[0]["imgProfile"] ==
                                        'NoImg'
                                ? Icon(
                                    PhosphorIcon(
                                      PhosphorIcons.user(),
                                    ).icon,
                                    size: 60,
                                    color: Colors.black,
                                  ) // Replace with your desired fallback icon
                                : null,
                          ),
                        ),
                        // Spacer(),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Text(
                            '${userprovider.userdata[0]["first_name"]} ${userprovider.userdata[0]["last_name"]}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ListTile(
            leading: Icon(
              PhosphorIcon(
                PhosphorIcons.userCircle(),
              ).icon,
              size: 30,
              color: Colors.black,
            ),
            title: const Text(
              'ข้อมูลผู้ใช้',
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserProfile()),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ListTile(
              leading: Icon(
                PhosphorIcon(
                  PhosphorIcons.cat(),
                ).icon,
                size: 30,
                color: Colors.black,
              ),
              title: const Text(
                'ข้อมูลสัตว์เลี้ยง',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CatProfile()),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ListTile(
              leading: Icon(
                PhosphorIcon(
                  PhosphorIcons.package(),
                ).icon,
                size: 30,
                color: Colors.black,
              ),
              title: const Text(
                'รายการสั่งซื้อ',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                // Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ListTile(
              leading: const Icon(
                Icons.favorite_border,
                color: Colors.black,
                size: 30,
              ),
              title: const Text(
                'สินค้าที่สนใจ',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FavouritePage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget drawerhander() {
    final Stream<DocumentSnapshot> firestore = FirebaseFirestore.instance
        .collection('MeowMeowCat')
        .doc('Users')
        .collection(FirebaseAuth.instance.currentUser!.email.toString())
        .doc('Profile')
        .snapshots();
    return StreamBuilder<DocumentSnapshot>(
      stream: firestore,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasData) {
          final profileMe = (snapshot.data!.data() as Map<String, dynamic>);

          context.read<UserProvider>().addListUser([profileMe]);
          log("message");
          log(profileMe["imgProfile"].toString());

          return SizedBox(
            height: 150,
            child: DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage: profileMe.isNotEmpty &&
                              profileMe["imgProfile"] != 'NoImg'
                          ? NetworkImage(profileMe["imgProfile"])
                          : null,
                      child: profileMe.isNotEmpty &&
                              profileMe["imgProfile"] == 'NoImg'
                          ? Icon(
                              PhosphorIcon(
                                PhosphorIcons.user(),
                              ).icon,
                              size: 60,
                              color: Colors.black,
                            ) // Replace with your desired fallback icon
                          : null,
                    ),
                  ),
                  // Spacer(),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Text(
                      '${profileMe["first_name"]} ${profileMe["last_name"]}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Text('Something went wrong');
        }
      },
    );
  }
}
