import 'dart:developer';

import 'package:flutter/material.dart';

class CatagoryProvider extends ChangeNotifier {
  List catagoryicon = [];
  void addCatagory(List item) {
    catagoryicon = item;
    log(catagoryicon.toString());
  }
}
