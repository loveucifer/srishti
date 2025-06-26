import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:srishti/app/app.dart'; // Assuming your main app widget is here
import 'package:srishti/core/services/supabase_service.dart'; // Assuming your Supabase service is here

// No explicit imports for webview_flutter or webview_flutter_web are needed
// in main.dart just for platform setup anymore.
// The webview_flutter_web package automatically registers itself.

Future<void> main() async {
  // Ensures that Flutter's binding is initialized before using any Flutter services.
  WidgetsFlutterBinding.ensureInitialized();

  // You DO NOT need the following lines anymore for WebView setup on web:
  // if (kIsWeb) {
  //   WebView.platform = WebWebViewPlatform();
  // }
  // These lines were for an older approach and are now handled automatically
  // by the webview_flutter_web package when it's included in your pubspec.yaml.

  // Load environment variables (e.g., Supabase keys)
  await dotenv.load(fileName: ".env");

  // Initialize Supabase service
  await SupabaseService.initialize();

  // Run the application, wrapped in ProviderScope for Riverpod
  runApp(const ProviderScope(child: SrishtiApp()));
}