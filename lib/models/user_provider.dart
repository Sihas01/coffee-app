import 'package:flutter/material.dart';
import 'package:coffee_app/models/user_model.dart';
import 'package:coffee_app/services/user_service.dart';

class UserProvider with ChangeNotifier {
  UserProfile? _userProfile;
  bool _isLoading = false;

  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;

  Future<void> fetchProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      final profile = await UserService.fetchProfile();
      _userProfile = profile;
    } catch (e) {
      print('Error in UserProvider.fetchProfile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearProfile() {
    _userProfile = null;
    notifyListeners();
  }
}
