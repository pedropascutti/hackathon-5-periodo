import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/storage_service.dart';
import '../services/api_service.dart';
import '../utilidade/constants.dart';
import '../utilidade/ThemeData.dart';
import '../widgets/botao_personalizado.dart';
import 'tela_login.dart';
import 'tela_selecao_materias.dart';
import 'tela_consulta_resultados.dart';

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

  void _navegarCorrigirProvas() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const TelaSelecaoMaterias(),
      ),
    );
  }

  void _navegarConsultarResultados() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const TelaConsultaResultados(),
      ),
    );
  }

  void _alternarModoSimulacao() {
    final modoAtual = ApiService.isSimulationMode;
    ApiService.setSimulationMode(!modoAtual);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          modoAtual 
              ? 'Modo simulação DESATIVADO - Usando API real'
              : 'Modo simulação ATIVADO - Usando dados fictícios',
        ),
        backgroundColor: modoAtual ? Colors.orange : Colors.green,
      ),
    );
    
    setState(() {}); // Atualizar a interface
  }

  @override
  Widget build(BuildContext context) {
    final isSimulationMode = ApiService.isSimulationMode;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
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
            // Card de boas-vindas
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 25,
                          child: Text(
                            _currentUser?.nome.isNotEmpty == true 
                                ? _currentUser!.nome[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bem-vindo!',
                                style: AppTheme.titleStyle,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _currentUser?.nome ?? 'N/A',
                                style: AppTheme.subtitleStyle.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Perfil: ${_currentUser?.cargo ?? 'N/A'}',
                                style: AppTheme.bodyStyle.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Título das funcionalidades
            Text(
              'Funcionalidades',
              style: AppTheme.titleStyle.copyWith(
                color: Colors.blue[800],
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 16),
            
            // Botões principais
            CustomButton(
              text: 'Corrigir Provas',
              onPressed: _navegarCorrigirProvas,
              icon: Icons.edit_note,
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Consultar Resultados',
              onPressed: _navegarConsultarResultados,
              backgroundColor: AppTheme.secondaryColor,
              icon: Icons.assessment,
            ),
            
            if (_currentUser?.cargo == 'ADMINISTRADOR') ...[
              const SizedBox(height: 16),
              CustomButton(
                text: 'Gerenciar Provas',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Funcionalidade em desenvolvimento'),
                    ),
                  );
                },
                backgroundColor: Colors.purple,
                icon: Icons.quiz,
              ),
            ],

            const Spacer(),
            
            // Card de informações do sistema
            Card(
              color: isSimulationMode ? Colors.orange[50] : Colors.green[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isSimulationMode ? Icons.science : Icons.cloud_done,
                          color: isSimulationMode ? Colors.orange : Colors.green,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Status do Sistema',
                          style: AppTheme.subtitleStyle.copyWith(
                            color: isSimulationMode ? Colors.orange[800] : Colors.green[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isSimulationMode 
                          ? 'Modo Simulação Ativo'
                          : 'Conectado à API Real',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSimulationMode ? Colors.orange[700] : Colors.green[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isSimulationMode
                          ? 'Usando dados fictícios para testes'
                          : 'API Base URL: ${ApiConstants.baseUrl}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _alternarModoSimulacao,
                        icon: Icon(
                          isSimulationMode ? Icons.cloud : Icons.science,
                          size: 16,
                        ),
                        label: Text(
                          isSimulationMode 
                              ? 'Usar API Real'
                              : 'Ativar Simulação',
                          style: const TextStyle(fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSimulationMode ? Colors.green : Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

