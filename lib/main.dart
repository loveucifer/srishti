import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:srishti/app.dart';
import 'package:srishti/core/services/supabase_service.dart';

Future<void> main() async {
  // Ensure Flutter engine is ready.
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from the .env file.
  await dotenv.load(fileName: ".env");

  // Initialize the Supabase service.
  await SupabaseService.initialize();
  
  runApp(const SrishtiApp());
}