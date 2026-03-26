import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase and share handler initialized lazily after auth.
  // ShareHandler requires native platform channel setup (share extension).
  // Firebase requires GoogleService-Info.plist.

  runApp(const ProviderScope(child: HulyApp()));
}
