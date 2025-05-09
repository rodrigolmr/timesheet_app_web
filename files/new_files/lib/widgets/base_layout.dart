// lib/widgets/base_layout.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'title_box.dart';

class BaseLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final bool showHeader;
  final bool showTitleBox; // new flag for TitleBox visibility

  const BaseLayout({
    Key? key,
    required this.child,
    required this.title,
    this.showHeader = true,
    this.showTitleBox = true, // default visible
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF0205D3);

    return Scaffold(
      body: Column(
        children: [
          if (showHeader) // cabeçalho fixo com menu e título
            SafeArea(
              bottom: false,
              child: Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // botão de menu / navegação
                    PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.menu,
                        color: primaryBlue,
                        size: 32,
                      ),
                      onSelected: (v) async {
                        if (v == 'Home') {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/home', // Changed from '/test' to '/home'
                            (_) => false,
                          );
                        } else if (v == 'Logout') {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (_) => false,
                          );
                        }
                      },
                      itemBuilder:
                          (_) => const [
                            PopupMenuItem(value: 'Home', child: Text('Home')),
                            PopupMenuItem(
                              value: 'Logout',
                              child: Text('Logout'),
                            ),
                          ],
                    ),

                    const SizedBox(width: 16),

                    // título da página, ajustando o tamanho para caber em uma linha
                    Expanded(
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Central Island Floors", // Always show this text in the header
                            style: GoogleFonts.raleway(
                              fontSize: 32, // tamanho máximo
                              fontWeight: FontWeight.bold,
                              color: primaryBlue,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // espaço à direita para manter simetria
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),

          // Add space only if both header and title box are shown
          if (showHeader && showTitleBox) const SizedBox(height: 16),

          if (showTitleBox)
            TitleBox(title: title), // Use the 'title' parameter for TitleBox
          // Add space only if title box is shown
          if (showTitleBox) const SizedBox(height: 16),

          // conteúdo principal
          Expanded(child: child),
        ],
      ),
    );
  }
}
