import 'package:hair_dryer_app/src/core/database/app_database.dart';

/// Raw authentication I/O against the local database.
///
/// Only dumb reads and writes live here — exceptions propagate to the
/// repository, which owns error detection.
class AuthLocalService {
  /// Creates the auth service. Without a [database] an in-memory store is
  /// used, which keeps widget tests and tooling working.
  new([AppDatabase? database]) : _database = database;

  final AppDatabase? _database;

  final Map<String, Map<String, dynamic>> _memoryUsers = {};
  final Map<String, String> _memoryEmailIndex = {};
  Map<String, dynamic>? _memorySession;

  /// Trims and lowercases [email] so it works as a stable index key.
  static String normalizeEmail(String email) => email.trim().toLowerCase();

  /// Reads a user record by id.
  Future<Map<String, dynamic>?> fetchUser(String userId) async {
    final database = _database;
    if (database == null) return _memoryUsers[userId];
    final raw = database.users.get(userId);
    if (raw == null) return null;
    return Map<String, dynamic>.from(raw);
  }

  /// Reads a user record by email, or null when nobody signed up with it.
  Future<Map<String, dynamic>?> fetchUserByEmail(String email) async {
    final key = normalizeEmail(email);
    final database = _database;
    final userId = database == null
        ? _memoryEmailIndex[key]
        : database.emailIndex.get(key);
    if (userId == null) return null;
    return await fetchUser(userId);
  }

  /// Inserts or replaces a user record and keeps the email index in sync.
  Future<void> saveUser(Map<String, dynamic> record) async {
    final userId = _requireString(record, 'id');
    final email = normalizeEmail(_requireString(record, 'email'));
    final database = _database;
    if (database == null) {
      final previous = _memoryUsers[userId];
      if (previous != null) {
        final previousEmail = normalizeEmail('${previous['email']}');
        if (previousEmail != email) _memoryEmailIndex.remove(previousEmail);
      }
      _memoryUsers[userId] = record;
      _memoryEmailIndex[email] = userId;
      return;
    }
    final previous = database.users.get(userId);
    if (previous != null) {
      final previousEmail = normalizeEmail('${previous['email']}');
      if (previousEmail != email) {
        await database.emailIndex.delete(previousEmail);
      }
    }
    await database.users.put(userId, record);
    await database.emailIndex.put(email, userId);
  }

  /// Deletes a user record and its email index entry.
  Future<void> deleteUser(String userId) async {
    final database = _database;
    if (database == null) {
      final record = _memoryUsers.remove(userId);
      if (record != null) {
        _memoryEmailIndex.remove(normalizeEmail('${record['email']}'));
      }
      return;
    }
    final record = database.users.get(userId);
    if (record != null) {
      await database.emailIndex
          .delete(normalizeEmail('${record['email']}'));
    }
    await database.users.delete(userId);
  }

  /// Reads the active session record, or null when signed out.
  Future<Map<String, dynamic>?> fetchSession() async {
    final database = _database;
    if (database == null) return _memorySession;
    final raw = database.session.get(AppDatabase.sessionKey);
    if (raw == null) return null;
    return Map<String, dynamic>.from(raw);
  }

  /// Persists the single active session record.
  Future<void> saveSession(Map<String, dynamic> session) async {
    final database = _database;
    if (database == null) {
      _memorySession = session;
      return;
    }
    await database.session.put(AppDatabase.sessionKey, session);
  }

  /// Removes the active session record.
  Future<void> clearSession() async {
    final database = _database;
    if (database == null) {
      _memorySession = null;
      return;
    }
    await database.session.delete(AppDatabase.sessionKey);
  }

  String _requireString(Map<String, dynamic> record, String field) {
    final value = record[field];
    if (value is String) return value;
    throw ArgumentError.value(value, field, 'must be a String');
  }
}
