import 'package:flutter/material.dart';

import 'cadastros/cadastro_indicador.dart';
import 'cadastros/cadastro_usuario.dart';

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  bool cadastroAberto = false;

  Widget montarMenu() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          child: Text(
            'Menu Principal',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
        ),

        // INÍCIO
        const ListTile(
          leading: Icon(Icons.home),
          title: Text('Início'),
        ),

        // CADASTRO
        ListTile(
          leading: const Icon(Icons.app_registration),
          title: const Text('Cadastro'),
          trailing: Icon(
            cadastroAberto
                ? Icons.expand_less
                : Icons.expand_more,
          ),
          onTap: () {
            setState(() {
              cadastroAberto = !cadastroAberto;
            });
          },
        ),

        // SUBITENS DO CADASTRO
        if (cadastroAberto) ...[
          const ListTile(
            leading: Icon(Icons.chevron_right),
            title: Text('Unidade'),
          ),

          const ListTile(
            leading: Icon(Icons.chevron_right),
            title: Text('Setor'),
          ),

          const ListTile(
            leading: Icon(Icons.chevron_right),
            title: Text('Equipamento'),
          ),

          // INDICADOR
          ListTile(
            leading: const Icon(Icons.chevron_right),
            title: const Text('Indicador'),
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
            leading: const Icon(Icons.chevron_right),
            title: const Text('Usuário'),
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
            leading: Icon(Icons.chevron_right),
            title: Text('Tipo de Medição'),
          ),

          const ListTile(
            leading: Icon(Icons.chevron_right),
            title: Text('Parâmetro'),
          ),
        ],
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