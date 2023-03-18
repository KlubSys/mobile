import 'package:flutter/foundation.dart';

logToConsole(Object? data) {
  if (kDebugMode) {
    print(data);
  }
}
