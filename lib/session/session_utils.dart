import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getUsernameFromSession() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('username');
}

Future<void> saveUsernameInSession(String username) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('username', username);
}