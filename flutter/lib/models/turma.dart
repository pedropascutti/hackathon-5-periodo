class Turma {
  final int id;
  final String nome;
  final String periodo;
  final int materiaId;
  final String? nomeMateria;
  final int semestre;
  final int ano;
  final int totalAlunos;

  Turma({
    required this.id,
    required this.nome,
    required this.periodo,
    required this.materiaId,
    this.nomeMateria,
    required this.semestre,
    required this.ano,
    this.totalAlunos = 0,
  });

  // ⚠️ INTEGRAÇÃO COM API JAVA: Ajuste os campos conforme o JSON retornado pela sua API
  factory Turma.fromJson(Map<String, dynamic> json) {
    return Turma(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      periodo: json['periodo'] ?? '',
      materiaId: json['materiaId'] ?? 0,
      nomeMateria: json['nomeMateria'],
      semestre: json['semestre'] ?? 1,
      ano: json['ano'] ?? DateTime.now().year,
      totalAlunos: json['totalAlunos'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'periodo': periodo,
      'materiaId': materiaId,
      'nomeMateria': nomeMateria,
      'semestre': semestre,
      'ano': ano,
      'totalAlunos': totalAlunos,
    };
  }

  String get nomeCompleto => '$nome - $periodo';
  
  @override
  String toString() => nomeCompleto;
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Turma && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

