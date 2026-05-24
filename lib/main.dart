import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:firebase_core/firebase_core.dart';

import 'SplashScreen/splash_screen.dart';

import 'screens/auth/login_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/otp_screen.dart';
import 'screens/auth/reset_password_screen.dart';
import 'screens/auth/register_screen.dart';

import 'screens/main_navigation.dart';

import 'services/firebase_service.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // ================= FIREBASE =================
  await Firebase.initializeApp();

  await FirebaseService.init();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {

  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      // ================= LOCALIZATION =================
      localizationsDelegates: const [

        GlobalMaterialLocalizations.delegate,

        GlobalWidgetsLocalizations.delegate,

        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: const [

        Locale('id'),
      ],

      locale: const Locale('id'),

      // ================= ROUTE =================
      initialRoute: '/',

      routes: {

        '/': (context) =>
        const SplashScreen(),

        '/login': (context) =>
        const LoginScreen(),

        '/dashboard': (context) =>
        const MainNavigation(),

        '/register': (context) =>
        const RegisterScreen(),

        '/forgot-password': (context) =>
        const ForgotPasswordScreen(),

        '/otp': (context) =>
        const OtpScreen(),

        '/reset-password': (context) =>
        const ResetPasswordScreen(),
      },
    );
  }
}