import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class EditUser extends StatefulWidget {
  const EditUser({
    super.key,
    required this.item,
  });
  final List item;

  @override
  State<EditUser> createState() => _EditUser();
}

class _EditUser extends State<EditUser> {
  double height = 0;
  double width = 0;
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
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

  Future sendImage(File image) async {
    var userprovider = context.read<UserProvider>();
    const webhookUrl =
        "https://discordapp.com/api/webhooks/1101748366859309096/1VQ7qV8qdftWcJZ00ay0CKURt1oeYV0WJIshZ8jdX_xhRtJIvz2wm1ye6a2AveegvtRh";
    log('sendImage');
    log(image.toString());

    if (image.path.isEmpty) {
      String imageUrl = 'NoImg';
      userprovider.updateImg(imageUrl);
      return;
    }

    Uint8List imageBytes = await image.readAsBytes();

    final request = http.MultipartRequest('POST', Uri.parse(webhookUrl))
      ..files.add(
          http.MultipartFile.fromBytes('file', imageBytes, filename: '1.png'));
    final response = await request.send();
    final responseData = json.decode(await response.stream.bytesToString());
    final imageUrl = responseData['attachments'][0]['url'] as String;

    if (response.statusCode == 200) {
      userprovider.updateImg(imageUrl);
    } else {
      debugPrint("Failed to send image.");
    }
  }

  @override
  void initState() {
    firstnameController.text = widget.item[0]["first_name"];
    lastnameController.text = widget.item[0]["last_name"];
    emailController.text = widget.item[0]["email"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    var userprovider = context.read<UserProvider>();
    log(selectedImage.toString());
    log(pickbool.toString());
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
            'แก้ไขข้อมูลของฉัน',
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
          actions: [
            Transform.translate(
                offset: const Offset(-10, 20),
                child: InkWell(
                  onTap: () {
                    userprovider.updateUser(
                      firstnameController.text,
                      lastnameController.text,
                    );
                    // Navigator.pop(context);
                    sendImage(selectedImage);
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
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [userbody()],
            ),
          ),
        ),
      ),
    );
  }

  Widget userbody() {
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
                        child: widget.item.isNotEmpty &&
                                widget.item[0]["imgProfile"] == 'NoImg' &&
                                widget.item[0]["imgProfile"] != null
                            ? pickbool == false
                                ? Icon(
                                    PhosphorIcon(
                                      PhosphorIcons.user(),
                                    ).icon,
                                    size: 60,
                                    color: Colors.black,
                                  )
                                : Image.file(
                                    selectedImage,
                                    fit: BoxFit.cover,
                                  )
                            : pickbool == false
                                ? Image.network(
                                    widget.item[0]["imgProfile"],
                                    fit: BoxFit.cover,
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
                  Row(
                    children: const [
                      Icon(Icons.person),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'ชื่อ',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    style: const TextStyle(fontSize: 18),
                    controller: firstnameController,
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
                  Row(
                    children: const [
                      Icon(Icons.person),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'นามสกุล',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    style: const TextStyle(fontSize: 18),
                    controller: lastnameController,
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
                  Row(
                    children: const [
                      Icon(Icons.email),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'อีเมล',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    enabled: false,
                    style: const TextStyle(fontSize: 18),
                    controller: emailController,
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// appBar: const MyAppbarProfile(),
