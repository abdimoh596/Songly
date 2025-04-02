import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Load environment variables
import 'screens/login_screen.dart'; // Import login screen
import 'screens/welcome_screen.dart'; // Import welcome screen

void main() async {
  await dotenv.load(); // Load .env file (for your credentials)
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Constructor
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Songly',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/', // Set the first screen to load
      routes: {
        '/': (context) => WelcomeScreen(), // Welcome screen route
        '/login': (context) => LoginScreen(),  // Login screen route
      },
    );
  }
}