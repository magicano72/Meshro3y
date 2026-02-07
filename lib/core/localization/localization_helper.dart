import 'package:flutter/material.dart';

import 'app_localizations.dart';

class AppLocalizationHelper {
  static String translate(String key) {
    return AppLocalizations.get(key);
  }

  static String getLanguage() {
    return AppLocalizations.currentLocale;
  }

  static bool isArabic() {
    return getLanguage() == 'ar';
  }

  static TextAlign getTextAlign() {
    return isArabic() ? TextAlign.right : TextAlign.left;
  }

  static TextDirection getTextDirection() {
    return isArabic() ? TextDirection.rtl : TextDirection.ltr;
  }
}
