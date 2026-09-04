import 'package:flutter/material.dart';

import 'models/safra.dart';
import 'models/unidade.dart';
import 'models/equipamento.dart';
import 'models/unidade_medida.dart';
import 'models/tipo_informacao.dart';
import 'models/indicador.dart';
import 'models/medicao.dart';

import 'screens/tela_principal.dart';

void main() {
  // Criando uma safra
  final safra = Safra(
    id: 1,
    nomeSafra: 'Safra 2026/2027',
    dataInicio: DateTime(2026, 4, 1),
    dataFim: DateTime(2027, 3, 31),
  );

  // Criando uma unidade
  final unidade = Unidade(
    id: 1,
    nome: 'Usina Principal',
  );

  // Criando um equipamento
  final equipamento = Equipamento(
    id: 1,
    nome: 'Equipamento 01',
    unidade: unidade,
  );

  // Criando uma unidade de medida
  final unidadeMedida = UnidadeMedida(
    id: 1,
    nome: 'Tonelada',
    simbolo: 't',
  );

  // Criando um tipo de informação
  final tipoInformacao = TipoInformacao(
    id: 1,
    nome: 'Produção',
    unidadeMedida: unidadeMedida,
  );

  // Criando uma medição
  final registro = Medicao(
    id: 1,
    safra: safra,
    unidade: unidade,
    tipoInformacao: tipoInformacao,
    valor: 850.5,
    data: DateTime.now(),
  );

  // Criando um indicador
  final indicador = Indicador(
    id: 1,
    nome: 'Produção de açúcar',
    descricao: 'Quantidade produzida de açúcar',
    url: '/indicadores/producao',
  );

  // Teste dos modelos
  debugPrint('--- TESTE DO PROJETO ---');
  debugPrint('Safra: ${safra.nomeSafra}');
  debugPrint('Unidade: ${unidade.nome}');
  debugPrint('Equipamento: ${equipamento.nome}');
  debugPrint('Unidade de medida: ${unidadeMedida.nome}');
  debugPrint('Tipo de informação: ${tipoInformacao.nome}');
  debugPrint('Valor: ${registro.valor}');
  debugPrint('Indicador: ${indicador.nome}');

  runApp(const UsinaApp());
}

class UsinaApp extends StatelessWidget {
  const UsinaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Usina App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const TelaPrincipal(),
    );
  }
}