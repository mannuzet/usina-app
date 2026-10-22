import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';
import 'cadastros/cadastro_indicador.dart';
import 'cadastros/cadastro_usuario.dart';

const Color verdeEscuro = Color(0xFF172514);
const Color verdeMusgo = Color(0xFF283719);
const Color verdeMedio = Color(0xFF64764A);
const Color fundo = Color(0xFFF3F4ED);

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  String emailUsuario = '';
  String telaSelecionada = 'Início';

  @override
  void initState() {
    super.initState();
    carregarDadosUsuario();
  }

  Future<void> carregarDadosUsuario() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      emailUsuario = prefs.getString('emailUsuario') ?? '';
    });
  }

  Future<void> sair() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loginRealizado', false);

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginPage(),
      ),
      (_) => false,
    );
  }

  void abrirCadastro(String nome) {
    setState(() => telaSelecionada = nome);

    if (nome == 'Indicador') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const CadastroIndicadorPage(),
        ),
      );
    } else if (nome == 'Usuário') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const CadastroUsuarioPage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('A tela "$nome" ainda não foi conectada.'),
        ),
      );
    }
  }

  Widget cartaoResumo({
    required IconData icon,
    required String titulo,
    required String descricao,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(
          color: Color(0xFFE2E5D9),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFE9EDDF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: verdeMusgo,
                  size: 25,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: verdeEscuro,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                descricao,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF73796C),
                  height: 1.4,
                ),
              ),
              const Spacer(),
              const Row(
                children: [
                  Text(
                    'Acessar',
                    style: TextStyle(
                      color: verdeMedio,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(width: 5),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 15,
                    color: verdeMedio,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;
    final colunas = largura >= 1000
        ? 4
        : largura >= 650
            ? 2
            : 1;

    return Scaffold(
      backgroundColor: fundo,
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.eco_outlined, size: 25),
            SizedBox(width: 10),
            Text(
              'USINA APP',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                letterSpacing: 1.3,
              ),
            ),
          ],
        ),
        actions: [
          if (largura > 500)
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Center(
                child: Text(
                  emailUsuario,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFFF9FAF6),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(22, 26, 22, 24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [verdeEscuro, verdeMusgo],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: Color(0xFF536342),
                      child: Icon(
                        Icons.person_outline,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Menu principal',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      emailUsuario.isEmpty
                          ? 'Bem-vindo ao Usina App'
                          : emailUsuario,
                      style: const TextStyle(
                        color: Color(0xFFD5DDC9),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              itemMenu(
                Icons.dashboard_outlined,
                'Início',
                onTap: () {
                  setState(() => telaSelecionada = 'Início');
                  Navigator.pop(context);
                },
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 18, 20, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'GERENCIAMENTO',
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 1.5,
                      color: Color(0xFF828879),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              itemMenu(
                Icons.speed_outlined,
                'Indicador',
                onTap: () {
                  Navigator.pop(context);
                  abrirCadastro('Indicador');
                },
              ),
              itemMenu(
                Icons.people_outline,
                'Usuário',
                onTap: () {
                  Navigator.pop(context);
                  abrirCadastro('Usuário');
                },
              ),
              itemMenu(
                Icons.factory_outlined,
                'Equipamento',
                onTap: () {
                  Navigator.pop(context);
                  abrirCadastro('Equipamento');
                },
              ),
              itemMenu(
                Icons.apartment_outlined,
                'Unidade',
                onTap: () {
                  Navigator.pop(context);
                  abrirCadastro('Unidade');
                },
              ),
              itemMenu(
                Icons.analytics_outlined,
                'Medições',
                onTap: () {
                  Navigator.pop(context);
                  abrirCadastro('Medições');
                },
              ),
              const Spacer(),
              const Divider(height: 1),
              itemMenu(
                Icons.logout_rounded,
                'Sair',
                cor: const Color(0xFF9B3B32),
                onTap: sair,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(26),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      gradient: const LinearGradient(
                        colors: [
                          verdeEscuro,
                          verdeMusgo,
                          Color(0xFF465737),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x22283519),
                          blurRadius: 18,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'PAINEL DE CONTROLE',
                                style: TextStyle(
                                  color: Color(0xFFC8D3B7),
                                  fontSize: 10,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Bem-vindo ao Usina App',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                emailUsuario.isEmpty
                                    ? 'Gerencie as informações da sua usina em um só lugar.'
                                    : 'Olá, $emailUsuario. Gerencie as informações da sua usina.',
                                style: const TextStyle(
                                  color: Color(0xFFE1E6D8),
                                  fontSize: 13,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (largura > 600) ...[
                          const SizedBox(width: 20),
                          const Icon(
                            Icons.agriculture_outlined,
                            color: Color(0x66FFFFFF),
                            size: 82,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Acesso rápido',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      color: verdeEscuro,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Selecione uma área para continuar.',
                    style: TextStyle(
                      color: Color(0xFF72796A),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 18),
                  GridView.count(
                    crossAxisCount: colunas,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: largura < 650
                        ? 2.1
                        : largura < 1000
                            ? 1.35
                            : 1.15,
                    children: [
                      cartaoResumo(
                        icon: Icons.speed_outlined,
                        titulo: 'Indicadores',
                        descricao: 'Cadastre e organize indicadores.',
                        onTap: () => abrirCadastro('Indicador'),
                      ),
                      cartaoResumo(
                        icon: Icons.people_outline,
                        titulo: 'Usuários',
                        descricao: 'Gerencie os dados de acesso.',
                        onTap: () => abrirCadastro('Usuário'),
                      ),
                      cartaoResumo(
                        icon: Icons.factory_outlined,
                        titulo: 'Equipamentos',
                        descricao: 'Acesse os equipamentos da usina.',
                        onTap: () => abrirCadastro('Equipamento'),
                      ),
                      cartaoResumo(
                        icon: Icons.analytics_outlined,
                        titulo: 'Medições',
                        descricao: 'Consulte a área de medições.',
                        onTap: () => abrirCadastro('Medições'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8ECDF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.eco_outlined,
                          color: verdeMusgo,
                          size: 28,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Tecnologia e organização para apoiar a rotina da usina.',
                            style: TextStyle(
                              color: verdeEscuro,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget itemMenu(
    IconData icon,
    String titulo, {
    required VoidCallback onTap,
    Color cor = verdeMusgo,
  }) {
    final selecionado = telaSelecionada == titulo;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 2,
      ),
      child: ListTile(
        selected: selecionado,
        selectedTileColor: const Color(0xFFE8ECDF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        leading: Icon(icon, color: cor),
        title: Text(
          titulo,
          style: TextStyle(
            color: cor,
            fontSize: 14,
            fontWeight:
                selecionado ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}