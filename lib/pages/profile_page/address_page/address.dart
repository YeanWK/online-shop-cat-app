import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../provider/address_provider.dart';

class Address extends StatefulWidget {
  const Address({super.key});

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _addressCodeController = TextEditingController();
  final TextEditingController _firstnameCodeController =
      TextEditingController();
  final TextEditingController _lastnameCodeController = TextEditingController();
  final TextEditingController _tellphoneCodeController =
      TextEditingController();
  final provinceController = TextEditingController();

  List items = [];
  List itemsProvinces = [];
  List itemsAmphures = [];
  List itemsTambons = [];
  List itemFilterAmphures = [];
  List itemFilterTambons = [];
  Map provincesName = {};
  Map amphuresName = {};
  Map tambonsName = {};

  CollectionReference addressCollection = FirebaseFirestore.instance
      .collection('MeowMeowCat')
      .doc('Users')
      .collection(FirebaseAuth.instance.currentUser!.email.toString())
      .doc('Addresses')
      .collection('addresses');
  String id = FirebaseFirestore.instance
      .collection('MeowMeowCat')
      .doc('Users')
      .collection(FirebaseAuth.instance.currentUser!.email.toString())
      .doc('Addresses')
      .collection('addresses')
      .doc()
      .id;
  Future<void> addAddress() async {
    AddressProvider addressProvider = context.read<AddressProvider>();
    Map<String, dynamic> newAddress = {
      "id": id,
      "first_name": _firstnameCodeController.text,
      "last_name": _lastnameCodeController.text,
      "tellphone": _tellphoneCodeController.text,
      "address": _addressCodeController.text,
      "province": provincesName['name_th'].toString(),
      "amphures": amphuresName['name_th'].toString(),
      "tambons": tambonsName['name_th'].toString(),
      "province_id": _chosenValueProvince,
      "amphures_id": _chosenValueAmphures,
      "tambons_id": _chosenValueTambons,
      "zipcode": _postalCodeController.text,
    };

    // Add new address to Firestore
    try {
      await addressCollection.doc(id).set(newAddress);
      // setState(() {
      //   addressProvider.addAddressData([newAddress]);
      // });
      addressProvider.addAddressData([newAddress]);
      log(addressProvider.addressdata.toString());
      debugPrint("Address added successfully!");
    } catch (error) {
      debugPrint("Failed to add address: $error");
    }
  }

  @override
  void initState() {
    loadJsonData();
    loadJsonDataProvinces();
    loadJsonDataAmphures();
    loadJsonDataTambons();

    super.initState();
  }

  Future<String> loadJsonData() async {
    String jsonString =
        await rootBundle.loadString('assets/jsons/thai_geographies.json');
    var map = jsonDecode(jsonString);
    items = map['RECORDS'];
    setState(() {});
    return jsonString;
  }

  Future<String> loadJsonDataProvinces() async {
    String jsonString =
        await rootBundle.loadString('assets/jsons/thai_provinces.json');
    var map = jsonDecode(jsonString);
    itemsProvinces = map['RECORDS'];
    setState(() {});
    return jsonString;
  }

  Future<String> loadJsonDataAmphures() async {
    String jsonString =
        await rootBundle.loadString('assets/jsons/thai_amphures.json');
    var map = jsonDecode(jsonString);
    itemsAmphures = map['RECORDS'];
    setState(() {});
    return jsonString;
  }

  Future<String> loadJsonDataTambons() async {
    String jsonString =
        await rootBundle.loadString('assets/jsons/thai_tambons.json');
    var map = jsonDecode(jsonString);
    itemsTambons = map['RECORDS'];
    setState(() {});
    return jsonString;
  }

  void filterDataAmphures(int id) async {
    _chosenValueAmphures = '';
    _chosenValueTambons = '';

    List filteredItems =
        itemsAmphures.where((map) => map['province_id'] == id).toList();
    itemFilterAmphures = filteredItems;
    provincesName = itemsProvinces.firstWhere((map) => map['id'] == id);
  }

  void filterDataTambons(int id) async {
    _chosenValueTambons = '';
    // _chosenValueAmphures = '';

    List filteredItems =
        itemsTambons.where((map) => map['amphure_id'] == id).toList();
    itemFilterTambons = filteredItems;

    amphuresName = itemFilterAmphures.firstWhere((map) => map['id'] == id);

    log(amphuresName.toString());
    // return jsonString;
  }

  String _chosenValueProvince = '';
  String _chosenValueAmphures = '';
  String _chosenValueTambons = '';
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
          'ที่อยู่ใหม่',
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
        actions: [
          Transform.translate(
              offset: const Offset(-10, 20),
              child: InkWell(
                onTap: () {
                  addAddress;
                  Navigator.pop(context);
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
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    bodyaddress(),
                    // const Text('data'),
                    // Text(
                    //     'จังหวัด: ${_chosenValueProvince.isNotEmpty ? itemsProvinces.firstWhere((map) => map['id'].toString() == _chosenValueProvince)['name_th'] : 'ยังไม่ได้ระบุ'}'),
                    // Text(
                    //     'อำเภอ: ${_chosenValueAmphures.isNotEmpty ? itemFilterAmphures.firstWhere((map) => map['id'].toString() == _chosenValueAmphures)['name_th'] : 'ยังไม่ได้ระบุ'}'),
                    // Text(
                    //     'ตำบล: ${_chosenValueTambons.isNotEmpty ? itemFilterTambons.firstWhere((map) => map['id'].toString() == _chosenValueTambons)['name_th'] : 'ยังไม่ได้ระบุ'}'),
                    // Text(
                    //     'รหัสไปรษณีย์: ${_chosenValueTambons.isNotEmpty ? itemFilterTambons.firstWhere((map) => map['id'].toString() == _chosenValueTambons)['zip_code'] : 'ยังไม่ได้ระบุ'}'),
                    // Text(_postalCodeController.text.toString()),
                    // Text(tambonsName['name_th'].toString()),
                  ],
                ),
              ),
            ),
          ),
          // buttonsave(),
        ],
      ),
    );
  }

  Widget bodyaddress() {
    return Padding(
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ชื่อ',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  TextField(
                    controller: _firstnameCodeController,
                    decoration: const InputDecoration(
                      hintText: 'ชื่อ',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'นามสกุล',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  TextField(
                    controller: _lastnameCodeController,
                    decoration: const InputDecoration(
                      hintText: 'นามสกุล',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'เบอร์โทรศัพท์',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  TextField(
                    controller: _tellphoneCodeController,
                    decoration: const InputDecoration(
                      hintText: 'เบอร์โทรศัพท์',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.grey),
                      ),
                    ),
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(10),
                    ],
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ที่อยู่',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  TextField(
                    controller: _addressCodeController,
                    decoration: const InputDecoration(
                      hintText: 'ที่อยู่',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text(
                        'จังหวัด',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 180,
                      ),
                      // ElevatedButton(
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor:
                      //         const Color(0xFFFF914D), // สีพื้นหลังเริ่มต้น
                      //     minimumSize: const Size(20, 30),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(30),
                      //     ),
                      //   ),
                      //   onPressed: () {
                      //     // smartfill();
                      //   },
                      //   child: const Text('Smart Fill'),
                      // ),
                    ],
                  ),
                  DropdownButtonFormField<String>(
                    hint: const Text('จังหวัด'),
                    elevation: 1,
                    value: _chosenValueProvince.isNotEmpty
                        ? _chosenValueProvince
                        : null, // guard it with null if empty
                    items: itemsProvinces.map((value) {
                      // log('message');
                      return DropdownMenuItem<String>(
                        value: value['id'].toString(),
                        child: Text(value['name_th'] ?? 'ยังไม่ได้ระบุ'),
                      );
                    }).toList(),

                    onChanged: (newValue) {
                      setState(() {
                        log(newValue.toString());
                        _chosenValueProvince = newValue.toString();
                        filterDataAmphures(int.parse(newValue.toString()));
                        itemFilterTambons.clear();
                        _postalCodeController.clear();
                      });
                    },
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'อำเภอ/เขต ',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    hint: const Text('อำเภอ'),
                    elevation: 1,
                    value: _chosenValueAmphures.isNotEmpty
                        ? _chosenValueAmphures
                        : null, // guard it with null if empty
                    items: itemFilterAmphures.map((value) {
                      return DropdownMenuItem<String>(
                        value: value['id'].toString(),
                        child: Text(value['name_th'] ?? 'ยังไม่ได้ระบุ'),
                      );
                    }).toList(),

                    onChanged: (newValue) {
                      // FocusScope.of(context).unfocus();
                      setState(() {
                        _chosenValueAmphures = newValue.toString();
                        filterDataTambons(int.parse(newValue.toString()));
                        _postalCodeController.clear();
                        // time = newValue;
                        // widget.onChange(newValue);
                      });
                    },
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ตำบล/แขวง',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    hint: const Text('ตำบล'),
                    elevation: 1,
                    value: _chosenValueTambons.isNotEmpty
                        ? _chosenValueTambons
                        : null, // guard it with null if empty
                    items: itemFilterTambons.map((value) {
                      return DropdownMenuItem<String>(
                        value: value['id'].toString(),
                        child: Text(value['name_th'] ?? 'ยังไม่ได้ระบุ'),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _chosenValueTambons = newValue.toString();
                        tambonsName = itemFilterTambons.firstWhere(
                            (map) => map['id'] == int.parse(newValue!));
                        log('_chosenValueTambons.toString()');
                        log(_chosenValueTambons.toString());
                        log(tambonsName.toString());
                        _postalCodeController.text =
                            tambonsName['zip_code'].toString();
                      });
                    },
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'รหัสไปรษณีย์',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  TextField(
                    controller: _postalCodeController,
                    decoration: const InputDecoration(
                      hintText: 'รหัสไปรษณีย์',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.grey),
                      ),
                    ),
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(5),
                    ],
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  // Widget buttonsave() {
  //   return Container(
  //     width: double.infinity,
  //     height: 66,
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.withOpacity(0.5),
  //           spreadRadius: 5,
  //           blurRadius: 7,
  //           offset: const Offset(0, 3),
  //         ),
  //       ],
  //     ),
  //     child: ElevatedButton(
  //       onPressed: addAddress,
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: const Color(0xFFFF914D),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(0),
  //         ),
  //       ),
  //       child: const Text(
  //         "บันทึก",
  //         style: TextStyle(
  //           fontSize: 24,
  //           color: Colors.white,
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
