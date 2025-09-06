import 'package:flutter/material.dart';

// import 'package:safeher/pages/intro.dart';

import 'package:safeher/pages/home.dart';
// import 'package:safeher/pages/not_found_page.dart';

// import 'package:safeher/pages/user_account_edit.dart';
// import 'package:safeher/pages/user_profile.dart';
// import 'package:safeher/pages/user_register.dart';

import 'package:safeher/pages/welcome.dart';
import 'package:safeher/pages/wake_word_page.dart';

Map<String, WidgetBuilder> getPageRoutes() {
  return {
  //   '/initial-splash': (BuildContext context) => const IntroScreen(),

    '/home': (BuildContext context) => const HomePage(title: "home"),
    // '/user-profile': (BuildContext context) => const UserProfile(),
    // '/edit-user-account': (BuildContext context) => const UserAccountEdit(),

    // '/user-register': (BuildContext context) => const UserRegister(),

    '/welcome': (BuildContext context) => const WelcomeScreen(),
    '/wake-word': (BuildContext context) => const WakeWordPage(),
  };
}
