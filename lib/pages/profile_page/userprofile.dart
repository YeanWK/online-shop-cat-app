import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

import '../provider/user_provider.dart';
import 'edit_user.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfile();
}

class _UserProfile extends State<UserProfile> {
  double height = 0;
  double width = 0;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    var userprovider = context.read<UserProvider>();
    log('rebuild');
    log(userprovider.userdata.toString());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 4.0, // กำหนดความสูงของเงา
          shadowColor: Colors.grey, // กำหนดสีของเงา
          iconTheme: const IconThemeData(color: Color(0xFFFF914D)),
          toolbarHeight: 66,
          centerTitle: true,
          title: const Text(
            'ข้อมูลของฉัน',
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
          actions: [
            Transform.translate(
              offset: const Offset(0.0, 3.0),
              child: IconButton(
                icon: const Icon(Icons.edit),
                iconSize: 30,
                // color: const Color(0xFFFF914D),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditUser(
                              item: userprovider.userdata,
                            )),
                  );
                },
              ),
            ),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Consumer(builder:
                (BuildContext context, UserProvider value, Widget? child) {
              return SizedBox(
                height: height,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Container(
                          width: 700,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(255, 197, 197, 197),
                              width: 2.0,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 20, right: 40),
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Colors.white,
                                      backgroundImage: value
                                                  .userdata.isNotEmpty &&
                                              value.userdata[0]["imgProfile"] !=
                                                  'NoImg'
                                          ? NetworkImage(
                                              value.userdata[0]["imgProfile"])
                                          : null,
                                      child: value.userdata.isNotEmpty &&
                                              value.userdata[0]["imgProfile"] ==
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
                              ),
                              const Divider(
                                thickness: 1.5,
                                indent: 10,
                                endIndent: 10,
                                color: Color.fromARGB(255, 197, 197, 197),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 15, bottom: 30),
                                child: Row(
                                  children: [
                                    Text(
                                      'ชื่อ : ${value.userdata[0]["first_name"]}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 15, bottom: 30),
                                child: Row(
                                  children: [
                                    Text(
                                      'นามสกุล : ${value.userdata[0]["last_name"]}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, bottom: 30),
                                child: Row(
                                  children: [
                                    Text(
                                      'อีเมล : ${value.userdata[0]["email"]}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
