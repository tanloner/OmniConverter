import 'dart:io';

import 'package:flutter/foundation.dart';

class AdHelper {
  static String get bannerOneAdUnitId {
    if (kDebugMode && !kIsWeb && Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else if (!kIsWeb && Platform.isAndroid) {
      return "ca-app-pub-9907694513770218/4803286105";
    } else {
      throw UnsupportedError("unsupported Platform");
    }
  }

  static String get intersticialOneAdUnitId {
    if (kDebugMode && !kIsWeb && Platform.isAndroid) {
      return "ca-app-pub-9907694513770218/1495995281";
    } else if (!kIsWeb && Platform.isAndroid) {
      return "ca-app-pub-9907694513770218/1495995281";
    } else {
      throw UnsupportedError("unsupported Platform");
    }
  }
}
