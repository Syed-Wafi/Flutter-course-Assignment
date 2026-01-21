import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/dashboard.dart';
import 'screens/login_page.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //  Supabase initialization
  await Supabase.initialize(
    url: 'https://deirwwqwcxldsavpbyla.supabase.co',
    anonKey: 'sb_publishable_16LOvv86B9Vj23GHzO8bew_-0fnd2-8',
  );

  runApp(const MessApp());
}

class MessApp extends StatefulWidget {
  const MessApp({super.key});

  @override
  State<MessApp> createState() => _MessAppState();
}

class _MessAppState extends State<MessApp> {
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mess Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.green,
        ),
      ),
      //login checked here
      home: StreamBuilder<AuthState>(
        stream: authService.authStateStream,
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          // Check if user is signed in
          if (snapshot.hasData && snapshot.data?.session != null) {
            return const Dashboard();
          }

          // User is not signed in
          return const LoginPage();
        },
      ),
      routes: {
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const Dashboard(),
      },
    );
  }
}
