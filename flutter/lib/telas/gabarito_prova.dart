import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/estudante.dart'; // Usando o modelo unificado
import '../models/materia.dart';
import '../models/turma.dart';
import '../models/prova.dart';
import '../models/gabarito.dart';
import '../services/api_service.dart';
import '../services/ocr_service.dart';
import '../utilidade/ThemeData.dart';
import '../widgets/botao_personalizado.dart';
import '../widgets/tela_loading.dart';

class GabaritoProva extends StatefulWidget {
  final Aluno estudante;
  final Materia? materia;
  final Turma? turma;

  const GabaritoProva({
    Key? key, 
    required this.estudante,
    this.materia,
    this.turma,
  }) : super(key: key);

  @override
  State<GabaritoProva> createState() => _GabaritoProvaState();
}

class _GabaritoProvaState extends State<GabaritoProva> {
  List<Prova> _provas = [];
  Prova? _provaSelecionada;
  List<Gabarito> _gabaritos = [];
  bool _carregando = true;
  bool _enviando = false;
  bool _processandoOcr = false;
  String? _erroMensagem;
  File? _imagemCapturada;

  @override
  void initState() {
    super.initState();
    _carregarProvas();
  }

  Future<void> _carregarProvas() async {
    setState(() {
      _carregando = true;
      _erroMensagem = null;
    });

    try {
      final provas = await ApiService.getExams();
      
      setState(() {
        _provas = provas;
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _erroMensagem = 'Erro ao carregar provas: $e';
        _carregando = false;
      });
    }
  }

  void _selecionarProva(Prova prova) {
    setState(() {
      _provaSelecionada = prova;
      _gabaritos = List.generate(
        prova.totalQuestoes,
        (index) => Gabarito(
          questao: index + 1,
          resposta: '',
          estudanteId: widget.estudante.id,
          provaId: prova.id,
        ),
      );
    });
  }

  void _atualizarResposta(int questao, String resposta) {
    setState(() {
      final index = _gabaritos.indexWhere((g) => g.questao == questao);
      if (index != -1) {
        _gabaritos[index] = _gabaritos[index].copyWith(resposta: resposta);
      }
    });
  }

  Future<void> _capturarGabarito() async {
    // Verificar permissões
    final cameraStatus = await Permission.camera.request();
    final storageStatus = await Permission.storage.request();

    if (!cameraStatus.isGranted || !storageStatus.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permissões de câmera e armazenamento são necessárias'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _processandoOcr = true;
    });

    try {
      final resultado = await OcrService.capturarEProcessarGabarito();
      
      if (resultado != null) {
        setState(() {
          _imagemCapturada = resultado['imagem'];
        });

        final respostasDetectadas = resultado['respostas'] as Map<int, String>;
        final precisao = resultado['precisao'] as double;

        // Atualizar gabaritos com as respostas detectadas
        for (final entry in respostasDetectadas.entries) {
          if (entry.key <= _gabaritos.length) {
            _atualizarResposta(entry.key, entry.value);
          }
        }

        // Mostrar feedback do OCR
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'OCR processado! ${respostasDetectadas.length} respostas detectadas '
              '(Precisão: ${(precisao * 100).toStringAsFixed(1)}%)',
            ),
            backgroundColor: precisao > 0.7 ? Colors.green : Colors.orange,
            duration: const Duration(seconds: 4),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nenhuma resposta foi detectada na imagem'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro no processamento OCR: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _processandoOcr = false;
      });
    }
  }

  Future<void> _salvarGabarito() async {
    if (_provaSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione uma prova primeiro'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Verificar se há pelo menos uma resposta preenchida
    final respostasPreenchidas = _gabaritos.where((g) => g.resposta.isNotEmpty).length;
    if (respostasPreenchidas == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha pelo menos uma resposta'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _enviando = true;
    });

    try {
      // Salvar cada gabarito individualmente
      bool todosSalvos = true;
      for (final gabarito in _gabaritos) {
        if (gabarito.resposta.isNotEmpty) {
          final sucesso = await ApiService.saveGabarito(gabarito);
          if (!sucesso) {
            todosSalvos = false;
            break;
          }
        }
      }

      if (todosSalvos) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gabarito salvo com sucesso! ($respostasPreenchidas/${_gabaritos.length} respostas)',
            ),
            backgroundColor: Colors.green,
          ),
        );
        
        // Voltar para a tela anterior após salvar
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao salvar algumas respostas'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar gabarito: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _enviando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gabarito da Prova'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _construirCorpo(),
    );
  }

  Widget _construirCorpo() {
    return Column(
      children: [
        // Informações do contexto
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: Colors.blue[50],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.materia != null) ...[
                Text(
                  'Matéria: ${widget.materia!.nome}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ],
              if (widget.turma != null) ...[
                Text(
                  'Turma: ${widget.turma!.nomeCompleto}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
              Text(
                'Aluno: ${widget.estudante.nome}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'RA: ${widget.estudante.ra}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: _construirConteudo(),
        ),
      ],
    );
  }

  Widget _construirConteudo() {
    if (_carregando) {
      return const LoadingWidget(message: 'Carregando provas...');
    }

    if (_erroMensagem != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(_erroMensagem!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _carregarProvas,
              child: const Text('Tentar Novamente'),
            ),
          ],
        ),
      );
    }

    if (_provas.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.quiz_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Nenhuma prova disponível'),
          ],
        ),
      );
    }

    if (_provaSelecionada == null) {
      return _construirSelecaoProva();
    }

    return _construirFormularioGabarito();
  }

  Widget _construirSelecaoProva() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selecione a Prova',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _provas.length,
              itemBuilder: (context, index) {
                final prova = _provas[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(
                        '${prova.totalQuestoes}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      prova.titulo,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (prova.descricao.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(prova.descricao),
                        ],
                        const SizedBox(height: 4),
                        Text(
                          '${prova.totalQuestoes} questões',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => _selecionarProva(prova),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirFormularioGabarito() {
    return Column(
      children: [
        // Cabeçalho da prova selecionada
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: Colors.green[50],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _provaSelecionada!.titulo,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              Text(
                '${_provaSelecionada!.totalQuestoes} questões',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),

        // Botões de ação
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: _processandoOcr ? 'Processando...' : 'Capturar Gabarito',
                  onPressed: _processandoOcr ? null : _capturarGabarito,
                  backgroundColor: Colors.orange,
                  icon: _processandoOcr ? null : Icons.camera_alt,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  text: _enviando ? 'Salvando...' : 'Salvar',
                  onPressed: _enviando ? null : _salvarGabarito,
                  backgroundColor: Colors.green,
                  icon: _enviando ? null : Icons.save,
                ),
              ),
            ],
          ),
        ),

        // Imagem capturada (se houver)
        if (_imagemCapturada != null) ...[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                _imagemCapturada!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Lista de questões
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _gabaritos.length,
            itemBuilder: (context, index) {
              final gabarito = _gabaritos[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            '${gabarito.questao}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Row(
                          children: ['A', 'B', 'C', 'D', 'E'].map((opcao) {
                            final selecionada = gabarito.resposta == opcao;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () => _atualizarResposta(gabarito.questao, opcao),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 2),
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: selecionada ? Colors.blue : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: selecionada ? Colors.blue : Colors.grey,
                                    ),
                                  ),
                                  child: Text(
                                    opcao,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: selecionada ? Colors.white : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
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
    );
  }
}

