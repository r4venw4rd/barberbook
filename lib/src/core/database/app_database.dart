import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

/// Local database holding persisted auth records.
///
/// Boxes are opened once during bootstrap and shared through
/// [appDatabaseProvider].
class AppDatabase {
  const AppDatabase._({
    required this.users,
    required this.emailIndex,
    required this.session,
  });

  /// User records keyed by user id.
  final Box<Map<dynamic, dynamic>> users;

  /// Normalized email to user id lookup used for sign in and uniqueness.
  final Box<String> emailIndex;

  /// The single active session record stored under [sessionKey].
  final Box<Map<dynamic, dynamic>> session;

  static const String _usersBoxName = 'bb_auth_users_v1';
  static const String _emailIndexBoxName = 'bb_auth_email_index_v1';
  static const String _sessionBoxName = 'bb_auth_session_v1';

  /// Key of the single active session record.
  static const String sessionKey = 'current';

  /// Opens the database in the platform default storage location.
  static Future<AppDatabase> open() async {
    await Hive.initFlutter();
    return _openBoxes();
  }

  /// Opens the database at an explicit [path] (tests, tooling).
  static Future<AppDatabase> openAt(String path) async {
    Hive.init(path);
    return _openBoxes();
  }

  static Future<AppDatabase> _openBoxes() async {
    final users = await Hive.openBox<Map<dynamic, dynamic>>(_usersBoxName);
    final emailIndex = await Hive.openBox<String>(_emailIndexBoxName);
    final session = await Hive.openBox<Map<dynamic, dynamic>>(_sessionBoxName);
    return AppDatabase._(
      users: users,
      emailIndex: emailIndex,
      session: session,
    );
  }
}

/// Local database instance, overridden with a real one in `main()`.
final appDatabaseProvider = Provider<AppDatabase?>((ref) => null);
