class Prova {
  final int id;
  final String titulo;
  final String descricao;
  final DateTime? data;
  final int? classeId;
  final int totalQuestoes;

  Prova({
    required this.id,
    required this.titulo,
    this.descricao = '',
    this.data,
    this.classeId,
    required this.totalQuestoes,
  });

  // ⚠️ INTEGRAÇÃO COM API JAVA: Ajuste os campos conforme o JSON retornado pela sua API
  factory Prova.fromJson(Map<String, dynamic> json) {
    return Prova(
      id: json['id'] ?? 0,
      titulo: json['titulo'] ?? '',
      descricao: json['descricao'] ?? json['assunto'] ?? '',
      data: json['data'] != null ? DateTime.parse(json['data']) : null,
      classeId: json['classeId'],
      totalQuestoes: json['totalQuestoes'] ?? json['questoes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'data': data?.toIso8601String(),
      'classeId': classeId,
      'totalQuestoes': totalQuestoes,
    };
  }

  @override
  String toString() => titulo;
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Prova && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

