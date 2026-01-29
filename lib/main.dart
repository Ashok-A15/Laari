import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Pages
import 'pages/role_selection_page.dart';
import 'pages/welcome_auth_page.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/owner_dashboard_page.dart';
import 'pages/owner_main_page.dart'; // Added match session
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const GoLorryOwnerApp());
}

class GoLorryOwnerApp extends StatelessWidget {
  const GoLorryOwnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "GO Lorry Owner",
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF43CEA2),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF185A9D),
          primary: const Color(0xFF43CEA2),
          secondary: const Color(0xFF185A9D),
          surface: Colors.white,
          background: const Color(0xFFF8FAF9),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAF9),
        fontFamily: "Roboto",
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: 0.5,
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: const Color(0xFF43CEA2),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF43CEA2), width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),

      // 👉 Routes for Navigation
      routes: {
        "/welcome": (_) => const WelcomeAuthPage(),
        "/login": (_) => const LoginPage(),
        "/signup": (_) => SignupPage(),
        "/dashboard": (_) => const OwnerDashboardPage(),
      },

      // 👉 Auth Persistence Wrap
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) {
            return const OwnerMainPage();
          }
          return const RoleSelectionPage();
        },
      ),
    );
  }
}
