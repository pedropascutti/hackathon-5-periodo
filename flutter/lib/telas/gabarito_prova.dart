import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/estudante.dart';
import '../models/prova.dart';
import '../models/gabarito.dart';
import '../services/api_service.dart';
import '../services/ocr_service.dart';
import '../utilidade/ThemeData.dart';
import '../widgets/botao_personalizado.dart';
import '../widgets/tela_loading.dart';

class AnswerInputScreen extends StatefulWidget {
  final Aluno aluno;

  const AnswerInputScreen({Key? key, required this.aluno}) : super(key: key);

  @override
  State<AnswerInputScreen> createState() => _AnswerInputScreenState();
}

class _AnswerInputScreenState extends State<AnswerInputScreen> {
  List<Prova> _provas = [];
  Prova? _selecionarProva;
  List<Gabarito> _gabaritos = [];
  bool _carregando = true;
  bool _enviando = false;
  bool _ProcessandoOcr = false;
  String? _erroMensagem;
  File? _imagemCapturada;

  @override
  void initState() {
    super.initState();
    _carregarProva();
  }

  Future<void> _carregarProva() async {
    setState(() {
      _carregando = true;
      _erroMensagem = null;
    });

    try {
      final provas = await ApiService.getProvas();
      
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

  void _selecaoProva(Prova prova) {
    setState(() {
      _selecionarProva = prova;
      _gabaritos = List.generate(
        prova.questoes,
        (index) => Gabarito(numeroQuestao: index + 1, selecionarOpcao: ''),
      );
      _imagemCapturada = null;
    });
  }

  void _atualizarGabarito(int questionIndex, String option) {
    setState(() {
      _gabaritos[questionIndex] = Gabarito(
        numeroQuestao: questionIndex + 1,
        selecionarOpcao: option,
      );
    });
  }
  Future<bool> _requestPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final storageStatus = await Permission.storage.request();
    
    return cameraStatus.isGranted && storageStatus.isGranted;
  }
  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Câmera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _captureFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeria'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancelar'),
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }
  Future<void> _captureFromCamera() async {
    final hasPermission = await _requestPermissions();
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permissões de câmera necessárias'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    setState(() {
      _ProcessandoOcr = true;
    });

    try {
      final imageFile = await OcrService.captureImageFromCamera();
      if (imageFile != null) {
        await _processImageWithOcr(imageFile);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao capturar imagem: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    } finally {
      setState(() {
        _ProcessandoOcr = false;
      });
    }
  }
  Future<void> _pickFromGallery() async {
    setState(() {
      _ProcessandoOcr = true;
    });

    try {
      final imageFile = await OcrService.pickImageFromGallery();
      if (imageFile != null) {
        await _processImageWithOcr(imageFile);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao selecionar imagem: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    } finally {
      setState(() {
        _ProcessandoOcr = false;
      });
    }
  }
  Future<void> _processImageWithOcr(File imageFile) async {
    try {
      final recognizedText = await OcrService.recognizeTextFromImage(imageFile);
      
      if (recognizedText.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nenhum texto foi reconhecido na imagem'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return;
      }
      final recognizedAnswers = OcrService.processGabaritoTextAdvanced(
        recognizedText, 
        _selecionarProva!.questoes
      );
      final validatedAnswers = OcrService.validateAndCorrectAnswers(
        recognizedAnswers, 
        _selecionarProva!.questoes
      );
      final stats = OcrService.getRecognitionStats(
        recognizedAnswers, 
        _selecionarProva!.questoes
      );

      setState(() {
        _gabaritos = validatedAnswers;
        _imagemCapturada = imageFile;
      });
      _showOcrResultDialog(recognizedText, stats);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro no processamento OCR: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }
  void _showOcrResultDialog(String recognizedText, Map<String, dynamic> stats) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Resultado do Reconhecimento'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Questões reconhecidas: ${stats['recognized']}/${stats['total']}'),
                Text('Precisão: ${stats['accuracy']}%'),
                const SizedBox(height: 16),
                const Text('Texto reconhecido:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    recognizedText.length > 200 
                        ? '${recognizedText.substring(0, 200)}...' 
                        : recognizedText,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitAnswers() async {
    // Validar se todas as questões foram respondidas
    final unansweredQuestions = _gabaritos
        .where((answer) => answer.selecionarOpcao.isEmpty)
        .toList();

    if (unansweredQuestions.isNotEmpty) {
      final shouldContinue = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Questões não respondidas'),
          content: Text(
            'Existem ${unansweredQuestions.length} questões sem resposta. Deseja continuar mesmo assim?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Continuar'),
            ),
          ],
        ),
      );

      if (shouldContinue != true) return;
    }

    setState(() {
      _enviando = true;
    });

    try {
      final studentAnswers = StudentAnswers(
        estudanteId: widget.aluno.id,
        provaId: _selecionarProva!.id,
        gabarito: _gabaritos.where((answer) => answer.selecionarOpcao.isNotEmpty).toList(),
      );

      final success = await ApiService.submitAnswers(studentAnswers);

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Respostas enviadas com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erro ao enviar respostas. Tente novamente.'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao enviar respostas: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _enviando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Respostas - ${widget.aluno.nome}'),
        actions: [
          if (ApiService.isSimulationMode)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'SIMULAÇÃO',
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
            ),
        ],
      ),
      body: LoadingOverlay(
        isLoading: _enviando || _ProcessandoOcr,
        loadingMessage: _enviando
            ? 'Enviando respostas...' 
            : 'Processando imagem...',
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_carregando) {
      return const LoadingWidget(message: 'Carregando provas...');
    }

    if (_erroMensagem != null) {
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
              _erroMensagem!,
              style: AppTheme.subtitleStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _carregarProva,
              child: const Text('Tentar Novamente'),
            ),
          ],
        ),
      );
    }

    if (_selecionarProva == null) {
      return _buildExamSelection();
    }

    return _buildAnswerInput();
  }

  Widget _buildExamSelection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selecione a Prova',
            style: AppTheme.titleStyle,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _provas.length,
              itemBuilder: (context, index) {
                final exam = _provas[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(exam.titulo),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Disciplina: ${exam.assunto}'),
                        Text('Questões: ${exam.questoes}'),
                        Text('Data: ${exam.data.day}/${exam.data.month}/${exam.data.year}'),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => _selecaoProva(exam),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerInput() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Informações da prova
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selecionarProva!.titulo,
                    style: AppTheme.titleStyle,
                  ),
                  Text('Aluno: ${widget.aluno.nome}'),
                  Text('RA: ${widget.aluno.RA}'),
                  Text('Total de questões: ${_selecionarProva!.questoes}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Botões de ação
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Capturar Gabarito',
                  onPressed: _showImageSourceDialog,
                  backgroundColor: AppTheme.secondaryColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CustomButton(
                  text: 'Limpar Respostas',
                  onPressed: () {
                    setState(() {
                      _gabaritos = List.generate(
                        _selecionarProva!.questoes,
                        (index) => Gabarito(numeroQuestao: index + 1, selecionarOpcao: ''),
                      );
                      _imagemCapturada = null;
                    });
                  },
                  backgroundColor: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Lista de questões
          Expanded(
            child: ListView.builder(
              itemCount: _selecionarProva!.questoes,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Questão ${index + 1}',
                          style: AppTheme.subtitleStyle,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: ['A', 'B', 'C', 'D', 'E'].map((option) {
                            final isSelected = _gabaritos[index].selecionarOpcao == option;
                            return GestureDetector(
                              onTap: () => _atualizarGabarito(index, option),
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: isSelected ? AppTheme.primaryColor : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: isSelected ? AppTheme.primaryColor : Colors.grey,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Botão de enviar
          const SizedBox(height: 16),
          CustomButton(
            text: 'Enviar Respostas',
            onPressed: _submitAnswers,
            isLoading: _enviando,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    OcrService.dispose();
    super.dispose();
  }
}

