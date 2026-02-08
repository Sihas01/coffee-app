import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:coffee_app/config/api_config.dart';
import 'package:coffee_app/models/user_model.dart';
import 'package:coffee_app/services/auth_service.dart';

class UserService {
  // Common headers for ngrok
  static const Map<String, String> _headers = {
    'ngrok-skip-browser-warning': 'any',
  };

  // Fetch current user profile
  static Future<UserProfile?> fetchProfile() async {
    final token = await AuthService.getToken();
    if (token == null) {
      print('UserService: No token found');
      return null;
    }

    try {
      final response = await http.get(
        Uri.parse(ApiConfig.profileUrl),
        headers: {
          'Authorization': 'Bearer $token',
          ..._headers,
        },
      );

      if (response.statusCode == 200) {
        return UserProfile.fromJson(jsonDecode(response.body));
      } else {
        print('UserService: Failed to fetch profile. Status: ${response.statusCode}, Body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('UserService: Error fetching profile: $e');
      return null;
    }
  }

  // Upload image to backend
  static Future<String?> uploadImage(File imageFile) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(ApiConfig.uploadUrl));
      
      // Add ngrok headers
      request.headers.addAll(_headers);
      
      // Get file extension and determine content type
      String fileName = imageFile.path.split('/').last;
      String extension = fileName.split('.').last.toLowerCase();
      
      String contentType = 'image/jpeg';
      if (extension == 'png') contentType = 'image/png';
      else if (extension == 'jpg' || extension == 'jpeg') contentType = 'image/jpeg';

      final file = await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        filename: fileName,
      );

      request.files.add(file);

      print('UserService: Uploading image: $fileName, type: $contentType');
      
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['imagePath'];
      } else {
        print('UserService: Failed to upload image. Status: ${response.statusCode}, Body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('UserService: Error uploading image: $e');
      return null;
    }
  }

  // Update user profile (profile image path)
  static Future<bool> updateProfile({String? username, String? profileImage}) async {
    final token = await AuthService.getToken();
    if (token == null) return false;

    try {
      final Map<String, dynamic> body = {};
      if (username != null) body['username'] = username;
      if (profileImage != null) body['profile_image'] = profileImage;

      final response = await http.put(
        Uri.parse(ApiConfig.updateProfileUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          ..._headers,
        },
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        print('UserService: Failed to update profile. Status: ${response.statusCode}, Body: ${response.body}');
      }

      return response.statusCode == 200;
    } catch (e) {
      print('UserService: Error updating profile: $e');
      return false;
    }
  }
}
