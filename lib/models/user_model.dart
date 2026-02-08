class UserProfile {
  final String? id;
  final String username;
  final String email;
  final String? profileImage;

  UserProfile({
    this.id,
    required this.username,
    required this.email,
    this.profileImage,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? json['_id'],
      username: json['username'],
      email: json['email'],
      profileImage: json['profile_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'profile_image': profileImage,
    };
  }
}
