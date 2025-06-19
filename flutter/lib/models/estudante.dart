class Aluno {
  final int id;
  final String nome;
  final String RA; // RA do aluno
  final int classeId;
  final String? classeNome;

  Aluno({
    required this.id,
    required this.nome,
    required this.RA,
    required this.classeId,
    this.classeNome,
  });

  // ⚠️ INTEGRAÇÃO COM API JAVA: Ajuste os campos conforme o JSON retornado pela sua API
  factory Aluno.fromJson(Map<String, dynamic> json) {
    return Aluno(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      RA: json['RA'] ?? '',
      classeId: json['classeId'] ?? 0,
      classeNome: json['classeNome'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'RA': RA,
      'classeId': classeId,
      'classeNome': classeNome,
    };
  }
}

