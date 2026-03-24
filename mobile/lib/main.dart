import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'services/share_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Check for pending share on launch (will be consumed after auth).
  ShareHandler.getPendingShare();

  runApp(const ProviderScope(child: HulyApp()));
}
