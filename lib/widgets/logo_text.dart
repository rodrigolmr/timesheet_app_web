// lib/widgets/logo_text.dart

import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class LogoText extends StatelessWidget {
  const LogoText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 330.0,
      height: 140.0,
      decoration: AppTheme.logoBoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Central Island',
            style: AppTheme.logoTextStyle,
          ),
          Text(
            'Floors',
            style: AppTheme.logoTextStyle,
          ),
        ],
      ),
    );
  }
}