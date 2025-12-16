import 'package:expense_tracker_app/screens/home_screen.dart';
import 'package:expense_tracker_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'services/api_service.dart';
import 'services/token_service.dart';

void main() {
  Get.put(TokenService(), permanent: true);
  Get.put(ApiService(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Root(),
    );
  }
}

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    final tokenService = Get.find<TokenService>();

    return FutureBuilder<bool>(
      future: tokenService.isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final loggedIn = snapshot.data ?? false;
        return loggedIn ? const HomeScreen() : const LoginScreen();
      },
    );
  }
}
