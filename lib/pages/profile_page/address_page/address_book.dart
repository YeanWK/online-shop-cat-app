import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import '../../provider/address_provider.dart';
import 'address.dart';
import 'address_edit.dart';

class AddressBook extends StatefulWidget {
  const AddressBook({super.key});

  @override
  State<AddressBook> createState() => _AddressBookState();
}

class _AddressBookState extends State<AddressBook> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 4.0, // กำหนดความสูงของเงา
          shadowColor: Colors.grey, // กำหนดสีของเงา
          iconTheme: const IconThemeData(color: Color(0xFFFF914D)),
          toolbarHeight: 66,
          centerTitle: true,
          title: const Text(
            'สมุดที่อยู่',
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [addresslist(context), bodyaddAddress()])));
  }

  Widget bodyaddAddress() {
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
                MaterialPageRoute(builder: (context) => const Address()),
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
                  'เพิ่มที่อยู่ใหม่',
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

  Widget addresslist(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, AddressProvider value, Widget? child) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: value.addressdata.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddressEdit(
                          item: value.addressdata[index],
                        )),
              );
              log(value.addressdata[index].toString());
            },
            child: itemaddresslist(
              value.addressdata[index]["first_name"],
              value.addressdata[index]["last_name"],
              value.addressdata[index]["tellphone"],
              value.addressdata[index]["address"],
              value.addressdata[index]["province"],
              value.addressdata[index]["amphures"],
              value.addressdata[index]["tambons"],
              value.addressdata[index]["zipcode"],
            ),
          );
        },
      );
    });
  }

  Widget itemaddresslist(
      String firstname,
      String lastname,
      String tellphone,
      String address,
      String province,
      String amphures,
      String tambons,
      String zipcode) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  firstname,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  lastname,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  address,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  '$tambons,',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  '$amphures,',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  '$province,',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  zipcode,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  tellphone,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
