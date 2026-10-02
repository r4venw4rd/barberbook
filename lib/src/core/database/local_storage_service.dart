import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Key-value storage instance, overridden with a real one in `main()`.
final localStorageProvider = Provider<LocalStorageService?>((ref) => null);

/// Central local storage service for key-value and JSON document persistence.
class LocalStorageService {
  /// Creates the local storage service.
  const new(this._prefs);

  final SharedPreferences _prefs;

  /// Initializes the storage service by acquiring shared preferences.
  static Future<LocalStorageService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService(prefs);
  }

  /// Gets a string value for [key].
  String? getString(String key) => _prefs.getString(key);

  /// Saves a string [value] for [key].
  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);

  /// Gets a bool value for [key].
  bool? getBool(String key) => _prefs.getBool(key);

  /// Saves a bool [value] for [key].
  Future<bool> setBool(String key, {required bool value}) =>
      _prefs.setBool(key, value);

  /// Gets and decodes a JSON object stored at [key].
  Map<String, dynamic>? getJson(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } on Exception catch (_) {
      return null;
    }
  }

  /// Encodes and saves a JSON [map] to [key].
  Future<bool> setJson(String key, Map<String, dynamic> map) =>
      _prefs.setString(key, jsonEncode(map));

  /// Gets and decodes a list of JSON objects stored at [key].
  List<Map<String, dynamic>>? getJsonList(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      }
      return null;
    } on Exception catch (_) {
      return null;
    }
  }

  /// Encodes and saves a list of JSON maps to [key].
  Future<bool> setJsonList(String key, List<Map<String, dynamic>> list) =>
      _prefs.setString(key, jsonEncode(list));

  /// Removes the entry for [key].
  Future<bool> remove(String key) => _prefs.remove(key);

  /// Clears all stored data.
  Future<bool> clear() => _prefs.clear();
}
