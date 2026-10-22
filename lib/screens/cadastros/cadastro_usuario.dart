import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/usuario.dart';

class CadastroUsuarioPage extends StatefulWidget {
  const CadastroUsuarioPage({super.key});

  @override
  State<CadastroUsuarioPage> createState() =>
      _CadastroUsuarioPageState();
}

class _CadastroUsuarioPageState
    extends State<CadastroUsuarioPage> {
  final formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  XFile? fotoSelecionada;
  bool mostrarSenha = false;

  void mostrarMensagem(String mensagem) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> selecionarFoto() async {
    try {
      final imagem = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (imagem == null || !mounted) return;

      setState(() => fotoSelecionada = imagem);
    } on PlatformException catch (e) {
      mostrarMensagem(
        'Não foi possível abrir as fotos: ${e.message ?? e.code}',
      );
    }
  }

  Future<void> tirarFoto() async {
    try {
      final imagem = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (imagem == null || !mounted) return;

      setState(() => fotoSelecionada = imagem);
    } on PlatformException catch (e) {
      mostrarMensagem(
        'Não foi possível acessar a câmera: ${e.message ?? e.code}',
      );
    } catch (_) {
      mostrarMensagem(
        'Câmera indisponível. Selecione uma foto da galeria.',
      );
    }
  }

  void salvar() {
    if (!formKey.currentState!.validate()) return;

    final usuario = Usuario(
      nome: nomeController.text.trim(),
      email: emailController.text.trim(),
      senha: senhaController.text.trim(),
      fotoPath: fotoSelecionada?.path,
    );

    debugPrint('Nome: ${usuario.nome}');
    debugPrint('E-mail: ${usuario.email}');
    debugPrint('Foto: ${usuario.fotoPath ?? "sem foto"}');

    mostrarMensagem('Usuário validado com sucesso!');
  }

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Usuário'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF172514),
                          Color(0xFF465737),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Color(0x445FFFFFFF),
                          child: Icon(
                            Icons.person_add_alt_1,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Novo usuário',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 21,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Adicione os dados e uma foto de perfil.',
                                style: TextStyle(
                                  color: Color(0xFFDDE4D3),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF64764A),
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 58,
                        backgroundColor: const Color(0xFFE4E9DA),
                        backgroundImage: fotoSelecionada == null
                            ? null
                            : FileImage(
                                File(fotoSelecionada!.path),
                              ),
                        child: fotoSelecionada == null
                            ? const Icon(
                                Icons.person_outline,
                                size: 58,
                                color: Color(0xFF64764A),
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      OutlinedButton.icon(
                        onPressed: selecionarFoto,
                        icon: const Icon(
                          Icons.photo_library_outlined,
                        ),
                        label: const Text('Selecionar foto'),
                      ),
                      OutlinedButton.icon(
                        onPressed: tirarFoto,
                        icon: const Icon(Icons.camera_alt_outlined),
                        label: const Text('Tirar foto'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  rotulo('Nome completo'),
                  TextFormField(
                    controller: nomeController,
                    decoration: const InputDecoration(
                      hintText: 'Digite o nome',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty
                            ? 'Informe o nome'
                            : null,
                  ),
                  const SizedBox(height: 18),
                  rotulo('E-mail'),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'nome@exemplo.com',
                      prefixIcon: Icon(Icons.mail_outline),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Informe o e-mail';
                      }

                      if (!v.contains('@') || !v.contains('.')) {
                        return 'Informe um e-mail válido';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  rotulo('Senha'),
                  TextFormField(
                    controller: senhaController,
                    obscureText: !mostrarSenha,
                    decoration: InputDecoration(
                      hintText: 'Mínimo de 6 caracteres',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            mostrarSenha = !mostrarSenha;
                          });
                        },
                        icon: Icon(
                          mostrarSenha
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    validator: (v) =>
                        v == null || v.trim().length < 6
                            ? 'A senha deve ter pelo menos 6 caracteres'
                            : null,
                  ),
                  const SizedBox(height: 26),
                  ElevatedButton.icon(
                    onPressed: salvar,
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Salvar usuário'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget rotulo(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        texto,
        style: const TextStyle(
          color: Color(0xFF283719),
          fontWeight: FontWeight.w800,
          fontSize: 13,
        ),
      ),
    );
  }
}