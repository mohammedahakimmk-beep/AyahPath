import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'data/local/local_store.dart';
import 'services/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final appState = AppState(store: LocalStore(prefs));

  runApp(
    ChangeNotifierProvider.value(
      value: appState,
      child: AyahPathApp(updateInfo: null),
    ),
  );
}
