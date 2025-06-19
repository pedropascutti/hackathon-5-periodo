import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuario.dart';
import '../utilidade/constants.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveUserData(usuario user) async {
    await _prefs?.setString(ApiConstants.userTokenKey, user.token ?? '');
    await _prefs?.setInt(ApiConstants.userIdKey, user.id);
    await _prefs?.setString(ApiConstants.userNameKey, user.nome);
    await _prefs?.setString(ApiConstants.userRoleKey, user.cargo);
    await _prefs?.setBool(ApiConstants.isLoggedInKey, true);
  }

  static bool isLoggedIn() {
    return _prefs?.getBool(ApiConstants.isLoggedInKey) ?? false;
  }

  static String? getUserToken() {
    return _prefs?.getString(ApiConstants.userTokenKey);
  }

  static int? getUserId() {
    return _prefs?.getInt(ApiConstants.userIdKey);
  }

  static String? getUserName() {
    return _prefs?.getString(ApiConstants.userNameKey);
  }

  static String? getUserRole() {
    return _prefs?.getString(ApiConstants.userRoleKey);
  }

  static usuario? getCurrentUser() {
    if (!isLoggedIn()) return null;
    
    return usuario(
      id: getUserId() ?? 0,
      nome: getUserName() ?? '',
      cargo: getUserRole() ?? '',
      token: getUserToken(),
    );
  }

  static Future<void> clearUserData() async {
    await _prefs?.remove(ApiConstants.userTokenKey);
    await _prefs?.remove(ApiConstants.userIdKey);
    await _prefs?.remove(ApiConstants.userNameKey);
    await _prefs?.remove(ApiConstants.userRoleKey);
    await _prefs?.setBool(ApiConstants.isLoggedInKey, false);
  }

  static Future<void> saveTemporaryData(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  static String? getTemporaryData(String key) {
    return _prefs?.getString(key);
  }

  static Future<void> removeTemporaryData(String key) async {
    await _prefs?.remove(key);
  }
}

