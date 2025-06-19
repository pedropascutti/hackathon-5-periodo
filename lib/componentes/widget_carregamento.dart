import 'package:flutter/material.dart';

class SobreposicaoCarregamento extends StatelessWidget {
  final bool carregando;
  final String mensagemCarregamento;
  final Widget child;

  const SobreposicaoCarregamento({
    Key? key,
    required this.carregando,
    this.mensagemCarregamento = 'Carregando...',
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (carregando)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    mensagemCarregamento,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}


