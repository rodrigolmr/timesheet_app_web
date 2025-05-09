import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LogoText extends StatelessWidget {
  const LogoText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 330,
      height: 140,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF0205D3), width: 5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Central Island',
            style: GoogleFonts.poppins(
              fontSize: 42,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0205D3),
              letterSpacing: -1.5,
            ),
          ),
          Text(
            'Floors',
            style: GoogleFonts.poppins(
              fontSize: 42,
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
