import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/login_page.dart';
import 'screens/tela_principal.dart';

void main() {
  runApp(const UsinaApp());
}

class UsinaApp extends StatelessWidget {
  const UsinaApp({super.key});

  Future<bool> verificarLogin() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getBool('loginRealizado') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Usina App',

      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),

      home: FutureBuilder<bool>(
        future: verificarLogin(),

        builder: (context, snapshot) {
          // Enquanto verifica o login
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          // Se já estiver logado
          if (snapshot.data == true) {
            return const TelaPrincipal();
          }

          // Se não estiver logado
          return const LoginPage();
        },
      ),
    );
  }
}