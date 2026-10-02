import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hair_dryer_app/src/app.dart';
import 'package:hair_dryer_app/src/core/database/local_storage_service.dart';
import 'package:hair_dryer_app/src/features/auth/application/notifiers/auth_notifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await LocalStorageService.create();

  runApp(
    ProviderScope(
      overrides: [
        localStorageProvider.overrideWithValue(storage),
      ],
      child: const BarberBookApp(),
    ),
  );
}
