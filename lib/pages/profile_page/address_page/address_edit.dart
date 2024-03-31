import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../provider/address_provider.dart';

class AddressEdit extends StatefulWidget {
  const AddressEdit({
    super.key,
    required this.item,
  });
  final Map item;

  @override
  State<AddressEdit> createState() => _AddressEditState();
}

class _AddressEditState extends State<AddressEdit> {
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
  Future<void> updateAddress() {
    log(widget.item['id'].toString());
    var addressProvider = context.read<AddressProvider>();
    List<Map<String, dynamic>> dataAddress = [
      {
        "id": widget.item['id'],
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
      },
    ];

    if (_firstnameCodeController.text.isNotEmpty &&
        _lastnameCodeController.text.isNotEmpty &&
        _tellphoneCodeController.text.isNotEmpty &&
        _addressCodeController.text.isNotEmpty &&
        provincesName['name_th'].toString().isNotEmpty &&
        amphuresName['name_th'].toString().isNotEmpty &&
        tambonsName['name_th'].toString().isNotEmpty) {
      addressProvider.updateAddressData(dataAddress);
      return addressCollection.doc(widget.item['id']).update({
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
      }).catchError((error) => debugPrint("Failed to update user: $error"));
    }
    return Future.value();
  }

  @override
  void initState() {
    loadJsonData();
    loadJsonDataProvinces();
    loadJsonDataAmphures();
    loadJsonDataTambons();
    _chosenValueProvince = widget.item['province_id'].toString();
    _chosenValueAmphures = widget.item['amphures_id'].toString();
    _chosenValueTambons = widget.item['tambons_id'].toString();
    _postalCodeController.text = widget.item['zipcode'].toString();
    tambonsName['name_th'] = widget.item['tambon'].toString();
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
    if (_chosenValueProvince.isNotEmpty) {
      log("message");
      log(_chosenValueProvince.toString());
      filterDataAmphures(int.parse(_chosenValueProvince));
    }
    return jsonString;
  }

  Future<String> loadJsonDataTambons() async {
    String jsonString =
        await rootBundle.loadString('assets/jsons/thai_tambons.json');
    var map = jsonDecode(jsonString);
    itemsTambons = map['RECORDS'];
    setState(() {});
    if (_chosenValueAmphures.isNotEmpty) {
      filterDataTambons(int.parse(_chosenValueAmphures));
    }
    return jsonString;
  }

  void filterDataAmphures(int id) async {
    // _chosenValueAmphures = '';
    // _chosenValueTambons = '';

    List filteredItems =
        itemsAmphures.where((map) => map['province_id'] == id).toList();
    itemFilterAmphures = filteredItems;
    provincesName = itemsProvinces.firstWhere((map) => map['id'] == id);
  }

  void filterDataTambons(int id) async {
    // _chosenValueTambons = '';
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
    log("widget.item['id'].toString()");
    log(widget.item['id'].toString());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4.0, // กำหนดความสูงของเงา
        shadowColor: Colors.grey, // กำหนดสีของเงา
        iconTheme: const IconThemeData(color: Color(0xFFFF914D)),
        toolbarHeight: 66,
        centerTitle: true,
        title: const Text(
          'แก้ไขที่อยู่',
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
        actions: [
          Transform.translate(
              offset: const Offset(-10, 20),
              child: InkWell(
                onTap: () {
                  updateAddress;
                  Navigator.pop(context);
                },
                child: const Text(
                  'อัพเดท',
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
    log(widget.item.toString());

    _firstnameCodeController.text = widget.item['first_name'];
    _lastnameCodeController.text = widget.item['last_name'];
    _tellphoneCodeController.text = widget.item['tellphone'];
    _addressCodeController.text = widget.item['address'];
    log(_chosenValueProvince.toString());
    log(_chosenValueAmphures.toString());
    log(_chosenValueTambons.toString());
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
                        _chosenValueAmphures = '';
                        _chosenValueTambons = '';
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
                        _chosenValueTambons = '';
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

  Widget buttonsave() {
    return Container(
      width: double.infinity,
      height: 66,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: updateAddress,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF914D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
        child: const Text(
          "อัพเดท",
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
