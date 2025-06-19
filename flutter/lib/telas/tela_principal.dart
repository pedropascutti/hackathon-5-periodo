import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/storage_service.dart';
import '../utilidade/constants.dart';
import '../utilidade/ThemeData.dart';
import '../widgets/botao_personalizado.dart';
import 'tela_login.dart';
import 'selecionar_aluno.dart';

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({Key? key}) : super(key: key);

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  usuario? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    _currentUser = StorageService.getCurrentUser();
    setState(() {});
  }

  Future<void> _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Logout'),
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

    if (shouldLogout == true) {
      await StorageService.clearUserData();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const TelaLogin()),
        );
      }
    }
  }

  void _navegarSelecaoAluno() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SelecionarAluno(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: AppStrings.logout,
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
                      style: AppTheme.titleStyle,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Usuário: ${_currentUser?.nome ?? 'N/A'}',
                      style: AppTheme.subtitleStyle,
                    ),
                    Text(
                      'Perfil: ${_currentUser?.cargo ?? 'N/A'}',
                      style: AppTheme.bodyStyle,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Funcionalidades',
              style: AppTheme.titleStyle,
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Inserir Respostas de Avaliação',
              onPressed: _navegarSelecaoAluno,
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Consultar Resultados',
              onPressed: () {
                // ⚠️ INTEGRAÇÃO COM API JAVA: Implementar consulta de resultados
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Funcionalidade em desenvolvimento'),
                  ),
                );
              },
              backgroundColor: AppTheme.secondaryColor,
            ),

            const Spacer(),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informações de Conexão',
                    style: AppTheme.subtitleStyle,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'API Base URL: ${ApiConstants.baseUrl}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    'Token: ${StorageService.getUserToken()?.substring(0, 20) ?? 'N/A'}...',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

