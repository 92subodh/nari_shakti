

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/welcome_screen.dart';
import 'presentation/state/auth_provider.dart';
import 'presentation/state/location_provider.dart';
import 'presentation/state/sos_provider.dart';
import 'presentation/routes/app_routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NariShaktiApp());
}

class NariShaktiApp extends StatelessWidget {
  const NariShaktiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => SOSProvider()),
      ],
      child: MaterialApp(
        title: 'Nari Shakti',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme.copyWith(
          textTheme: GoogleFonts.poppinsTextTheme(AppTheme.lightTheme.textTheme),
        ),
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: const WelcomeScreen(),
      ),
    );
  }
}
