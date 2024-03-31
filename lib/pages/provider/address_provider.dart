import 'dart:developer';

import 'package:flutter/material.dart';

class AddressProvider extends ChangeNotifier {
  List<Map<String, dynamic>> addressdata = [];

  void addAddressData(List<Map<String, dynamic>> items) {
    addressdata.addAll(items);
    notifyListeners();
  }

  void updateAddressData(List<Map<String, dynamic>> items) {
    for (int i = 0; i < addressdata.length; i++) {
      log("addressdata[i]['id']");
      log(addressdata[i]['id']);
      log(items[0]['id']);
      if (addressdata[i]['id'] == items[0]['id']) {
        addressdata[i] = items[0];
        log("items[0].toString()");
        log(items[0].toString());
        log("addressdata[i].toString()");
        log(addressdata[i].toString());
      }
    }
    log("addressdata.toString()");
    log(addressdata.toString());

    notifyListeners();
  }

  void clearListAddress() {
    addressdata.clear();
    notifyListeners();
  }
}
