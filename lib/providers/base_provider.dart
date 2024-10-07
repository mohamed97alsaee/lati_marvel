import '../services/api.dart';
import 'dart:async';

import 'package:flutter/material.dart';

class BaseProvider with ChangeNotifier {
  Api api = Api();
  bool busy = false;

  setBusy(bool status) {
    Timer(Duration(milliseconds: 50), () {
      busy = status;
      notifyListeners();
    });
  }
}
