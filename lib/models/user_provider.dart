import 'package:flutter/material.dart';
import 'package:coffee_app/models/user_model.dart';
import 'package:coffee_app/services/user_service.dart';
import 'package:coffee_app/services/db_service.dart';

class UserProvider with ChangeNotifier {
  UserProfile? _userProfile;
  bool _isLoading = false;
  final DbService _dbService = DbService();

  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;

  Future<void> fetchProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Load from local DB first (Fast)
      final cachedProfile = await _dbService.getCachedUserProfile();
      if (cachedProfile != null) {
        _userProfile = cachedProfile;
        notifyListeners();
      }

      // 2. Fetch from API (Network)
      final profile = await UserService.fetchProfile();
      if (profile != null) {
        _userProfile = profile;
        // 3. Save to local DB for next time
        await _dbService.saveUserProfile(profile);
      }
    } catch (e) {
      print('Error in UserProvider.fetchProfile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearProfile() async {
    _userProfile = null;
    await _dbService.clearUserProfile();
    notifyListeners();
  }
}
