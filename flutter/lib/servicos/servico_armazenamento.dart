import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meu_app_flutter/modelos/usuario.dart';

class ServicoArmazenamento {
  static const String _chaveUsuario = 'usuarioAtual';
  static const String _chaveToken = 'tokenUsuario';

  static Future<void> salvarDadosUsuario(Usuario usuario) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chaveUsuario, json.encode(usuario.toJson()));
    await prefs.setString(_chaveToken, usuario.token);
  }

  static Usuario? obterUsuarioAtual() {
    final prefs = SharedPreferences.getInstance();
    final usuarioJson = prefs.then((p) => p.getString(_chaveUsuario));
    String? userString;
    usuarioJson.then((value) => userString = value);

    if (userString != null) {
      return Usuario.fromJson(json.decode(userString!));
    }
    return null;
  }

  static String? obterTokenUsuario() {
    final prefs = SharedPreferences.getInstance();
    String? token;
    prefs.then((p) => token = p.getString(_chaveToken));
    return token;
  }

  static Future<void> limparDadosUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_chaveUsuario);
    await prefs.remove(_chaveToken);
  }
}


