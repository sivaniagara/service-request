import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static const String _tokenKey = 'auth_token';
  static const String _roleKey = 'user_role';
  static const String _profileCompleteKey = 'is_profile_complete';
  final SharedPreferences sharedPreferences;

  TokenManager({required this.sharedPreferences});

  Future<void> saveToken(String token) async {
    await sharedPreferences.setString(_tokenKey, token);
  }

  Future<void> saveRole(String role) async {
    await sharedPreferences.setString(_roleKey, role);
  }

  Future<void> saveProfileComplete(bool isComplete) async {
    await sharedPreferences.setBool(_profileCompleteKey, isComplete);
  }

  String? getToken() {
    return sharedPreferences.getString(_tokenKey);
  }

  String? getRole() {
    return sharedPreferences.getString(_roleKey);
  }

  bool isProfileComplete() {
    return sharedPreferences.getBool(_profileCompleteKey) ?? false;
  }

  Future<void> deleteToken() async {
    await sharedPreferences.remove(_tokenKey);
    await sharedPreferences.remove(_roleKey);
    await sharedPreferences.remove(_profileCompleteKey);
  }

  bool hasToken() {
    return sharedPreferences.containsKey(_tokenKey);
  }
}
