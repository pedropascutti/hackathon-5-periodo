class Prova {
  final int id;
  final String titulo;
  final String assunto;
  final DateTime data;
  final int classeId;
  final int questoes;

  Prova({
    required this.id,
    required this.titulo,
    required this.assunto,
    required this.data,
    required this.classeId,
    required this.questoes,
  });

  // ⚠️ INTEGRAÇÃO COM API JAVA: Ajuste os campos conforme o JSON retornado pela sua API
  factory Prova.fromJson(Map<String, dynamic> json) {
    return Prova(
      id: json['id'] ?? 0,
      titulo: json['titulo'] ?? '',
      assunto: json['assunto'] ?? '',
      data: DateTime.parse(json['data'] ?? DateTime.now().toIso8601String()),
      classeId: json['classeId'] ?? 0,
      questoes: json['questoes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'assunto': assunto,
      'data': data.toIso8601String(),
      'classeId': classeId,
      'questoes': questoes,
    };
  }
}

