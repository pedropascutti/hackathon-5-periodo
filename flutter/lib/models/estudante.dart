class Aluno {
  final int id;
  final String nome;
  final String ra; // RA do aluno
  final int turmaId;
  final String? nomeTurma;
  final String? email;

  Aluno({
    required this.id,
    required this.nome,
    required this.ra,
    required this.turmaId,
    this.nomeTurma,
    this.email,
  });

  // ⚠️ INTEGRAÇÃO COM API JAVA: Ajuste os campos conforme o JSON retornado pela sua API
  factory Aluno.fromJson(Map<String, dynamic> json) {
    return Aluno(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      ra: json['ra'] ?? json['RA'] ?? '', // Suporte para ambos os formatos
      turmaId: json['turmaId'] ?? json['classeId'] ?? 0, // Suporte para ambos os formatos
      nomeTurma: json['nomeTurma'] ?? json['classeNome'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'ra': ra,
      'turmaId': turmaId,
      'nomeTurma': nomeTurma,
      'email': email,
    };
  }

  @override
  String toString() => nome;
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Aluno && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// Alias para compatibilidade com código existente
typedef Estudante = Aluno;

