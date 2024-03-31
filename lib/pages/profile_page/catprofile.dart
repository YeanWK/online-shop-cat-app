import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import '../provider/profilecat_provider.dart';
import 'addcatprofile.dart';
import 'catprofile_edit.dart';

class CatProfile extends StatefulWidget {
  const CatProfile({super.key});

  @override
  State<CatProfile> createState() => _CatProfile();
}

class _CatProfile extends State<CatProfile> {
  double height = 0;
  double width = 0;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
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
            'สัตว์เลี้ยงของฉัน',
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              height: height,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [catlist(context), addcat()],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget addcat() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        // color: Colors.blueAccent,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddCatProfile()),
              );
            },
            child: Row(
              children: [
                const SizedBox(width: 10),
                Icon(
                  PhosphorIcon(
                    PhosphorIcons.plusCircle(),
                  ).icon,
                  size: 30,
                  color: const Color(0xFFFF914D),
                ),
                const SizedBox(width: 10),
                const Text(
                  'เพิ่มสัตว์เลี้ยง',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFFF914D),
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.keyboard_arrow_right,
                  size: 30,
                  color: Color(0xFFFF914D),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget catlist(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, CatProvider value, Widget? child) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: value.catdata.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              log(value.catdata[index].toString());
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditCatProfile(
                          item: value.catdata[index],
                        )),
              );
            },
            child: itemaddresslist(
              value.catdata[index]["name"],
              value.catdata[index]["species"],
              value.catdata[index]["img"],
            ),
          );
        },
      );
    });
  }

  Widget itemaddresslist(
    String name,
    String species,
    String img,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 20, right: 40),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: img != 'NoImg' ? NetworkImage(img) : null,
                    child: img != 'NoImg'
                        ? null
                        : Icon(
                            PhosphorIcon(
                              PhosphorIcons.cat(),
                            ).icon,
                            size: 60,
                            color: Colors.black,
                          ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'สายพันธุ์ : $species',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
