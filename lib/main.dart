import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srishti/app.dart';
// Note the updated path for SupabaseService
import 'package:srishti/features/core/services/supabase_service.dart';

Future<void> main() async {
  // Ensure Flutter engine is ready.
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from the .env file.
  await dotenv.load(fileName: ".env");

  // Initialize the Supabase service.
  await SupabaseService.initialize();

  // Wrap the app in a ProviderScope for Riverpod state management.
  runApp(const ProviderScope(child: SrishtiApp()));
}