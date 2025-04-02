import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart'; // Updated import
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? accessToken;

  Future<void> loginWithSpotify() async {
    final clientId = dotenv.env['SPOTIFY_CLIENT_ID'];
    final redirectUri = 'songly://callback';
    final authUrl =
        'https://accounts.spotify.com/authorize?client_id=$clientId&response_type=code&redirect_uri=$redirectUri&scope=user-library-read';

    try {
      // Open Spotify login page using flutter_web_auth_2
      final result = await FlutterWebAuth2.authenticate(
        url: authUrl,
        callbackUrlScheme: "songly", // Same as your redirect URI scheme
      );

      // Extract authorization code from the result URL
      final code = Uri.parse(result).queryParameters['code'];

      if (code != null) {
        await exchangeCodeForToken(code);
      }
    } catch (e) {
      // Handle any errors that occur during authentication
    }
  }

  Future<void> exchangeCodeForToken(String code) async {
    final clientId = dotenv.env['SPOTIFY_CLIENT_ID'];
    final clientSecret = dotenv.env['SPOTIFY_CLIENT_SECRET'];
    final redirectUri = 'songly://callback';

    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': redirectUri,
      },
    );

    final body = jsonDecode(response.body);
    setState(() {
      accessToken = body['access_token'];
    }); // Debugging in console
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login to Spotify')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: loginWithSpotify,
              child: const Text('Login with Spotify'),
            ),
            if (accessToken != null) ...[
              const SizedBox(height: 20),
              const Text('Access Token:'),
              Text(
                accessToken!,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }
}