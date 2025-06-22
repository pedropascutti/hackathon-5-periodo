class Materia {
  final int id;
  final String nome;
  final String codigo;
  final String descricao;
  final int professorId;

  Materia({
    required this.id,
    required this.nome,
    required this.codigo,
    this.descricao = '',
    required this.professorId,
  });

  // ⚠️ INTEGRAÇÃO COM API JAVA: Ajuste os campos conforme o JSON retornado pela sua API
  factory Materia.fromJson(Map<String, dynamic> json) {
    return Materia(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      codigo: json['codigo'] ?? '',
      descricao: json['descricao'] ?? '',
      professorId: json['professorId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'codigo': codigo,
      'descricao': descricao,
      'professorId': professorId,
    };
  }

  @override
  String toString() => nome;
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Materia && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

