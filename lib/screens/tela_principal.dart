import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';
import 'cadastros/cadastro_indicador.dart';
import 'cadastros/cadastro_usuario.dart';

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() =>
      _TelaPrincipalState();
}

class _TelaPrincipalState
    extends State<TelaPrincipal> {
  bool cadastroAberto = false;

  String emailUsuario = '';

  @override
  void initState() {
    super.initState();

    carregarDadosUsuario();
  }

  Future<void> carregarDadosUsuario() async {
    final prefs =
        await SharedPreferences.getInstance();

    final email =
        prefs.getString('emailUsuario');

    if (!mounted) return;

    setState(() {
      emailUsuario = email ?? '';
    });
  }

  Future<void> sair() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      'loginRealizado',
      false,
    );

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const LoginPage(),
      ),
    );
  }

  Widget montarMenu() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.account_circle,
                size: 50,
              ),

              const SizedBox(height: 8),

              const Text(
                'Menu Principal',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),

              if (emailUsuario.isNotEmpty)
                Text(
                  emailUsuario,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
            ],
          ),
        ),

        // INÍCIO
        const ListTile(
          leading: Icon(Icons.home),
          title: Text('Início'),
        ),

        // CADASTRO
        ListTile(
          leading:
              const Icon(Icons.app_registration),
          title: const Text('Cadastro'),
          trailing: Icon(
            cadastroAberto
                ? Icons.expand_less
                : Icons.expand_more,
          ),
          onTap: () {
            setState(() {
              cadastroAberto =
                  !cadastroAberto;
            });
          },
        ),

        // SUBITENS
        if (cadastroAberto) ...[
          const ListTile(
            leading:
                Icon(Icons.chevron_right),
            title: Text('Unidade'),
          ),

          const ListTile(
            leading:
                Icon(Icons.chevron_right),
            title: Text('Setor'),
          ),

          const ListTile(
            leading:
                Icon(Icons.chevron_right),
            title: Text('Equipamento'),
          ),

          // INDICADOR
          ListTile(
            leading:
                const Icon(Icons.chevron_right),
            title:
                const Text('Indicador'),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const CadastroIndicadorPage(),
                ),
              );
            },
          ),

          // USUÁRIO
          ListTile(
            leading:
                const Icon(Icons.chevron_right),
            title:
                const Text('Usuário'),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const CadastroUsuarioPage(),
                ),
              );
            },
          ),

          const ListTile(
            leading:
                Icon(Icons.chevron_right),
            title:
                Text('Tipo de Medição'),
          ),

          const ListTile(
            leading:
                Icon(Icons.chevron_right),
            title:
                Text('Parâmetro'),
          ),
        ],

        const Divider(),

        // LOGOUT
        ListTile(
          leading: const Icon(
            Icons.logout,
          ),
          title: const Text('Sair'),
          onTap: sair,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usina App'),
      ),

      drawer: Drawer(
        child: montarMenu(),
      ),

      body: const Center(
        child: Text(
          'Tela Principal',
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}