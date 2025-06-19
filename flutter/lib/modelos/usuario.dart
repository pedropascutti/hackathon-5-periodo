class Usuario {
  final String nomeUsuario;
  final String papel;
  final String token;

  Usuario({
    required this.nomeUsuario,
    required this.papel,
    required this.token,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      nomeUsuario: json["nomeUsuario"],
      papel: json["papel"],
      token: json["token"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "nomeUsuario": nomeUsuario,
      "papel": papel,
      "token": token,
    };
  }
}


