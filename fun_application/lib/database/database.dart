import 'package:flutter/services.dart' show rootBundle;

Future<String> loadAsset(String file) async {
  return await rootBundle.loadString(file);
}
