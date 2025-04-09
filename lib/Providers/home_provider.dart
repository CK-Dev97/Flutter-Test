import 'package:flutter/material.dart';
import '../service_locator.dart';
import '../services/api_service.dart';

class HomeProvider with ChangeNotifier {
  final _apiService = locator<ApiService>();

  List<dynamic> _images = [];
  bool _isLoading = true;
  String _errorMessage = '';
  bool _isRefreshing = false;

  List<dynamic> get images => _images;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isRefreshing => _isRefreshing;

  Future<void> loadImages() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _images = await _apiService.fetchImages();
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    _isRefreshing = false;
    notifyListeners();
  }

  Future<void> refreshImages() async {
    _isRefreshing = true;
    notifyListeners();
    await loadImages();
  }
}
