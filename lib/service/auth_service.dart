import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/config.dart';

/// Akun lokal (Hive 'users') + status login (SharedPreferences).
class AuthService {
  static const String _loginKey = 'isLogin';
  static const String _usernameKey = 'username';

  static Box<String> get _users => Hive.box<String>(kUsersBox);

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loginKey) ?? false;
  }

  static Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey) ?? '';
  }

  /// true kalau berhasil login. Akun valid = akun tetap dari config ATAU hasil register.
  static Future<bool> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) return false;
    final isFixedAccount = !kUseFixedLogin ||
        (username == kFixedUsername && password == kFixedPassword);
    final isRegistered = _users.get(username) == password;
    if (!isFixedAccount && !isRegistered) return false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loginKey, true);
    await prefs.setString(_usernameKey, username);
    return true;
  }

  /// null = berhasil, selain itu pesan error.
  static Future<String?> register(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      return 'Username dan password wajib diisi';
    }
    if (_users.containsKey(username)) return 'Username sudah terdaftar';
    await _users.put(username, password);
    return null;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loginKey);
    await prefs.remove(_usernameKey);
  }
}
