import 'package:flutter/material.dart';

class CampoTextoPersonalizado extends StatelessWidget {
  final String rotulo;
  final String dica;
  final TextEditingController controlador;
  final bool textoOculto;
  final IconData? iconePrefix;
  final Widget? iconeSuffix;
  final String? Function(String?)? validador;

  const CampoTextoPersonalizado({
    Key? key,
    required this.rotulo,
    required this.dica,
    required this.controlador,
    this.textoOculto = false,
    this.iconePrefix,
    this.iconeSuffix,
    this.validador,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controlador,
      obscureText: textoOculto,
      decoration: InputDecoration(
        labelText: rotulo,
        hintText: dica,
        prefixIcon: iconePrefix != null ? Icon(iconePrefix) : null,
        suffixIcon: iconeSuffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: validador,
    );
  }
}


