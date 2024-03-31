import 'package:flutter/material.dart';

import '../provider/newsmodel.dart';

class NewsDetail extends StatefulWidget {
  const NewsDetail(this.data, {Key? key}) : super(key: key);
  final NewsData data;
  @override
  State<NewsDetail> createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4.0, // กำหนดความสูงของเงา
        shadowColor: Colors.grey, // กำหนดสีของเงา
        iconTheme: const IconThemeData(color: Color(0xFFFF914D)),
        toolbarHeight: 66,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.data.title!,
                style: const TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                widget.data.author!,
                style: const TextStyle(
                  color: Colors.black54,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              ClipRRect(
                // borderRadius: BorderRadius.circular(30.0),
                child: Image.network(widget.data.img!),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Text(widget.data.content!)
            ],
          ),
        ),
      ),
    );
  }
}
