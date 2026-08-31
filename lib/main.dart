import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'data/local/data_store.dart';
import 'data/quran/quran_data.dart';
import 'services/app_state.dart';
import 'services/firebase_auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (failures on startup are surfaced via the login gate).
  try {
    await Firebase.initializeApp();
  } catch (_) {
    // Auth/RTDB will simply be unavailable; the UI handles it.
  }

  final appState = AppState(
    store: FirebaseDataStore(),
    auth: FirebaseAuthService(),
  );
  await appState.initialize();

  // Load the bundled Qur'an dataset (all 114 surahs) before first frame.
  try {
    await QuranDataset.load();
  } catch (_) {
    // Non-fatal: the reader will show metadata-only for missing text.
  }

  runApp(
    ChangeNotifierProvider.value(
      value: appState,
      child: AyahPathApp(updateInfo: null),
    ),
  );
}
