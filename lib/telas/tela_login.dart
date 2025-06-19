import 'package:flutter/material.dart';
import 'package:meu_app_flutter/modelos/usuario.dart';
import 'package:meu_app_flutter/servicos/servico_api.dart';
import 'package:meu_app_flutter/servicos/servico_armazenamento.dart';
import 'package:meu_app_flutter/utilitarios/constantes.dart';
import 'package:meu_app_flutter/utilitarios/tema.dart';
import 'package:meu_app_flutter/componentes/botao_personalizado.dart';
import 'package:meu_app_flutter/componentes/campo_texto_personalizado.dart';
import 'package:meu_app_flutter/componentes/widget_carregamento.dart';
import 'package:meu_app_flutter/telas/tela_inicial.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({Key? key}) : super(key: key);

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _chaveFormulario = GlobalKey<FormState>();
  final _controladorUsuario = TextEditingController();
  final _controladorSenha = TextEditingController();
  bool _carregando = false;
  bool _ocultarSenha = true;

  @override
  void dispose() {
    _controladorUsuario.dispose();
    _controladorSenha.dispose();
    super.dispose();
  }

  void _preencherCredenciaisTeste(String usuario) {
    _controladorUsuario.text = usuario;
    _controladorSenha.text = '123';
  }

  Future<void> _fazerLogin() async {
    if (!_chaveFormulario.currentState!.validate()) return;

    setState(() {
      _carregando = true;
    });

    try {
      final usuario = await ServicoApi.login(
        _controladorUsuario.text.trim(),
        _controladorSenha.text,
      );

      if (usuario != null) {
        await ServicoArmazenamento.salvarDadosUsuario(usuario);
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const TelaInicial()),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Usuário ou senha inválidos'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao fazer login: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SobreposicaoCarregamento(
        carregando: _carregando,
        mensagemCarregamento: 'Fazendo login...',
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _chaveFormulario,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.school,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 24),
                  
                  Text(
                    StringsApp.nomeApp,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  
                  Text(
                    'Faça login para continuar',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  

                  
                  const SizedBox(height: 32),

                  CampoTextoPersonalizado(
                    rotulo: StringsApp.usuario,
                    dica: 'Digite seu usuário',
                    controlador: _controladorUsuario,
                    iconePrefix: Icons.person,
                    validador: (valor) {
                      if (valor == null || valor.isEmpty) {
                        return 'Por favor, digite seu usuário';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  CampoTextoPersonalizado(
                    rotulo: StringsApp.senha,
                    dica: 'Digite sua senha',
                    controlador: _controladorSenha,
                    textoOculto: _ocultarSenha,
                    iconePrefix: Icons.lock,
                    iconeSuffix: IconButton(
                      icon: Icon(
                        _ocultarSenha ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _ocultarSenha = !_ocultarSenha;
                        });
                      },
                    ),
                    validador: (valor) {
                      if (valor == null || valor.isEmpty) {
                        return 'Por favor, digite sua senha';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  BotaoPersonalizado(
                    texto: StringsApp.entrar,
                    aoClicar: _fazerLogin,
                    carregando: _carregando,
                  ),
                  
                  if (ServicoApi.modoSimulacao) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Credenciais de Teste:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _preencherCredenciaisTeste('professor'),
                            child: const Text('Professor'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _preencherCredenciaisTeste('admin'),
                            child: const Text('Admin'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _preencherCredenciaisTeste('aluno'),
                            child: const Text('Aluno'),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    const Text(
                      'Senha para todos: 123',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  
                  const SizedBox(height: 24),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


