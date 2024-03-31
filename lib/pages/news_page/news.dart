import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/news_provider.dart';
import 'detailnews.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => _News();
}

class _News extends State<News> {
  double height = 0;
  double width = 0;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    var newsProvider = context.read<NewsProvider>();

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: height,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "ข่าวสาร",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  newsProvider.newsdata.isEmpty
                      ? newslist(context)
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: newsProvider.newsdata.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailNews(
                                        item: newsProvider.newsdata[index],
                                      ),
                                    ));
                              },
                              child: itemnews(
                                newsProvider.newsdata[index]["img"],
                                newsProvider.newsdata[index]["title"],
                                newsProvider.newsdata[index]["author"],
                              ),
                            );
                          },
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget newslist(BuildContext context) {
    log("newslist");
    final Stream<QuerySnapshot> firestore = FirebaseFirestore.instance
        .collection('MeowMeowCat')
        .doc('Shop')
        .collection('News')
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: firestore,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final newsdata = snapshot.data!.docs
            .map((DocumentSnapshot document) =>
                document.data() as Map<String, dynamic>)
            .toList();

        context.read<NewsProvider>().addListNews(newsdata);

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: newsdata.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailNews(
                        item: newsdata[index],
                      ),
                    ));
              },
              child: itemnews(
                newsdata[index]["img"],
                newsdata[index]["title"],
                newsdata[index]["author"],
              ),
            );
          },
        );
      },
    );
  }

  Widget itemnews(String img, String title, String author) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 220,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(img),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              gradient: const LinearGradient(
                colors: [Colors.transparent, Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  author,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
