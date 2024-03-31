import 'package:flutter/material.dart';

class NewsProvider extends ChangeNotifier {
  List newsdata = [];
  void addListNews(List item) {
    newsdata = item;
  }
}
