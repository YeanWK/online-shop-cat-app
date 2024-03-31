import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../provider/profilecat_provider.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class AddCatProfile extends StatefulWidget {
  const AddCatProfile({super.key});

  @override
  State<AddCatProfile> createState() => _AddCatProfile();
}

class _AddCatProfile extends State<AddCatProfile> {
  double height = 0;
  double width = 0;
  String selectedCat = '';
  String dropdownValue = '';

  final TextEditingController nameController = TextEditingController();

  late File selectedImage = File('');
  bool pickbool = false;

  Future<void> pickUploadProfilePic() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 90,
    );
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      selectedImage = imageFile;
      setState(() {
        pickbool = true;
      });
      // log(selectedImage.toString());
    }
  }

  Future sendProfileCat(File image) async {
    var catProvider = context.read<CatProvider>();
    // var userprovider = context.read<UserProvider>();
    const webhookUrl =
        "https://discordapp.com/api/webhooks/1101748366859309096/1VQ7qV8qdftWcJZ00ay0CKURt1oeYV0WJIshZ8jdX_xhRtJIvz2wm1ye6a2AveegvtRh";
    log('sendImage');
    log(image.toString());

    if (image.path.isEmpty) {
      debugPrint("No image selected.");
      CollectionReference profileCat = FirebaseFirestore.instance
          .collection('MeowMeowCat')
          .doc('Users')
          .collection(FirebaseAuth.instance.currentUser!.email.toString())
          .doc('ProfileCat')
          .collection('ProfileCat');
      String id = FirebaseFirestore.instance
          .collection('MeowMeowCat')
          .doc('Users')
          .collection(FirebaseAuth.instance.currentUser!.email.toString())
          .doc('ProfileCat')
          .collection('ProfileCat')
          .doc()
          .id;
      List cat = [
        {
          "id": id,
          'name': nameController.text,
          'img': 'NoImg',
          'species': dropdownValue.toString(),
        }
      ];
      if (nameController.text.trim().isNotEmpty) {
        catProvider.addCatData(cat);
        return profileCat.doc(id).set({
          "id": id,
          'name': nameController.text,
          'img': 'NoImg',
          'species': dropdownValue.toString()
        }).catchError((error) => debugPrint("Failed to add user: $error"));
      }
      return Future.value();
    }

    Uint8List imageBytes = await image.readAsBytes();

    final request = http.MultipartRequest('POST', Uri.parse(webhookUrl))
      ..files.add(
          http.MultipartFile.fromBytes('file', imageBytes, filename: '1.png'));
    final response = await request.send();
    final responseData = json.decode(await response.stream.bytesToString());

    final imageUrl = responseData['attachments'][0]['url'] as String;
    if (response.statusCode == 200) {
      CollectionReference profileCat = FirebaseFirestore.instance
          .collection('MeowMeowCat')
          .doc('Users')
          .collection(FirebaseAuth.instance.currentUser!.email.toString())
          .doc('ProfileCat')
          .collection('ProfileCat');
      String id = FirebaseFirestore.instance
          .collection('MeowMeowCat')
          .doc('Users')
          .collection(FirebaseAuth.instance.currentUser!.email.toString())
          .doc('ProfileCat')
          .collection('ProfileCat')
          .doc()
          .id;
      List cat = [
        {
          "id": id,
          'name': nameController.text,
          'img': imageUrl.toString(),
          'species': dropdownValue.toString(),
        }
      ];
      if (nameController.text.trim().isNotEmpty) {
        catProvider.addCatData(cat);
        return profileCat.doc(id).set({
          "id": id,
          'name': nameController.text,
          'img': imageUrl.toString(),
          'species': dropdownValue.toString()
        }).catchError((error) => debugPrint("Failed to add user: $error"));
      }
      return Future.value();
    } else {
      debugPrint("Failed to send image.");
    }
  }

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
          actions: [
            Transform.translate(
                offset: const Offset(-10, 20),
                child: InkWell(
                  onTap: () {
                    sendProfileCat(selectedImage);
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
        body: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              height: height,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [catbody()],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget catbody() {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 20, right: 40),
              child: Align(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white, // กำหนดสีพื้นหลังของ Container
                          border: Border.all(
                            color: Colors.grey, // กำหนดสีของขอบ
                            width: 2,
                          )),
                      child: ClipOval(
                        child: pickbool == false
                            ? Icon(
                                PhosphorIcon(
                                  PhosphorIcons.cat(),
                                ).icon,
                                size: 60,
                                color: Colors.black,
                              )
                            : Image.file(
                                selectedImage,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 90, left: 70),
                      child: SizedBox(
                        height: 30,
                        child: FloatingActionButton(
                          backgroundColor: Colors.white,
                          onPressed: pickUploadProfilePic,
                          child: const IconTheme(
                            data: IconThemeData(color: Colors.grey),
                            child: Icon(Icons.camera_alt, size: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                    style: const TextStyle(fontSize: 18),
                    controller: nameController,
                    decoration: const InputDecoration(
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
                    'สายพันธ์',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.grey),
                      ),
                    ),
                    value: dropdownValue.isNotEmpty ? dropdownValue : null,
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                        log(dropdownValue.toString());
                      });
                    },
                    items: <String>[
                      'อเมริกันช็อตแฮร์',
                      'เปอร์เซีย',
                      'เมนคูน',
                      'สฟริงซ์',
                      'สกอตติชโฟลด์',
                      'บริติชช็อตแฮร์',
                      'เอ็กโซติกชอร์ตแฮร์',
                      'เบงกอล',
                      'มัชกิ้น',
                      'ไทย',
                      'อเมริกันเคิร์ล',
                      'อื่นๆ',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}

// appBar: const MyAppbarProfile(),

