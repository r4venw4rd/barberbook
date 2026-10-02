import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hair_dryer_app/src/app.dart';
import 'package:hair_dryer_app/src/core/database/app_database.dart';
import 'package:hair_dryer_app/src/core/database/local_storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await LocalStorageService.create();
  final database = await AppDatabase.open();

  runApp(
    ProviderScope(
      overrides: [
        localStorageProvider.overrideWithValue(storage),
        appDatabaseProvider.overrideWithValue(database),
      ],
      child: const BarberBookApp(),
    ),
  );
}
