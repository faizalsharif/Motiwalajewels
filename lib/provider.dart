import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  var _loadingPercentage = 0;
  get loadingPercentage => _loadingPercentage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void setLoadingPercentage(val) {
    _loadingPercentage = val;
    notifyListeners();
  }
}
