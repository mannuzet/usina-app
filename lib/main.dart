import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/login_page.dart';
import 'screens/tela_principal.dart';

const Color verdeEscuro = Color(0xFF172514);
const Color verdeMusgo = Color(0xFF283719);
const Color verdeMedio = Color(0xFF64764A);
const Color fundoClaro = Color(0xFFF3F4ED);

void main() {
  runApp(const UsinaApp());
}

class UsinaApp extends StatelessWidget {
  const UsinaApp({super.key});

  Future<bool> verificarLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('loginRealizado') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    const bordaCampo = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: Color(0xFFD8DCCF)),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Usina App',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: fundoClaro,
        colorScheme: ColorScheme.fromSeed(
          seedColor: verdeMedio,
          primary: verdeMusgo,
          secondary: verdeMedio,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: verdeEscuro,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFFF8F9F5),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: bordaCampo,
          enabledBorder: bordaCampo,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: verdeMedio,
              width: 1.7,
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: verdeMusgo,
            foregroundColor: Colors.white,
            minimumSize: const Size(48, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      home: FutureBuilder<bool>(
        future: verificarLogin(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.hasError) {
            return const LoginPage();
          }

          return snapshot.data == true
              ? const TelaPrincipal()
              : const LoginPage();
        },
      ),
    );
  }
}