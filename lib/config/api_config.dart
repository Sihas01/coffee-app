class ApiConfig {
  static const String baseUrl = 'https://vambraced-unappreciably-bebe.ngrok-free.dev';
  
  // API endpoints
  static String get tokenUrl => '$baseUrl/token';
  static String get registerUrl => '$baseUrl/register';
  static String get profileUrl => '$baseUrl/getprofile';
  static String get updateProfileUrl => '$baseUrl/profile';
  static String get productsUrl => '$baseUrl/products';
  static String get uploadUrl => '$baseUrl/upload';
}
