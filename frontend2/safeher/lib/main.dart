import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:safeher/constants/routes.dart';
import 'package:safeher/utils/theme_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await dotenv.load(fileName: '.env');
    print('✅ .env file loaded successfully');
  } catch (e) {
    print('⚠️ Warning: Could not load .env file: $e');
    print('📝 App will continue without environment variables');
    // Continue without .env file - the app should still work
  }
  
  runApp(const MainView());
}

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    Map<String, WidgetBuilder> routes = getPageRoutes();
    return MaterialApp(
      title: 'Safeher',
      theme: getTheme(),
      home: routes["/welcome"]!(context),
      routes: routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
