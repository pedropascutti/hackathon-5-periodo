import 'package:flutter/material.dart';
import 'package:meu_app_flutter/telas/tela_login.dart';
import 'package:meu_app_flutter/utilitarios/tema.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Corretor de Gabaritos',
      theme: TemaApp.temaPadrao,
      home: const TelaLogin(),
      debugShowCheckedModeBanner: false,
    );
  }
}


