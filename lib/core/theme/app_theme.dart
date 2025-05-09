import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Cores principais
  static const Color primaryColor = Color(0xFF2962FF); // Azul principal
  static const Color primaryDarkColor = Color(0xFF0039CB); // Azul escuro
  static const Color primaryLightColor = Color(0xFF768FFF); // Azul claro
  
  // Cores secundárias
  static const Color accentColor = Color(0xFFFF3D00); // Destaque vermelho
  static const Color fieldColor = Color(0xFFFFFDE7); // Amarelo claro para campos
  static const Color backgroundColor = Color(0xFFF5F5F5); // Fundo geral
  
  // Cores de status
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color errorColor = Color(0xFFE53935);
  
  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryLightColor, primaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Tema Light
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        onPrimary: Colors.white,
        background: backgroundColor,
        error: errorColor,
      ),
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      
      // Texto
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        titleLarge: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: Colors.black87,
        ),
        titleMedium: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.black87,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.black87,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
      
      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      
      // Botões
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
      
      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: fieldColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor),
        ),
        labelStyle: GoogleFonts.poppins(
          color: Colors.grey.shade700,
          fontSize: 14,
        ),
        hintStyle: GoogleFonts.poppins(
          color: Colors.grey.shade500,
          fontSize: 13,
        ),
      ),
      
      // Cartões
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      
      // Tabs
      tabBarTheme: TabBarTheme(
        labelColor: primaryColor, 
        unselectedLabelColor: Colors.grey.shade600,
        indicatorColor: primaryColor,
        labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.poppins(),
      ),
      
      // Ícones
      iconTheme: IconThemeData(
        color: Colors.grey.shade700,
        size: 24,
      ),
      
      // Dropdown
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: GoogleFonts.poppins(fontSize: 14),
        menuStyle: MenuStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          elevation: MaterialStateProperty.all(4),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
      
      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Lista de tiles
      listTileTheme: const ListTileThemeData(
        tileColor: Colors.white,
        selectedTileColor: Color(0xFFE3F2FD),
      ),
      
      // Dividir
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade200,
        thickness: 1,
        space: 16,
      ),
      
      // Formulários
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.grey.shade400;
            }
            if (states.contains(MaterialState.selected)) {
              return primaryColor;
            }
            return Colors.grey;
          },
        ),
      ),
      
      // Progress
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryColor,
        linearTrackColor: Color(0xFFE0E0E0),
        circularTrackColor: Color(0xFFE0E0E0),
      ),
    );
  }
}