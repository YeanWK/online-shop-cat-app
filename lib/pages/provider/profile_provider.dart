import 'dart:developer';

import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  List user = [];
  void addUser(List item) {
    user = item;
    log(user.toString());
  }
}
