class usuario {
  final int id;
  final String nome;
  final String cargo; // "ADMINISTRADOR", "PROFESSOR", "ALUNO"
  final String? token;

  usuario({
    required this.id,
    required this.nome,
    required this.cargo,
    this.token,
  });

  // ⚠️ INTEGRAÇÃO COM API JAVA: Ajuste os campos conforme o JSON retornado pela sua API
  factory usuario.fromJson(Map<String, dynamic> json) {
    return usuario(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      cargo: json['cargo'] ?? '',
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': nome,
      'role': cargo,
      'token': token,
    };
  }

  // Método para verificar se é professor
  bool get isTeacher => cargo == 'PROFESSOR';
  
  // Método para verificar se é administrador
  bool get isAdmin => cargo == 'ADMINISTRADOR';
}

