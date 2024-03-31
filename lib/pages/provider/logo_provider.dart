import 'dart:developer';

import 'package:flutter/material.dart';

class LogoProvider extends ChangeNotifier {
  List logo = [];
  void addLogo(List item) {
    logo = item;
    log("logo.toString()");
    log(logo.toString());
  }
}
