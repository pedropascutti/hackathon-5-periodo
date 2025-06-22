class Gabarito {
  final int questao;
  final String resposta; // A, B, C, D, E
  final int estudanteId;
  final int provaId;

  Gabarito({
    required this.questao,
    required this.resposta,
    required this.estudanteId,
    required this.provaId,
  });

  factory Gabarito.fromJson(Map<String, dynamic> json) {
    return Gabarito(
      questao: json['questao'] ?? json['numeroQuestao'] ?? 0,
      resposta: json['resposta'] ?? json['selecionarOpcao'] ?? '',
      estudanteId: json['estudanteId'] ?? 0,
      provaId: json['provaId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questao': questao,
      'resposta': resposta,
      'estudanteId': estudanteId,
      'provaId': provaId,
    };
  }

  Gabarito copyWith({
    int? questao,
    String? resposta,
    int? estudanteId,
    int? provaId,
  }) {
    return Gabarito(
      questao: questao ?? this.questao,
      resposta: resposta ?? this.resposta,
      estudanteId: estudanteId ?? this.estudanteId,
      provaId: provaId ?? this.provaId,
    );
  }

  @override
  String toString() => 'Questão $questao: $resposta';
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Gabarito && 
      runtimeType == other.runtimeType && 
      questao == other.questao &&
      estudanteId == other.estudanteId &&
      provaId == other.provaId;

  @override
  int get hashCode => questao.hashCode ^ estudanteId.hashCode ^ provaId.hashCode;
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

