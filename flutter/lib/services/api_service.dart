import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';
import '../models/estudante.dart';
import '../models/prova.dart';
import '../models/gabarito.dart';
import '../models/materia.dart';
import '../models/turma.dart';
import '../models/resultado.dart';
import '../telas/tela_consulta_resultados.dart';
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

    // ⚠️ INTEGRAÇÃO COM API JAVA: Implementar chamada real da API
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/auth/login'),
        headers: ApiConstants.headers,
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return usuario.fromJson(data);
      }

      return null;
    } catch (e) {
      print('Erro no login: $e');
      return null;
    }
  }

  // ⚠️ MATÉRIAS SIMULADAS - Remove quando API estiver pronta
  static Future<List<Materia>> obterMateriasProfessor(int professorId) async {
    if (_simulateMode) {
      await Future.delayed(const Duration(seconds: 1)); // Simular delay de rede

      return [
        Materia(id: 1, nome: 'Frameworks de Desenvolvimento Web Java', codigo: 'FDWJ', professorId: professorId),
        Materia(id: 2, nome: 'Programação para Dispositivos Móveis', codigo: 'PDM', professorId: professorId),
        Materia(id: 3, nome: 'Banco de Dados', codigo: 'BD', professorId: professorId),
        Materia(id: 4, nome: 'Engenharia de Software', codigo: 'ES', professorId: professorId),
      ];
    }

    // ⚠️ INTEGRAÇÃO COM API JAVA: Implementar chamada real da API
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/materias/professor/$professorId'),
        headers: _authHeaders,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Materia.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      print('Erro ao obter matérias: $e');
      return [];
    }
  }

  // ⚠️ TURMAS SIMULADAS - Remove quando API estiver pronta
  static Future<List<Turma>> obterTurmasMateria(int materiaId) async {
    if (_simulateMode) {
      await Future.delayed(const Duration(seconds: 1)); // Simular delay de rede

      return [
        Turma(id: 1, nome: '5º Período - Matutino', periodo: 'Matutino', semestre: 1, ano: 2025, materiaId: materiaId, totalAlunos: 25),
        Turma(id: 2, nome: '5º Período - Noturno', periodo: 'Noturno', semestre: 1, ano: 2025, materiaId: materiaId, totalAlunos: 30),
        Turma(id: 3, nome: '6º Período - Matutino', periodo: 'Matutino', semestre: 1, ano: 2025, materiaId: materiaId, totalAlunos: 22),
        Turma(id: 4, nome: '6º Período - Noturno', periodo: 'Noturno', semestre: 1, ano: 2025, materiaId: materiaId, totalAlunos: 28),
      ];
    }

    // ⚠️ INTEGRAÇÃO COM API JAVA: Implementar chamada real da API
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/turmas/materia/$materiaId'),
        headers: _authHeaders,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Turma.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      print('Erro ao obter turmas: $e');
      return [];
    }
  }

  // ⚠️ ALUNOS SIMULADOS - Remove quando API estiver pronta
  static Future<List<Aluno>> obterAlunosTurma(int turmaId, ) async {
    if (_simulateMode) {
      await Future.delayed(const Duration(seconds: 1)); // Simular delay de rede

      final nomes = [
        'Ana Silva', 'Bruno Santos', 'Carlos Oliveira', 'Diana Costa', 'Eduardo Lima',
        'Fernanda Souza', 'Gabriel Pereira', 'Helena Rodrigues', 'Igor Almeida', 'Julia Ferreira',
        'Kevin Barbosa', 'Larissa Martins', 'Marcos Ribeiro', 'Natália Gomes', 'Otávio Carvalho',
        'Patrícia Dias', 'Quintino Moreira', 'Rafaela Nascimento', 'Samuel Torres', 'Tatiana Vieira'
      ];

      return List.generate(nomes.length, (index) {
        return Aluno(
          id: index + 1,
          nome: nomes[index],
          ra: 'RA${(20240001 + index).toString()}',
          email: '${nomes[index].toLowerCase().replaceAll(' ', '.')}@aluno.faculdade.edu.br',
          turmaId: turmaId,
        );
      });
    }

    // ⚠️ INTEGRAÇÃO COM API JAVA: Implementar chamada real da API
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/alunos/turma/$turmaId'),
        headers: _authHeaders,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Aluno.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      print('Erro ao obter alunos: $e');
      return [];
    }
  }

  // ⚠️ PROVAS SIMULADAS - Remove quando API estiver pronta
  static Future<List<Prova>> getExams() async {
    if (_simulateMode) {
      await Future.delayed(const Duration(seconds: 1)); // Simular delay de rede

      return [
        Prova(id: 1, titulo: 'Prova 1 - Conceitos Básicos', descricao: 'Avaliação sobre fundamentos da disciplina', totalQuestoes: 20),
        Prova(id: 2, titulo: 'Prova 2 - Desenvolvimento Prático', descricao: 'Avaliação prática de desenvolvimento', totalQuestoes: 25),
        Prova(id: 3, titulo: 'Prova Final', descricao: 'Avaliação final da disciplina', totalQuestoes: 30),
      ];
    }

    // ⚠️ INTEGRAÇÃO COM API JAVA: Implementar chamada real da API
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/provas'),
        headers: _authHeaders,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Prova.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      print('Erro ao obter provas: $e');
      return [];
    }
  }

  // ⚠️ SALVAR GABARITO SIMULADO - Remove quando API estiver pronta
  static Future<bool> saveGabarito(Gabarito gabarito) async {
    if (_simulateMode) {
      await Future.delayed(const Duration(milliseconds: 500)); // Simular delay de rede

      // Simular sucesso na maioria dos casos
      return Random().nextDouble() > 0.1; // 90% de sucesso
    }

    // ⚠️ INTEGRAÇÃO COM API JAVA: Implementar chamada real da API
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/gabaritos'),
        headers: _authHeaders,
        body: jsonEncode(gabarito.toJson()),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Erro ao salvar gabarito: $e');
      return false;
    }
  }

  // ⚠️ RESULTADOS SIMULADOS - Remove quando API estiver pronta
  static Future<List<MediaTurma>> obterResultadosTurmas(int professorId) async {
    if (_simulateMode) {
      await Future.delayed(const Duration(seconds: 1)); // Simular delay de rede

      final random = Random();

      return [
        MediaTurma(
          turmaId: 1,
          nomeTurma: '5º Período - Matutino',
          nomeMateria: 'Frameworks Java',
          mediaGeral: 7.8,
          totalAlunos: 25,
          alunosAvaliados: 23,
          resultados: List.generate(23, (index) =>
              ResultadoAluno(
                id: index + 1,
                alunoId: index + 1,
                nomeAluno: 'Aluno ${index + 1}',
                raAluno: 'RA${(20240001 + index).toString()}',
                provaId: 1,
                tituloProva: 'Prova Simulada',
                nota: (random.nextDouble() * 4 + 6).clamp(0, 10),
                questoesCorretas: (random.nextInt(20) + 1),
                totalQuestoes: 20,
                dataCorrecao: DateTime.now(),
              )
          ), materiaId: 1, notasIndividuais: [],
        ),
        MediaTurma(
          turmaId: 2,
          nomeTurma: '5º Período - Noturno',
          nomeMateria: 'Frameworks Java',
          mediaGeral: 6.5,
          totalAlunos: 30,
          alunosAvaliados: 28,
          notasIndividuais: List.generate(28, (index) =>
              ResultadoAluno(
                id: index + 2,
                alunoId: index + 2,
                nomeAluno: 'Aluno ${index + 2}',
                raAluno: 'RA${(20240001 + index).toString()}',
                provaId:2,
                tituloProva: 'Prova Simulada',
                nota: (random.nextDouble() * 4 + 6).clamp(0, 10),
                questoesCorretas: (random.nextInt(20) + 2),
                totalQuestoes: 20,
                dataCorrecao: DateTime.now(),
              )
          ), materiaId: 2, resultados: [],
        ),
        MediaTurma(
          turmaId: 3,
          nomeTurma: '6º Período - Matutino',
          nomeMateria: 'Dispositivos Móveis',
          mediaGeral: 8.2,
          totalAlunos: 22,
          alunosAvaliados: 22,
          notasIndividuais: List.generate(22, (index) =>
              ResultadoAluno(
                id: index + 3,
                alunoId: index + 3,
                nomeAluno: 'Aluno ${index + 3}',
                raAluno: 'RA${(20240001 + index).toString()}',
                provaId: 3,
                tituloProva: 'Prova Simulada',
                nota: (random.nextDouble() * 4 + 6).clamp(0, 10),
                questoesCorretas: (random.nextInt(20) + 3),
                totalQuestoes: 20,
                dataCorrecao: DateTime.now(),
              )
          ), materiaId: 3, resultados: [],
        ),
        MediaTurma(
          turmaId: 4,
          nomeTurma: '6º Período - Noturno',
          nomeMateria: 'Dispositivos Móveis',
          mediaGeral: 5.8,
          totalAlunos: 28,
          alunosAvaliados: 25,
          notasIndividuais: List.generate(25, (index) =>
              ResultadoAluno(
                id: index + 4,
                alunoId: index + 4,
                nomeAluno: 'Aluno ${index + 4}',
                raAluno: 'RA${(20240001 + index).toString()}',
                provaId: 4,
                tituloProva: 'Prova Simulada',
                nota: (random.nextDouble() * 4 + 6).clamp(0, 10),
                questoesCorretas: (random.nextInt(20) + 4),
                totalQuestoes: 20,
                dataCorrecao: DateTime.now(),
              )
          ), materiaId: 4, resultados: [],
        ),
      ];
    }

    // ⚠️ INTEGRAÇÃO COM API JAVA: Implementar chamada real da API
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/resultados/professor/$professorId'),
        headers: _authHeaders,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => MediaTurma.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      print('Erro ao obter resultados: $e');
      return [];
    }
  }

  // Método para alternar entre modo simulação e API real
  static void setSimulationMode(bool enabled) {
    _simulateMode = enabled;
  }

  static bool get isSimulationMode => _simulateMode;
}




