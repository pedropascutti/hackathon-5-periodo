import 'package:flutter/material.dart';
import '../models/estudante.dart';
import '../models/materia.dart';
import '../models/turma.dart';
import '../services/api_service.dart';
import '../utilidade/ThemeData.dart';
import '../widgets/tela_loading.dart';
import 'gabarito_prova.dart';

class TelaSelecaoAlunos extends StatefulWidget {
  final Materia materia;
  final Turma turma;

  const TelaSelecaoAlunos({
    Key? key,
    required this.materia,
    required this.turma,
  }) : super(key: key);

  @override
  State<TelaSelecaoAlunos> createState() => _TelaSelecaoAlunosState();
}

class _TelaSelecaoAlunosState extends State<TelaSelecaoAlunos> {
  List<Aluno> _alunos = [];
  List<Aluno> _alunosFiltrados = [];
  bool _carregando = true;
  String? _mensagemErro;
  final TextEditingController _controllerBusca = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarAlunos();
    _controllerBusca.addListener(_filtrarAlunos);
  }

  @override
  void dispose() {
    _controllerBusca.dispose();
    super.dispose();
  }

  Future<void> _carregarAlunos() async {
    setState(() {
      _carregando = true;
      _mensagemErro = null;
    });

    try {
      final alunos = await ApiService.obterAlunosTurma(widget.turma.id);
      setState(() {
        _alunos = alunos;
        _alunosFiltrados = alunos;
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _mensagemErro = 'Erro ao carregar alunos: $e';
        _carregando = false;
      });
    }
  }

  void _filtrarAlunos() {
    final termo = _controllerBusca.text.toLowerCase();
    setState(() {
      if (termo.isEmpty) {
        _alunosFiltrados = _alunos;
      } else {
        _alunosFiltrados = _alunos.where((aluno) {
          return aluno.nome.toLowerCase().contains(termo) ||
                 aluno.ra.toLowerCase().contains(termo);
        }).toList();
      }
    });
  }

  void _selecionarAluno(Aluno aluno) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GabaritoProva(
          estudante: aluno,
          materia: widget.materia,
          turma: widget.turma,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecionar Aluno'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Informações do contexto
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Matéria: ${widget.materia.nome}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  'Turma: ${widget.turma.nomeCompleto}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),

          // Campo de busca
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: TextField(
              controller: _controllerBusca,
              decoration: InputDecoration(
                hintText: 'Buscar por nome ou RA...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                suffixIcon: _controllerBusca.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controllerBusca.clear();
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Lista de alunos
          Expanded(
            child: _construirCorpo(),
          ),
        ],
      ),
    );
  }

  Widget _construirCorpo() {
    if (_carregando) {
      return const LoadingWidget(message: 'Carregando alunos...');
    }

    if (_mensagemErro != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(_mensagemErro!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _carregarAlunos,
              child: const Text('Tentar Novamente'),
            ),
          ],
        ),
      );
    }

    if (_alunosFiltrados.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _controllerBusca.text.isNotEmpty ? Icons.search_off : Icons.people_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              _controllerBusca.text.isNotEmpty
                  ? 'Nenhum aluno encontrado para "${_controllerBusca.text}"'
                  : 'Nenhum aluno disponível nesta turma',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            if (_controllerBusca.text.isNotEmpty) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _controllerBusca.clear(),
                child: const Text('Limpar Busca'),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _alunosFiltrados.length,
      itemBuilder: (context, index) {
        final aluno = _alunosFiltrados[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                aluno.nome.isNotEmpty ? aluno.nome[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              aluno.nome,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('RA: ${aluno.ra}'),
                if (aluno.email != null && aluno.email!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Email: ${aluno.email}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _selecionarAluno(aluno),
          ),
        );
      },
    );
  }
}

