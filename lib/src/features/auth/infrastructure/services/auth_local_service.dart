import 'package:hair_dryer_app/src/core/database/local_storage_service.dart';

/// Raw authentication I/O service interacting with local storage.
class AuthLocalService {
  /// Creates the auth local service.
  new([LocalStorageService? storage]) : _storage = storage;

  final LocalStorageService? _storage;
  Map<String, dynamic>? _memoryUser = defaultUser;

  static const String _userKey = 'bb_current_user_v1';
  static const String _authStatusKey = 'bb_auth_status_v1';

  static const Map<String, dynamic> defaultUser = {
    'id': 'usr-alex',
    'name': 'Alex Johnson',
    'email': 'alex.johnson@example.com',
    'phone': '+1 555 0134',
    'avatarUrl':
        'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=300&auto=format&fit=crop&q=80',
    'isGuest': false,
  };

  /// Fetches the stored user JSON map, or default user on first run.
  Future<Map<String, dynamic>?> fetchCurrentUser() async {
    final storage = _storage;
    if (storage == null) return _memoryUser;

    final stored = storage.getJson(_userKey);
    if (stored != null) return stored;
    final isInitialized = storage.getBool(_authStatusKey);
    if (isInitialized == null) {
      await storage.setJson(_userKey, defaultUser);
      await storage.setBool(_authStatusKey, value: true);
      return defaultUser;
    }
    return null;
  }

  /// Saves the user map to storage.
  Future<void> saveUser(Map<String, dynamic> userMap) async {
    _memoryUser = userMap;
    final storage = _storage;
    if (storage != null) {
      await storage.setJson(_userKey, userMap);
      await storage.setBool(_authStatusKey, value: true);
    }
  }

  /// Clears user from storage.
  Future<void> deleteUser() async {
    _memoryUser = null;
    final storage = _storage;
    if (storage != null) {
      await storage.remove(_userKey);
    }
  }
}
