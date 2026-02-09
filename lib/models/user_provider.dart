import 'dart:io';
import 'package:flutter/material.dart';
import 'package:coffee_app/config/api_config.dart';
import 'package:coffee_app/models/user_model.dart';
import 'package:coffee_app/services/user_service.dart';
import 'package:coffee_app/services/db_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

class UserProvider with ChangeNotifier {
  UserProfile? _userProfile;
  bool _isLoading = false;
  final DbService _dbService = DbService();

  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;

  Future<void> fetchProfile({bool forceFetch = false}) async {
    // If already loading, don't start again unless forced
    if (_isLoading && !forceFetch) return;
    
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Load from local DB first (Instant UI update)
      final cachedProfile = await _dbService.getCachedUserProfile();
      if (cachedProfile != null) {
        print('UserProvider: Loaded cached profile. Name: ${cachedProfile.username}');
        _userProfile = cachedProfile;
        notifyListeners();
      }

      // 2. Fetch from API (Actual source of truth)
      print('UserProvider: Fetching fresh profile from API...');
      final profile = await UserService.fetchProfile();
      
      if (profile != null) {
        print('UserProvider: Received profile from API.');
        
        // 3. Cache management
        String? localImagePath = _userProfile?.localProfileImage;
        bool fileExists = localImagePath != null && await File(localImagePath).exists();

        // Refresh image if path changed or file is missing
        if (profile.profileImage != null && (profile.profileImage != _userProfile?.profileImage || !fileExists)) {
          print('UserProvider: Image changed or missing locally. Downloading...');
          localImagePath = await _downloadAndCacheImage(profile.profileImage!);
        }

        _userProfile = UserProfile(
          id: profile.id ?? _userProfile?.id,
          username: profile.username,
          email: profile.email,
          profileImage: profile.profileImage,
          localProfileImage: localImagePath,
        );

        // 4. Persistence
        await _dbService.saveUserProfile(_userProfile!);
        print('UserProvider: Saved profile to local database.');
      } else {
        print('UserProvider: API returned null (Backend unreachable or unauthorized).');
      }
    } catch (e) {
      print('UserProvider: Unexpected error during fetch: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
      print('UserProvider: Profile fetch process completed.');
    }
  }

  Future<String?> _downloadAndCacheImage(String remotePath) async {
    try {
      final String url = remotePath.startsWith('http') 
          ? remotePath 
          : '${ApiConfig.baseUrl}$remotePath';
          
      final response = await http.get(Uri.parse(url), headers: {'ngrok-skip-browser-warning': 'any'});
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        
        // Use a unique name for each image to prevent Flutter cache issues
        final extension = p.extension(remotePath).isEmpty ? '.jpg' : p.extension(remotePath);
        final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}$extension'; 
        final filePath = p.join(directory.path, fileName);
        final file = File(filePath);
        
        // Pre-emptive cleanup: Delete any other files starting with 'profile_'
        try {
          final List<FileSystemEntity> files = directory.listSync();
          for (var f in files) {
            if (f is File && p.basename(f.path).startsWith('profile_') && f.path != filePath) {
              await f.delete();
            }
          }
        } catch (e) {
          print('UserProvider: Error cleaning up old profile images: $e');
        }

        await file.writeAsBytes(response.bodyBytes);
        print('UserProvider: Profile image cached locally at ${file.path}');
        return file.path;
      } else {
        print('UserProvider: Failed to download image. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('UserProvider: Error caching profile image: $e');
    }
    return null;
  }

  Future<void> clearProfile() async {
    print('UserProvider: Clearing user profile and local data...');
    
    // 1. Check local DB for image path even if provider state is null
    final cached = await _dbService.getCachedUserProfile();
    final imageToDelete = _userProfile?.localProfileImage ?? cached?.localProfileImage;

    if (imageToDelete != null) {
      try {
        final file = File(imageToDelete);
        if (await file.exists()) {
          await file.delete();
          print('UserProvider: Deleted local profile image file.');
        }
      } catch (e) {
        print('UserProvider: Error deleting image file: $e');
      }
    }

    // 2. Clear state
    _userProfile = null;
    
    // 3. Clear SQLite table
    await _dbService.clearUserProfile();
    
    notifyListeners();
    print('UserProvider: User data cleared from memory and database.');
  }
}
