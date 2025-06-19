import 'package:flutter/material.dart';
import '../models/estudante.dart';
import '../services/api_service.dart';
import '../utilidade/ThemeData.dart';
import '../widgets/tela_loading.dart';
import 'gabarito_prova.dart';

class SelecionarAluno extends StatefulWidget {
  const SelecionarAluno({Key? key}) : super(key: key);

  @override
  State<SelecionarAluno> createState() => _SelecionarAlunoState();
}

class _SelecionarAlunoState extends State<SelecionarAluno> {
  List<Aluno> _alunos = [];
  bool _carregando = true;
  String? _mensagemErro;

  @override
  void initState() {
    super.initState();
    _carregarAluno();
  }

  Future<void> _carregarAluno() async {
    setState(() {
      _carregando = true;
      _mensagemErro = null;
    });

    try {
      // ⚠️ INTEGRAÇÃO COM API JAVA: Buscar lista de alunos
      // Você pode filtrar por turma se necessário
      final alunos = await ApiService.getAlunos();
      
      setState(() {
        _alunos = alunos;
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _mensagemErro = 'Erro ao carregar alunos: $e';
        _carregando = false;
      });
    }
  }

  void _selecionarAluno(Aluno aluno) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AnswerInputScreen(aluno: aluno),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecionar Aluno'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_carregando) {
      return const LoadingWidget(message: 'Carregando alunos...');
    }

    if (_mensagemErro != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.errorColor,
            ),
            const SizedBox(height: 16),
            Text(
              _mensagemErro!,
              style: AppTheme.subtitleStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _carregarAluno,
              child: const Text('Tentar Novamente'),
            ),
          ],
        ),
      );
    }

    if (_alunos.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Nenhum aluno encontrado',
              style: AppTheme.subtitleStyle,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _carregarAluno,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _alunos.length,
        itemBuilder: (context, index) {
          final student = _alunos[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppTheme.primaryColor,
                child: Text(
                  student.nome.isNotEmpty ? student.nome[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                student.nome,
                style: AppTheme.subtitleStyle,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('RA: ${student.RA}'),
                  if (student.classeNome != null)
                    Text('Turma: ${student.classeNome}'),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _selecionarAluno(student),
            ),
          );
        },
      ),
    );
  }
}

