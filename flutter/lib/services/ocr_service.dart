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
      print('Erro no reconhecimento de texto: $e');
      return '';
    }
  }

  // Processar gabarito a partir de texto reconhecido
  static Map<int, String> processGabaritoFromText(String recognizedText) {
    Map<int, String> respostas = {};
    
    // Padrões de reconhecimento para diferentes formatos de gabarito
    final patterns = [
      RegExp(r'(\d+)[\.\)\-\s]*([ABCDE])', caseSensitive: false),
      RegExp(r'Q(\d+)[\:\.\)\-\s]*([ABCDE])', caseSensitive: false),
      RegExp(r'(\d+)[\s]*[\-\.\)]*[\s]*([ABCDE])', caseSensitive: false),
    ];

    for (final pattern in patterns) {
      final matches = pattern.allMatches(recognizedText);
      for (final match in matches) {
        try {
          final questao = int.parse(match.group(1)!);
          final resposta = match.group(2)!.toUpperCase();
          
          if (['A', 'B', 'C', 'D', 'E'].contains(resposta)) {
            respostas[questao] = resposta;
          }
        } catch (e) {
          // Ignorar erros de parsing
        }
      }
    }

    return respostas;
  }

  // Capturar e processar gabarito (método principal)
  static Future<Map<String, dynamic>?> capturarEProcessarGabarito() async {
    try {
      // Mostrar opções para o usuário escolher entre câmera ou galeria
      File? imageFile;
      
      // Por simplicidade, vamos usar a câmera por padrão
      // Em uma implementação real, você mostraria um dialog para o usuário escolher
      imageFile = await captureImageFromCamera();
      
      if (imageFile == null) {
        return null;
      }

      // Reconhecer texto na imagem
      final recognizedText = await recognizeTextFromImage(imageFile);
      
      if (recognizedText.isEmpty) {
        return null;
      }

      // Processar respostas do gabarito
      final respostasDetectadas = processGabaritoFromText(recognizedText);
      
      // Calcular precisão baseada na quantidade de respostas detectadas
      final precisao = respostasDetectadas.isNotEmpty ? 
          (respostasDetectadas.length / 20.0).clamp(0.0, 1.0) : 0.0;

      return {
        'imagem': imageFile,
        'textoReconhecido': recognizedText,
        'respostas': respostasDetectadas,
        'precisao': precisao,
      };
    } catch (e) {
      print('Erro no processamento do gabarito: $e');
      return null;
    }
  }

  // Limpar recursos
  static void dispose() {
    _textRecognizer.close();
  }
}

