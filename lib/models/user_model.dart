class UserProfile {
  final String? id;
  final String username;
  final String email;
  final String? profileImage;
  final String? localProfileImage;

  UserProfile({
    this.id,
    required this.username,
    required this.email,
    this.profileImage,
    this.localProfileImage,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? json['_id'],
      username: json['username'],
      email: json['email'],
      profileImage: json['profile_image'],
      localProfileImage: json['local_profile_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'profile_image': profileImage,
      'local_profile_image': localProfileImage,
    };
  }
}
