import 'package:flutter/widgets.dart';

import 'app_localizations.dart';

/// Convenience extension: `context.l10n.someKey`.
extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
