import 'package:flutter/material.dart';
import '../provider/newsmodel.dart';
import 'newsdetails.dart';

class NewsListTile extends StatefulWidget {
  const NewsListTile(this.data, {Key? key}) : super(key: key);
  final NewsData data;
  @override
  State<NewsListTile> createState() => _NewsListTileState();
}

class _NewsListTileState extends State<NewsListTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsDetail(widget.data),
            ));
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 20.0),
        padding: const EdgeInsets.all(12.0),
        height: 130,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(26.0),
        ),
        child: Row(
          children: [
            Flexible(
              flex: 3,
              child: Container(
                height: 100.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: NetworkImage(widget.data.img!),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Flexible(
                flex: 5,
                child: Column(
                  children: [
                    Text(
                      widget.data.title!,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(widget.data.content!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white54,
                        ))
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
