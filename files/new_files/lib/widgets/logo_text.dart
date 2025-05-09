// lib/widgets/logo_text.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LogoText extends StatelessWidget {
  const LogoText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 330.0,  // Largura da caixa como double
      height: 140.0, // Altura da caixa como double
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF0205D3), width: 5.0), // Contorno azul
        borderRadius: BorderRadius.circular(20.0), // Bordas arredondadas
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Central Island',
            style: GoogleFonts.poppins(
              fontSize: 42.0,            // Tamanho da fonte
              fontWeight: FontWeight.w800, // Negrito
              color: const Color(0xFF0205D3), // Azul primário
              letterSpacing: -1.5,         // Ajuste de espaçamento
            ),
          ),
          Text(
            'Floors',
            style: GoogleFonts.poppins(
              fontSize: 42.0,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0205D3),
              letterSpacing: -1.5,
            ),
          ),
        ],
      ),
    );
  }
}
