import 'package:flutter/material.dart';
import '../models/materia.dart';
import '../models/turma.dart';
import '../services/api_service.dart';
import 'tela_selecao_alunos.dart';

class TelaSelecaoTurmas extends StatefulWidget {
  final Materia materia;

  const TelaSelecaoTurmas({
    Key? key,
    required this.materia,
  }) : super(key: key);

  @override
  State<TelaSelecaoTurmas> createState() => _TelaSelecaoTurmasState();
}

class _TelaSelecaoTurmasState extends State<TelaSelecaoTurmas> {
  List<Turma> _turmas = [];
  bool _carregando = true;
  String? _mensagemErro;

  @override
  void initState() {
    super.initState();
    _carregarTurmas();
  }

  Future<void> _carregarTurmas() async {
    setState(() {
      _carregando = true;
      _mensagemErro = null;
    });

    try {
      final turmas = await ApiService.obterTurmasMateria(widget.materia.id);
      
      setState(() {
        _turmas = turmas;
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _mensagemErro = 'Erro ao carregar turmas: $e';
        _carregando = false;
      });
    }
  }

  void _selecionarTurma(Turma turma) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TelaSelecaoAlunos(
          materia: widget.materia,
          turma: turma,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecionar Turma'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _construirCorpo(),
    );
  }

  Widget _construirCorpo() {
    return Column(
      children: [
        // Informações da matéria selecionada
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: Colors.blue[50],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Matéria Selecionada:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.materia.nome,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Text(
                'Código: ${widget.materia.codigo}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),

        // Lista de turmas
        Expanded(
          child: _construirListaTurmas(),
        ),
      ],
    );
  }

  Widget _construirListaTurmas() {
    if (_carregando) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Carregando turmas...'),
          ],
        ),
      );
    }

    if (_mensagemErro != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              _mensagemErro!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _carregarTurmas,
              child: const Text('Tentar Novamente'),
            ),
          ],
        ),
      );
    }

    if (_turmas.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.class_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Nenhuma turma encontrada para esta matéria',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _carregarTurmas,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Turmas Disponíveis',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Selecione uma turma para ver os alunos',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: _turmas.length,
                itemBuilder: (context, index) {
                  final turma = _turmas[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: 25,
                        child: Text(
                          turma.periodo.isNotEmpty 
                              ? turma.periodo[0].toUpperCase()
                              : 'T',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      title: Text(
                        turma.nomeCompleto,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text('${turma.semestre}º Semestre - ${turma.ano}'),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(
                                Icons.people,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${turma.totalAlunos} alunos',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.green,
                      ),
                      onTap: () => _selecionarTurma(turma),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

