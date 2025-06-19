import 'package:meu_app_flutter/modelos/usuario.dart';
import 'package:meu_app_flutter/utilitarios/constantes.dart';

class ServicoApi {
  static bool _modoSimulacao = true; // Valor padrão

  static bool get modoSimulacao => _modoSimulacao;

  static void definirModoSimulacao(bool valor) {
    _modoSimulacao = valor;
  }

  static Future<Usuario?> login(String usuario, String senha) async {
    // Lógica de simulação de login
    if (_modoSimulacao) {
      if (usuario == 'professor' || usuario == 'admin' || usuario == 'aluno') {
        return Usuario(
          nomeUsuario: usuario,
          papel: usuario.toUpperCase(),
          token: 'simulated_token_${usuario}',
        );
      }
      return null;
    } else {
      //  INTEGRAÇÃO: Lógica de chamada real da API de login

      return null;
    }
  }
}

class ConstantesApi {
  static const String urlBase = 'https://api.exemplo.com'; // URL base da sua API
}

