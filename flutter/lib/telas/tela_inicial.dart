import 'package:flutter/material.dart';
import 'package:meu_app_flutter/modelos/usuario.dart';
import 'package:meu_app_flutter/servicos/servico_api.dart';
import 'package:meu_app_flutter/servicos/servico_armazenamento.dart';
import 'package:meu_app_flutter/utilitarios/constantes.dart';
import 'package:meu_app_flutter/utilitarios/tema.dart';
import 'package:meu_app_flutter/componentes/botao_personalizado.dart';
import 'package:meu_app_flutter/telas/tela_login.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({Key? key}) : super(key: key);

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  Usuario? _usuarioAtual;

  @override
  void initState() {
    super.initState();
    _carregarDadosUsuario();
  }

  void _carregarDadosUsuario() {
    _usuarioAtual = ServicoArmazenamento.obterUsuarioAtual();
    setState(() {});
  }

  Future<void> _sair() async {
    final deveDeslogar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Saída'),
        content: const Text('Tem certeza que deseja sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );

    if (deveDeslogar == true) {
      await ServicoArmazenamento.limparDadosUsuario();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const TelaLogin()),
        );
      }
    }
  }

  void _navegarParaSelecaoMateriasTurmas() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Navegação para seleção de matérias e turmas'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringsApp.nomeApp),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _sair,
            tooltip: StringsApp.sair,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bem-vindo!',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Usuário: ${_usuarioAtual?.nomeUsuario ?? 'N/A'}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      'Perfil: ${_usuarioAtual?.papel ?? 'N/A'}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            Text(
              'Funcionalidades',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            BotaoPersonalizado(
              texto: 'Inserir Respostas de Avaliação',
              aoClicar: _navegarParaSelecaoMateriasTurmas,
            ),
            const SizedBox(height: 16),

            BotaoPersonalizado(
              texto: 'Consultar Resultados',
              aoClicar: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Funcionalidade em desenvolvimento'),
                  ),
                );
              },
              corFundo: TemaApp.corSecundaria,
            ),
            
            const SizedBox(height: 16),

            if (_usuarioAtual?.papel == 'PROFESSOR' || _usuarioAtual?.papel == 'ADMINISTRADOR')
              BotaoPersonalizado(
                texto: 'Gerenciar Provas',
                aoClicar: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Funcionalidade em desenvolvimento'),
                    ),
                  );
                },
                corFundo: Colors.purple,
              ),

          ],
        ),
      ),
    );
  }
}


