import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import '../models/gabarito.dart';

class OcrService {
  static final TextRecognizer _textRecognizer = TextRecognizer();
  static final ImagePicker _imagePicker = ImagePicker();

  // Capturar imagem da câmera
  static Future<File?> captureImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        preferredCameraDevice: CameraDevice.rear,
      );
      
      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('Erro ao capturar imagem da câmera: $e');
      return null;
    }
  }

  // Selecionar imagem da galeria
  static Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('Erro ao selecionar imagem da galeria: $e');
      return null;
    }
  }

  // Reconhecer texto na imagem
  static Future<String> recognizeTextFromImage(File imageFile) async {
    try {
      final InputImage inputImage = InputImage.fromFile(imageFile);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      
      return recognizedText.text;
    } catch (e) {
      print('Erro ao reconhecer texto: $e');
      return '';
    }
  }

  // Processar gabarito a partir do texto reconhecido
  static List<Gabarito> processGabaritoText(String recognizedText, int totalQuestions) {
    List<Gabarito> answers = [];
    
    try {
      // Dividir o texto em linhas
      List<String> lines = recognizedText.split('\n');
      
      // Padrões para reconhecer respostas
      // Exemplo: "1. A", "2. B", "Q1: C", "1) D", etc.
      RegExp answerPattern = RegExp(r'(\d+)[\.\)\:\s]*([A-E])', caseSensitive: false);
      
      for (String line in lines) {
        line = line.trim();
        if (line.isEmpty) continue;
        
        // Buscar padrões de resposta na linha
        Iterable<RegExpMatch> matches = answerPattern.allMatches(line);
        
        for (RegExpMatch match in matches) {
          int questionNumber = int.tryParse(match.group(1) ?? '') ?? 0;
          String selectedOption = (match.group(2) ?? '').toUpperCase();
          
          // Validar se a questão e opção são válidas
          if (questionNumber > 0 && 
              questionNumber <= totalQuestions && 
              ['A', 'B', 'C', 'D', 'E'].contains(selectedOption)) {
            
            // Verificar se já existe uma resposta para esta questão
            bool exists = answers.any((answer) => answer.numeroQuestao == questionNumber);
            
            if (!exists) {
              answers.add(Gabarito(
                numeroQuestao: questionNumber,
                selecionarOpcao: selectedOption,
              ));
            }
          }
        }
      }
      
      // Ordenar respostas por número da questão
      answers.sort((a, b) => a.numeroQuestao.compareTo(b.numeroQuestao));
      
    } catch (e) {
      print('Erro ao processar texto do gabarito: $e');
    }
    
    return answers;
  }

  // Processar gabarito com padrões alternativos
  static List<Gabarito> processGabaritoTextAdvanced(String recognizedText, int totalQuestions) {
    List<Gabarito> answers = [];
    
    try {
      // Limpar e normalizar o texto
      String cleanText = recognizedText
          .replaceAll(RegExp(r'[^\w\s\.\)\:\-]'), ' ')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
      
      // Múltiplos padrões para diferentes formatos de gabarito
      List<RegExp> patterns = [
        RegExp(r'(\d+)[\.\)\:\s]*([A-E])', caseSensitive: false),  // 1. A, 2) B, 3: C
        RegExp(r'Q(\d+)[\.\)\:\s]*([A-E])', caseSensitive: false), // Q1. A, Q2) B
        RegExp(r'(\d+)\s*-\s*([A-E])', caseSensitive: false),      // 1 - A, 2 - B
        RegExp(r'([A-E])\s*(\d+)', caseSensitive: false),          // A 1, B 2 (formato invertido)
      ];
      
      for (RegExp pattern in patterns) {
        Iterable<RegExpMatch> matches = pattern.allMatches(cleanText);
        
        for (RegExpMatch match in matches) {
          int questionNumber;
          String selectedOption;
          
          // Verificar se é formato invertido (letra primeiro)
          if (pattern.pattern.contains('([A-E])\\s*(\\d+)')) {
            selectedOption = (match.group(1) ?? '').toUpperCase();
            questionNumber = int.tryParse(match.group(2) ?? '') ?? 0;
          } else {
            questionNumber = int.tryParse(match.group(1) ?? '') ?? 0;
            selectedOption = (match.group(2) ?? '').toUpperCase();
          }
          
          // Validar e adicionar resposta
          if (questionNumber > 0 && 
              questionNumber <= totalQuestions && 
              ['A', 'B', 'C', 'D', 'E'].contains(selectedOption)) {
            
            bool exists = answers.any((answer) => answer.numeroQuestao == questionNumber);
            
            if (!exists) {
              answers.add(Gabarito(
                numeroQuestao: questionNumber,
                selecionarOpcao: selectedOption,
              ));
            }
          }
        }
      }
      
      // Ordenar respostas
      answers.sort((a, b) => a.numeroQuestao.compareTo(b.numeroQuestao));
      
    } catch (e) {
      print('Erro no processamento avançado: $e');
    }
    
    return answers;
  }

  // Validar e corrigir respostas reconhecidas
  static List<Gabarito> validateAndCorrectAnswers(List<Gabarito> recognizedAnswers, int totalQuestions) {
    List<Gabarito> validatedAnswers = [];
    
    // Criar lista completa de questões
    for (int i = 1; i <= totalQuestions; i++) {
      Gabarito? existingAnswer = recognizedAnswers
          .where((answer) => answer.numeroQuestao == i)
          .firstOrNull;
      
      if (existingAnswer != null) {
        validatedAnswers.add(existingAnswer);
      } else {
        // Adicionar resposta vazia para questões não reconhecidas
        validatedAnswers.add(Gabarito(
          numeroQuestao: i,
          selecionarOpcao: '',
        ));
      }
    }
    
    return validatedAnswers;
  }

  // Liberar recursos
  static void dispose() {
    _textRecognizer.close();
  }

  // Estatísticas do reconhecimento
  static Map<String, dynamic> getRecognitionStats(List<Gabarito> answers, int totalQuestions) {
    int recognizedCount = answers.where((answer) => answer.selecionarOpcao.isNotEmpty).length;
    int missingCount = totalQuestions - recognizedCount;
    double accuracy = (recognizedCount / totalQuestions) * 100;
    
    return {
      'total': totalQuestions,
      'recognized': recognizedCount,
      'missing': missingCount,
      'accuracy': accuracy.toStringAsFixed(1),
    };
  }
}

