import 'package:barberbook/src/app.dart';
import 'package:barberbook/src/core/database/app_database.dart';
import 'package:barberbook/src/core/database/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
