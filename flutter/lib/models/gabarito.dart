class Gabarito {
  final int numeroQuestao;
  final String selecionarOpcao; // A, B, C, D, E

  Gabarito({
    required this.numeroQuestao,
    required this.selecionarOpcao,
  });

  factory Gabarito.fromJson(Map<String, dynamic> json) {
    return Gabarito(
      numeroQuestao: json['numeroQuestao'] ?? 0,
      selecionarOpcao: json['selecionarOpcao'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numeroQuestao': numeroQuestao,
      'selecionarOpcao': selecionarOpcao,
    };
  }
}

class StudentAnswers {
  final int estudanteId;
  final int provaId;
  final List<Gabarito> gabarito;

  StudentAnswers({
    required this.estudanteId,
    required this.provaId,
    required this.gabarito,
  });

  // ⚠️ INTEGRAÇÃO COM API JAVA: Este é o formato que será enviado para sua API
  // Ajuste conforme necessário para corresponder ao que sua API espera receber
  Map<String, dynamic> toJson() {
    return {
      'estudanteId': estudanteId,
      'provaId': provaId,
      'gabarito': gabarito.map((answer) => answer.toJson()).toList(),
    };
  }

  factory StudentAnswers.fromJson(Map<String, dynamic> json) {
    return StudentAnswers(
      estudanteId: json['estudanteId'] ?? 0,
      provaId: json['provaId'] ?? 0,
      gabarito: (json['gabarito'] as List<dynamic>?)
          ?.map((answerJson) => Gabarito.fromJson(answerJson))
          .toList() ?? [],
    );
  }
}

