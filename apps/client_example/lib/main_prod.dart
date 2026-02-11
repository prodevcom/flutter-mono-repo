import 'package:flutter/material.dart';

import 'app.dart';
import 'di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies('prod');
  runApp(const App());
}
