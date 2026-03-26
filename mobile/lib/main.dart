import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'services/push_notification_service.dart';
import 'services/share_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (if configured).
  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  } catch (_) {
    // Firebase not configured — push notifications disabled.
  }

  // Check for pending share on launch (will be consumed after auth).
  ShareHandler.getPendingShare();

  runApp(const ProviderScope(child: HulyApp()));
}
