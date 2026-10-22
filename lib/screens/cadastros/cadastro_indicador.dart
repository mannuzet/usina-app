import 'package:flutter/material.dart';
import 'package:usina_app/models/indicador.dart';

class CadastroIndicadorPage extends StatefulWidget {
  const CadastroIndicadorPage({super.key});

  @override
  State<CadastroIndicadorPage> createState() =>
      _CadastroIndicadorPageState();
}

class _CadastroIndicadorPageState
    extends State<CadastroIndicadorPage> {
  final formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final descricaoController = TextEditingController();
  final urlController = TextEditingController();

  @override
  void dispose() {
    nomeController.dispose();
    descricaoController.dispose();
    urlController.dispose();
    super.dispose();
  }

  void salvar() {
    if (!formKey.currentState!.validate()) return;

    final indicador = Indicador(
      nome: nomeController.text.trim(),
      descricao: descricaoController.text.trim(),
      url: urlController.text.trim(),
    );

    debugPrint('Nome: ${indicador.nome}');
    debugPrint('Descrição: ${indicador.descricao}');
    debugPrint('URL: ${indicador.url}');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Indicador cadastrado com sucesso!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Indicador'),
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
                            Icons.speed_outlined,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Novo indicador',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 21,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Preencha os dados para cadastrar.',
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
                  rotulo('Nome do indicador'),
                  TextFormField(
                    controller: nomeController,
                    decoration: const InputDecoration(
                      hintText: 'Ex.: Eficiência operacional',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty
                            ? 'Informe o nome'
                            : null,
                  ),
                  const SizedBox(height: 18),
                  rotulo('Descrição'),
                  TextFormField(
                    controller: descricaoController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Descreva o indicador',
                      prefixIcon: Icon(Icons.notes_rounded),
                      alignLabelWithHint: true,
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty
                            ? 'Informe a descrição'
                            : null,
                  ),
                  const SizedBox(height: 18),
                  rotulo('URL de referência'),
                  TextFormField(
                    controller: urlController,
                    keyboardType: TextInputType.url,
                    decoration: const InputDecoration(
                      hintText: 'https://exemplo.com',
                      prefixIcon: Icon(Icons.link_rounded),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Informe a URL';
                      }

                      final uri = Uri.tryParse(v.trim());

                      if (uri == null ||
                          !uri.hasScheme ||
                          !uri.hasAuthority) {
                        return 'Informe uma URL válida';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 26),
                  ElevatedButton.icon(
                    onPressed: salvar,
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Salvar indicador'),
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