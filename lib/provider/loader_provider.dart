import 'package:flutter/material.dart';

class LoaderProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(load) {
    _isLoading = load;
    notifyListeners();
  }
}
