import 'package:flutter/material.dart';

class BotaoPersonalizado extends StatelessWidget {
  final String texto;
  final VoidCallback aoClicar;
  final Color? corFundo;
  final Color? corTexto;
  final bool carregando;

  const BotaoPersonalizado({
    Key? key,
    required this.texto,
    required this.aoClicar,
    this.corFundo,
    this.corTexto,
    this.carregando = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: carregando ? null : aoClicar,
      style: ElevatedButton.styleFrom(
        backgroundColor: corFundo ?? Theme.of(context).primaryColor,
        foregroundColor: corTexto ?? Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: carregando
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(
              texto,
              style: const TextStyle(fontSize: 18),
            ),
    );
  }
}


