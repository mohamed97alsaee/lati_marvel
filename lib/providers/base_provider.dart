import '../services/api.dart';
import 'dart:async';

import 'package:flutter/material.dart';

class BaseProvider with ChangeNotifier {
  Api api = Api();
  bool busy = false;
  bool isFailed = false;

  setBusy(bool status) {
    Timer(Duration(milliseconds: 50), () {
      busy = status;
      notifyListeners();
    });
  }

    setFailed(bool status) {
    Timer(Duration(milliseconds: 50), () {
      isFailed = status;
      notifyListeners();
    });
  }
}
