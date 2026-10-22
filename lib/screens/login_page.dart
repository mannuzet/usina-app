import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'tela_principal.dart';

const Color verdeEscuro = Color(0xFF172514);
const Color verdeMusgo = Color(0xFF263719);
const Color verdeClaro = Color(0xFFCAD1B6);

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  bool carregando = false;
  bool lembrarDeMim = true;
  bool mostrarSenha = false;

  void mostrarMensagem(String mensagem) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        behavior: SnackBarBehavior.floating,
        backgroundColor: verdeMusgo,
      ),
    );
  }

  Future<Position?> obterLocalizacao() async {
    try {
      final servicoAtivo =
          await Geolocator.isLocationServiceEnabled();

      if (!servicoAtivo) {
        mostrarMensagem(
          'A localização está desativada. Você pode continuar sem ela.',
        );
        return null;
      }

      LocationPermission permissao =
          await Geolocator.checkPermission();

      if (permissao == LocationPermission.denied) {
        permissao = await Geolocator.requestPermission();
      }

      if (permissao == LocationPermission.denied ||
          permissao == LocationPermission.deniedForever) {
        mostrarMensagem(
          'Permissão de localização não concedida.',
        );
        return null;
      }

      return await Geolocator.getCurrentPosition();
    } catch (_) {
      mostrarMensagem(
        'Não foi possível obter a localização.',
      );
      return null;
    }
  }

  Future<void> entrar() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => carregando = true);

    const emailTeste = 'aluno@usina.com';
    const senhaTeste = '123456';

    final email = emailController.text.trim();
    final senha = senhaController.text.trim();

    if (email != emailTeste || senha != senhaTeste) {
      mostrarMensagem('E-mail ou senha inválidos.');

      if (mounted) {
        setState(() => carregando = false);
      }

      return;
    }

    final posicao = await obterLocalizacao();
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('loginRealizado', lembrarDeMim);
    await prefs.setString('emailUsuario', email);
    await prefs.setString(
      'dataLogin',
      DateTime.now().toIso8601String(),
    );

    if (posicao != null) {
      await prefs.setDouble('latitude', posicao.latitude);
      await prefs.setDouble('longitude', posicao.longitude);
    }

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const TelaPrincipal(),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.55, -0.55),
                radius: 1.35,
                colors: [
                  Color(0xFF75835A),
                  Color(0xFF354529),
                  verdeEscuro,
                ],
                stops: [0, 0.48, 1],
              ),
            ),
          ),
          Positioned(
            top: -80,
            right: -55,
            child: _blurCircle(
              220,
              const Color(0x557F9060),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -50,
            child: _blurCircle(
              280,
              const Color(0x443E512B),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 390,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: verdeMusgo,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0x668F9A76),
                            width: 1.5,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black38,
                              blurRadius: 25,
                              offset: Offset(0, 12),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person_outline_rounded,
                          size: 58,
                          color: Colors.white,
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(0, -18),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 14,
                              sigmaY: 14,
                            ),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(
                                24,
                                38,
                                24,
                                26,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.23),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: const Color(0xDDE9EDE1),
                                  width: 1.6,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black38,
                                    blurRadius: 32,
                                    offset: Offset(0, 18),
                                  ),
                                ],
                              ),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const Text(
                                      'USINA APP',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        letterSpacing: 3,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      'Gestão simples, operação eficiente',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFFE5E9DB),
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 28),
                                    _campo(
                                      controller: emailController,
                                      hint: 'E-mail',
                                      icon: Icons.person_outline,
                                      keyboardType:
                                          TextInputType.emailAddress,
                                      validator: (v) {
                                        if (v == null ||
                                            v.trim().isEmpty) {
                                          return 'Informe o e-mail';
                                        }

                                        if (!v.contains('@')) {
                                          return 'E-mail inválido';
                                        }

                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    _campo(
                                      controller: senhaController,
                                      hint: 'Senha',
                                      icon: Icons.lock_outline,
                                      obscure: !mostrarSenha,
                                      suffix: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            mostrarSenha = !mostrarSenha;
                                          });
                                        },
                                        icon: Icon(
                                          mostrarSenha
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: Colors.black54,
                                          size: 20,
                                        ),
                                      ),
                                      validator: (v) {
                                        if (v == null || v.length < 6) {
                                          return 'A senha deve ter ao menos 6 caracteres';
                                        }

                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 34,
                                          child: Checkbox(
                                            value: lembrarDeMim,
                                            activeColor: verdeMusgo,
                                            checkColor: Colors.white,
                                            onChanged: (v) {
                                              setState(() {
                                                lembrarDeMim = v ?? false;
                                              });
                                            },
                                            side: const BorderSide(
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ),
                                        const Expanded(
                                          child: Text(
                                            'Manter conectado',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        const Text(
                                          'Acesso seguro',
                                          style: TextStyle(
                                            color: Color(0xFFDDE3D2),
                                            fontSize: 11,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 14),
                                    SizedBox(
                                      height: 52,
                                      child: ElevatedButton(
                                        onPressed:
                                            carregando ? null : entrar,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: verdeMusgo,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            side: const BorderSide(
                                              color: Color(0xFF101B0D),
                                            ),
                                          ),
                                        ),
                                        child: carregando
                                            ? const SizedBox(
                                                height: 22,
                                                width: 22,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : const Text(
                                                'ENTRAR',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  letterSpacing: 2,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Text(
                        'TECNOLOGIA • CAMPO • RESULTADOS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xBFFFFFFF),
                          fontSize: 10,
                          letterSpacing: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _campo({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscure = false,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      validator: validator,
      style: const TextStyle(
        color: Color(0xFF30342B),
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFF73766D),
        ),
        prefixIcon: Container(
          margin: const EdgeInsets.only(right: 12),
          decoration: const BoxDecoration(
            color: Color(0xFFE0E2DC),
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(8),
            ),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF4C5047),
            size: 21,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 52,
          minHeight: 52,
        ),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFFE5E6E2),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 17,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: verdeClaro,
            width: 2,
          ),
        ),
        errorStyle: const TextStyle(
          color: Color(0xFFFFE3DE),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _blurCircle(double size, Color color) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: 35,
        sigmaY: 35,
      ),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}