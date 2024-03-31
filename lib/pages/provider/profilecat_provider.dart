import 'dart:developer';

import 'package:flutter/material.dart';

class CatProvider extends ChangeNotifier {
  List catdata = [];

  void addCatData(List items) {
    // catdata = items;
    catdata.addAll(items);
    log(catdata.toString());
    notifyListeners();
  }

  void updateCatData(List items) {
    for (int i = 0; i < catdata.length; i++) {
      if (catdata[i]['id'] == items[0]['id']) {
        catdata[i] = items[0];
      }
    }
    log("updateCatData.toString()");
    log(catdata.toString());
    notifyListeners();
  }

  void clearListAddress() {
    catdata.clear();
    notifyListeners();
  }
}
