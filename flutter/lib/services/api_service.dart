import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';
import '../models/estudante.dart';
import '../models/prova.dart';
import '../models/gabarito.dart';
import '../utilidade/constants.dart';
import 'storage_service.dart';

class ApiService {
  
  // Simulação de dados para testes
  static bool _simulateMode = true; // Altere para false quando a API estiver pronta
  
  static Map<String, String> get _authHeaders {
    final token = StorageService.getUserToken();
    final headers = Map<String, String>.from(ApiConstants.headers);
    
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }

  // ⚠️ LOGIN SIMULADO - Remove quando API estiver pronta
  static Future<usuario?> login(String username, String password) async {
    if (_simulateMode) {
      // Simular delay de rede
      await Future.delayed(const Duration(seconds: 2));
      
      // Usuários simulados para teste
      final simulatedUsers = {
        'professor': {'password': '123', 'role': 'PROFESSOR'},
        'admin': {'password': '123', 'role': 'ADMINISTRADOR'},
        'aluno': {'password': '123', 'role': 'ALUNO'},
      };
      
      if (simulatedUsers.containsKey(username.toLowerCase()) &&
          simulatedUsers[username.toLowerCase()]!['password'] == password) {
        
        return usuario(
          id: Random().nextInt(1000),
          nome: username,
          cargo: simulatedUsers[username.toLowerCase()]!['role']!,
          token: 'simulated_token_${DateTime.now().millisecondsSinceEpoch}',
        );
      }
      
      return null; // Login inválido
    }
    
    // Código real da API (quando estiver pronta)
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.loginEndpoint}');
      
      final body = jsonEncode({
        'username': username,
        'password': password,
      });

      final response = await http.post(
        url,
        headers: ApiConstants.headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return usuario.fromJson(jsonData);
      } else {
        print('Erro no login: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Erro na requisição de login: $e');
      return null;
    }
  }

  // ⚠️ ALUNOS SIMULADOS - Remove quando API estiver pronta
  static Future<List<Aluno>> getAlunos({int? classId}) async {
    if (_simulateMode) {
      await Future.delayed(const Duration(seconds: 1));
      
      return [
        Aluno(id: 1, nome: 'João', RA: '00', classeId: 1, classeNome: '5º Período A'),
        Aluno(id: 2, nome: 'Maria Santos', RA: '2021002', classeId: 1, classeNome: '5º Período A'),
        Aluno(id: 3, nome: 'Pedro Oliveira', RA: '2021003', classeId: 1, classeNome: '5º Período A'),
        Aluno(id: 4, nome: 'Ana Costa', RA: '2021004', classeId: 2, classeNome: '5º Período B'),
        Aluno(id: 5, nome: 'Carlos Ferreira', RA: '2021005', classeId: 2, classeNome: '5º Período B'),
        Aluno(id: 6, nome: 'Lucia Mendes', RA: '2021006', classeId: 1, classeNome: '5º Período A'),
        Aluno(id: 7, nome: 'Roberto Lima', RA: '2021007', classeId: 2, classeNome: '5º Período B'),
        Aluno(id: 8, nome: 'Fernanda Rocha', RA: '2021008', classeId: 1, classeNome: '5º Período A'),
      ];
    }
    
    // Código real da API
    try {
      String url = '${ApiConstants.baseUrl}${ApiConstants.studentsEndpoint}';
      
      if (classId != null) {
        url += '?classId=$classId';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: _authHeaders,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((json) => Aluno.fromJson(json)).toList();
      } else {
        print('Erro ao buscar alunos: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('Erro na requisição de alunos: $e');
      return [];
    }
  }

  // ⚠️ PROVAS SIMULADAS - Remove quando API estiver pronta
  static Future<List<Prova>> getProvas({int? classId}) async {
    if (_simulateMode) {
      await Future.delayed(const Duration(seconds: 1));
      
      return [
        Prova(
          id: 1,
          titulo: 'Prova de Frameworks Java',
          assunto: 'Programação Web',
          data: DateTime.now().subtract(const Duration(days: 1)),
          classeId: 1,
          questoes: 20,
        ),
        Prova(
          id: 2,
          titulo: 'Prova de Flutter',
          assunto: 'Dispositivos Móveis',
          data: DateTime.now(),
          classeId: 1,
          questoes: 15,
        ),
        Prova(
          id: 3,
          titulo: 'Prova de Banco de Dados',
          assunto: 'Sistemas de Informação',
          data: DateTime.now().add(const Duration(days: 1)),
          classeId: 2,
          questoes: 25,
        ),
      ];
    }
    
    // Código real da API
    try {
      String url = '${ApiConstants.baseUrl}${ApiConstants.examsEndpoint}';
      
      if (classId != null) {
        url += '?classId=$classId';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: _authHeaders,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((json) => Prova.fromJson(json)).toList();
      } else {
        print('Erro ao buscar provas: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('Erro na requisição de provas: $e');
      return [];
    }
  }

  // ⚠️ ENVIO SIMULADO - Remove quando API estiver pronta
  static Future<bool> submitAnswers(StudentAnswers studentAnswers) async {
    if (_simulateMode) {
      await Future.delayed(const Duration(seconds: 3)); // Simular processamento
      
      // Simular sucesso na maioria das vezes
      return Random().nextBool() || true; // Sempre sucesso para testes
    }
    
    // Código real da API
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.answersEndpoint}');
      
      final body = jsonEncode(studentAnswers.toJson());

      final response = await http.post(
        url,
        headers: _authHeaders,
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Respostas enviadas com sucesso!');
        return true;
      } else {
        print('Erro ao enviar respostas: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Erro na requisição de envio de respostas: $e');
      return false;
    }
  }

  // Buscar resultado de um aluno (simulado)
  static Future<Map<String, dynamic>?> getStudentResult(int studentId, int examId) async {
    if (_simulateMode) {
      await Future.delayed(const Duration(seconds: 1));
      
      return {
        'studentId': studentId,
        'examId': examId,
        'grade': (Random().nextDouble() * 10).toStringAsFixed(1),
        'correctAnswers': Random().nextInt(20) + 1,
        'totalQuestions': 20,
        'submittedAt': DateTime.now().toIso8601String(),
      };
    }
    
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}/results?studentId=$studentId&examId=$examId');

      final response = await http.get(
        url,
        headers: _authHeaders,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Erro ao buscar resultado: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Erro na requisição de resultado: $e');
      return null;
    }
  }

  // Método para alternar entre modo simulado e real
  static void setSimulationMode(bool enabled) {
    _simulateMode = enabled;
  }
  
  // Verificar se está em modo simulado
  static bool get isSimulationMode => _simulateMode;

  // Método para testar conectividade com a API
  static Future<bool> testConnection() async {
    if (_simulateMode) {
      return true; // Sempre conectado em modo simulado
    }
    
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}/health');
      
      final response = await http.get(
        url,
        headers: ApiConstants.headers,
      ).timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      print('Erro ao testar conexão: $e');
      return false;
    }
  }
}

