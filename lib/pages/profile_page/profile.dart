import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import '../../widgets/profile_menu.dart';
import '../provider/address_provider.dart';
import '../provider/cart_provider.dart';
import '../provider/favourite_provider.dart';
import '../provider/user_provider.dart';
import '../welcome_page/welcome.dart';
import 'address_page/address_book.dart';
import 'catprofile.dart';
import 'favourite_page.dart';
import 'userprofile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    var userprovider = context.read<UserProvider>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            userprovider.userdata.isEmpty
                ? drawerhander()
                : Consumer(builder:
                    (BuildContext context, UserProvider value, Widget? child) {
                    return Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            backgroundImage: value.userdata.isNotEmpty &&
                                    value.userdata[0]["imgProfile"] != 'NoImg'
                                ? NetworkImage(value.userdata[0]["imgProfile"])
                                : null,
                            child: value.userdata.isNotEmpty &&
                                    value.userdata[0]["imgProfile"] == 'NoImg'
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
                        Expanded(
                          child: Text(
                            '${value.userdata[0]["first_name"]} ${value.userdata[0]["last_name"]}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            ProfileMenu(
              menu: 'ข้อมูลผู้ใช้',
              icon: PhosphorIcons
                  .userCircle(), // ใช้ไอคอนของ PhosphorIcons โดยตรง
              onTap: () {
                log(auth.currentUser!.email.toString());
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserProfile()),
                );
              },
            ),
            ProfileMenu(
              menu: 'ข้อมูลสัตว์เลี้ยง',
              icon: PhosphorIcons.cat(),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CatProfile()),
                );
              },
            ),
            ProfileMenu(
              menu: 'รายการสั่งซื้อ',
              icon: PhosphorIcons.package(),
              onTap: () {},
            ),
            ProfileMenu(
              menu: 'สมุดที่อยู่',
              icon: PhosphorIcons.addressBook(),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddressBook()),
                );
              },
            ),
            ProfileMenu(
              menu: 'สินค้าที่สนใจ',
              icon: Icons.favorite_border,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FavouritePage()),
                );
              },
            ),
            ProfileMenu(
              menu: 'ออกจากระบบ',
              icon: PhosphorIcons.signOut(),
              onTap: () async {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: ((context) => const Welcome())));
                context.read<CartProvider>().clearListCartProduct();
                context.read<AddressProvider>().clearListAddress();
                context.read<FavouriteProductProvider>().clearListFavProduct();
                context.read<UserProvider>().clearListUser();
              },
            ),
          ],
        ),
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

          return Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  backgroundImage:
                      profileMe.isNotEmpty && profileMe["imgProfile"] != 'NoImg'
                          ? NetworkImage(profileMe["imgProfile"])
                          : null,
                  child:
                      profileMe.isNotEmpty && profileMe["imgProfile"] == 'NoImg'
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
          );
        } else {
          return const Text('Something went wrong');
        }
      },
    );
  }
}
