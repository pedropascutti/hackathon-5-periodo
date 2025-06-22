import 'package:flutter/material.dart';
import '../models/resultado.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class TelaConsultaResultados extends StatefulWidget {
  const TelaConsultaResultados({Key? key}) : super(key: key);

  @override
  State<TelaConsultaResultados> createState() => _TelaConsultaResultadosState();
}

class _TelaConsultaResultadosState extends State<TelaConsultaResultados> {
  List<MediaTurma> _mediasTurmas = [];
  bool _carregando = true;
  String? _mensagemErro;

  @override
  void initState() {
    super.initState();
    _carregarResultados();
  }

  Future<void> _carregarResultados() async {
    setState(() {
      _carregando = true;
      _mensagemErro = null;
    });

    try {
      final usuario = StorageService.getCurrentUser();
      if (usuario != null) {
        final medias = await ApiService.obterResultadosTurmas(usuario.id);
        
        setState(() {
          _mediasTurmas = medias.cast<MediaTurma>();
          _carregando = false;
        });
      } else {
        setState(() {
          _mensagemErro = 'Usuário não encontrado';
          _carregando = false;
        });
      }
    } catch (e) {
      setState(() {
        _mensagemErro = 'Erro ao carregar resultados: $e';
        _carregando = false;
      });
    }
  }

  Color _obterCorMedia(double media) {
    if (media >= 8.0) return Colors.green;
    if (media >= 6.0) return Colors.orange;
    return Colors.red;
  }

  IconData _obterIconeMedia(double media) {
    if (media >= 8.0) return Icons.sentiment_very_satisfied;
    if (media >= 6.0) return Icons.sentiment_neutral;
    return Icons.sentiment_dissatisfied;
  }

  void _mostrarDetalhes(MediaTurma mediaTurma) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _construirModalDetalhes(mediaTurma),
    );
  }

  Widget _construirModalDetalhes(MediaTurma mediaTurma) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle do modal
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Cabeçalho
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  mediaTurma.nomeTurma,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  mediaTurma.nomeMateria,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _construirEstatistica(
                      'Média Geral',
                      mediaTurma.mediaFormatada,
                      _obterCorMedia(mediaTurma.mediaGeral),
                    ),
                    _construirEstatistica(
                      'Participação',
                      '${mediaTurma.percentualParticipacao.toStringAsFixed(0)}%',
                      Colors.blue,
                    ),
                    _construirEstatistica(
                      'Avaliados',
                      '${mediaTurma.alunosAvaliados}/${mediaTurma.totalAlunos}',
                      Colors.purple,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const Divider(),
          
          // Lista de resultados individuais
          Expanded(
            child: mediaTurma.resultados.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhum resultado encontrado',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: mediaTurma.resultados.length,
                    itemBuilder: (context, index) {
                      final resultado = mediaTurma.resultados[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _obterCorMedia(resultado.nota),
                            child: Text(
                              resultado.notaFormatada,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          title: Text(resultado.nomeAluno),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('RA: ${resultado.raAluno}'),
                              Text(
                                '${resultado.questoesCorretas}/${resultado.totalQuestoes} questões corretas',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _obterIconeMedia(resultado.nota),
                                color: _obterCorMedia(resultado.nota),
                              ),
                              Text(
                                '${resultado.percentualAcerto.toStringAsFixed(0)}%',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _construirEstatistica(String titulo, String valor, Color cor) {
    return Column(
      children: [
        Text(
          valor,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: cor,
          ),
        ),
        Text(
          titulo,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultar Resultados'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarResultados,
          ),
        ],
      ),
      body: _construirCorpo(),
    );
  }

  Widget _construirCorpo() {
    if (_carregando) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Carregando resultados...'),
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
              onPressed: _carregarResultados,
              child: const Text('Tentar Novamente'),
            ),
          ],
        ),
      );
    }

    if (_mediasTurmas.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assessment_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Nenhum resultado encontrado',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Corrija algumas provas para ver os resultados aqui',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _carregarResultados,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Médias das Suas Turmas',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Toque em uma turma para ver detalhes',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: _mediasTurmas.length,
                itemBuilder: (context, index) {
                  final mediaTurma = _mediasTurmas[index];
                  final corMedia = _obterCorMedia(mediaTurma.mediaGeral);
                  
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    child: InkWell(
                      onTap: () => _mostrarDetalhes(mediaTurma),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        mediaTurma.nomeTurma,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        mediaTurma.nomeMateria,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: corMedia,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        mediaTurma.mediaFormatada,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Icon(
                                      _obterIconeMedia(mediaTurma.mediaGeral),
                                      color: corMedia,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _construirInfoCard(
                                    'Total de Alunos',
                                    mediaTurma.totalAlunos.toString(),
                                    Icons.people,
                                    Colors.blue,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _construirInfoCard(
                                    'Avaliados',
                                    mediaTurma.alunosAvaliados.toString(),
                                    Icons.assignment_turned_in,
                                    Colors.green,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _construirInfoCard(
                                    'Participação',
                                    '${mediaTurma.percentualParticipacao.toStringAsFixed(0)}%',
                                    Icons.trending_up,
                                    Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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

  Widget _construirInfoCard(String titulo, String valor, IconData icone, Color cor) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: cor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icone, color: cor, size: 20),
          const SizedBox(height: 4),
          Text(
            valor,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: cor,
              fontSize: 14,
            ),
          ),
          Text(
            titulo,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

