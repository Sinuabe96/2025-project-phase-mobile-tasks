import 'package:auth_chat/features/auth/presentation/auth/pages/login_screen.dart';
import 'package:auth_chat/features/auth/presentation/auth/pages/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_chat/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:auth_chat/features/auth/presentation/auth/pages/splash_screen.dart';
import 'package:auth_chat/service_locator.dart';

void main() {
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: MaterialApp(
        title: 'AuthChat',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4A90E2),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFF1E1E1E),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF2A2A2A),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
        ),
        // home: const SplashScreen(),
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignupScreen()
        },
      ),
    );
  }
}
