class ResultadoAluno {
  final int id;
  final int alunoId;
  final String nomeAluno;
  final String raAluno;
  final int provaId;
  final String tituloProva;
  final double nota;
  final int questoesCorretas;
  final int totalQuestoes;
  final DateTime dataCorrecao;

  ResultadoAluno({
    required this.id,
    required this.alunoId,
    required this.nomeAluno,
    required this.raAluno,
    required this.provaId,
    required this.tituloProva,
    required this.nota,
    required this.questoesCorretas,
    required this.totalQuestoes,
    required this.dataCorrecao,
  });

  // ⚠️ INTEGRAÇÃO COM API JAVA: Ajuste os campos conforme o JSON retornado pela sua API
  factory ResultadoAluno.fromJson(Map<String, dynamic> json) {
    return ResultadoAluno(
      id: json['id'] ?? 0,
      alunoId: json['alunoId'] ?? 0,
      nomeAluno: json['nomeAluno'] ?? '',
      raAluno: json['raAluno'] ?? '',
      provaId: json['provaId'] ?? 0,
      tituloProva: json['tituloProva'] ?? '',
      nota: (json['nota'] ?? 0.0).toDouble(),
      questoesCorretas: json['questoesCorretas'] ?? 0,
      totalQuestoes: json['totalQuestoes'] ?? 0,
      dataCorrecao: DateTime.parse(json['dataCorrecao'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'alunoId': alunoId,
      'nomeAluno': nomeAluno,
      'raAluno': raAluno,
      'provaId': provaId,
      'tituloProva': tituloProva,
      'nota': nota,
      'questoesCorretas': questoesCorretas,
      'totalQuestoes': totalQuestoes,
      'dataCorrecao': dataCorrecao.toIso8601String(),
    };
  }

  double get percentualAcerto => totalQuestoes > 0 ? (questoesCorretas / totalQuestoes) * 100 : 0;
  
  String get notaFormatada => nota.toStringAsFixed(1);
}

class MediaTurma {
  final int turmaId;
  final String nomeTurma;
  final int materiaId;
  final String nomeMateria;
  final double mediaGeral;
  final int totalAlunos;
  final int alunosAvaliados;
  final List<ResultadoAluno> resultados;

  MediaTurma({
    required this.turmaId,
    required this.nomeTurma,
    required this.materiaId,
    required this.nomeMateria,
    required this.mediaGeral,
    required this.totalAlunos,
    required this.alunosAvaliados,
    required this.resultados, required List<dynamic> notasIndividuais,
  });

  // ⚠️ INTEGRAÇÃO COM API JAVA: Ajuste os campos conforme o JSON retornado pela sua API
  factory MediaTurma.fromJson(Map<String, dynamic> json) {
    var resultadosJson = json['resultados'] as List? ?? [];
    List<ResultadoAluno> resultados = resultadosJson
        .map((resultado) => ResultadoAluno.fromJson(resultado))
        .toList();

    return MediaTurma(
      turmaId: json['turmaId'] ?? 0,
      nomeTurma: json['nomeTurma'] ?? '',
      materiaId: json['materiaId'] ?? 0,
      nomeMateria: json['nomeMateria'] ?? '',
      mediaGeral: (json['mediaGeral'] ?? 0.0).toDouble(),
      totalAlunos: json['totalAlunos'] ?? 0,
      alunosAvaliados: json['alunosAvaliados'] ?? 0,
      resultados: resultados, notasIndividuais: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'turmaId': turmaId,
      'nomeTurma': nomeTurma,
      'materiaId': materiaId,
      'nomeMateria': nomeMateria,
      'mediaGeral': mediaGeral,
      'totalAlunos': totalAlunos,
      'alunosAvaliados': alunosAvaliados,
      'resultados': resultados.map((r) => r.toJson()).toList(),
    };
  }

  String get mediaFormatada => mediaGeral.toStringAsFixed(1);
  
  double get percentualParticipacao => totalAlunos > 0 ? (alunosAvaliados / totalAlunos) * 100 : 0;
}

