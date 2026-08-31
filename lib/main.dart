import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'data/local/local_store.dart';
import 'data/quran/quran_data.dart';
import 'services/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final appState = AppState(store: LocalStore(prefs));

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
