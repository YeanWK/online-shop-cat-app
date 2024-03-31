import 'dart:developer';

import 'package:flutter/material.dart';

class SlProvider extends ChangeNotifier {
  List bannershow = [];
  void addBannerShow(List item) {
    bannershow = item;
    log(bannershow.toString());
  }
}
