import 'package:flutter/foundation.dart';

void zprint(Object message) {
  if (kDebugMode) {
    print(message);
  }
}
