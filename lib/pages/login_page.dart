// lib/pages/login_page.dart

import 'package:flutter/material.dart';
import '../providers.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/routes/app_routes.dart';
import '../core/theme/app_theme.dart';
import '../core/responsive/responsive.dart';
import '../widgets/input_field.dart';
import '../widgets/app_button.dart';
import '../widgets/feedback_overlay.dart';
import '../widgets/loading_button.dart';
import '../widgets/logo_text.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController(text: 'rodrigo.lmr@hotmail.com');
  final _passwordController = TextEditingController(text: '120118');

  bool _showEmailError = false;
  bool _showPasswordError = false;
  bool _obscurePassword = true;

  bool _validate() {
    bool valid = true;
    if (_emailController.text.trim().isEmpty) {
      _showEmailError = true;
      valid = false;
    }
    if (_passwordController.text.isEmpty) {
      _showPasswordError = true;
      valid = false;
    }
    setState(() {});
    return valid;
  }

  Future<bool> _signIn() async {
    if (!_validate()) return false;

    try {
      print('Iniciando processo de login');

      // Mostrar overlay de carregamento usando WidgetsBinding
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          FeedbackController.showLoading(
            context,
            message: 'Signing in...',
            position: FeedbackPosition.center,
          );
        }
      });

      // Usar o provider de login em vez de acessar Firebase diretamente
      final loginCallback = ref.read(loginCallbackProvider);
      await loginCallback(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      print('Login bem-sucedido, atualizando authStateProvider');

      // Atualizar o estado de autenticação
      ref.read(authStateProvider.notifier).state = true;

      // Navegação para home após login bem-sucedido
      if (!mounted) return false;

      print('Navegando para home após login bem-sucedido');

      // Esconder o overlay de carregamento e mostrar feedback usando WidgetsBinding
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          FeedbackController.hide();

          // Mostrar feedback de sucesso
          FeedbackController.showSuccess(
            context,
            message: 'Login successful!',
            duration: AppTheme.shortFeedbackDuration,
          );
        }
      });

      // Usar GoRouter diretamente com um pequeno atraso
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        try {
          print('Tentando navegar para a home page via GoRouter');
          context.go('/');
          return true;
        } catch (e) {
          print('Erro ao navegar via GoRouter: $e');
          return false;
        }
      }
      return false;
    } catch (e) {
      print('Erro durante login: $e');
      if (mounted) {
        // Esconder o overlay de carregamento e mostrar erro usando WidgetsBinding
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            FeedbackController.hide();

            // Mostrar feedback de erro
            FeedbackController.showError(
              context,
              message: 'Invalid credentials. Please try again.',
              duration: AppTheme.mediumFeedbackDuration,
            );
          }
        });
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Usando o sistema responsivo para adaptar o layout
    final responsive = ResponsiveSizing(context);

    return Scaffold(
      body: ResponsiveContainer(
        mobileMaxWidth: AppTheme.maxFormWidth,
        tabletMaxWidth: 600,
        desktopMaxWidth: 700,
        padding: responsive.screenPadding,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Logo com altura adaptativa
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + responsive.responsiveValue(
                    mobile: 40.0,
                    tablet: 60.0,
                    desktop: 80.0,
                  ),
                  bottom: responsive.responsiveValue(
                    mobile: 40.0,
                    tablet: 48.0,
                    desktop: 60.0,
                  ),
                ),
                child: const LogoText(),
              ),

              // Campos de entrada adaptáveis
              InputField(
                label: 'Email',
                hintText: 'Enter your email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(50),
                ],
                error: _showEmailError,
                onClearError: () => setState(() => _showEmailError = false),
                textInputAction: TextInputAction.next,
              ),

              SizedBox(height: responsive.spacing),

              InputField(
                label: 'Password',
                hintText: 'Enter your password',
                controller: _passwordController,
                obscureText: _obscurePassword,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(20),
                ],
                error: _showPasswordError,
                onClearError: () => setState(() => _showPasswordError = false),
                textCapitalization: TextCapitalization.none,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed:
                      () => setState(() => _obscurePassword = !_obscurePassword),
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _signIn(),
              ),

              // Espaçamento responsivo
              SizedBox(height: responsive.responsiveValue(
                mobile: 32.0,
                tablet: 40.0,
                desktop: 48.0,
              )),

              // Botão de login com estado
              SizedBox(
                width: responsive.responsiveValue(
                  mobile: double.infinity,
                  tablet: 300.0,
                  desktop: 350.0,
                ),
                height: responsive.buttonHeight,
                child: StateButton.fromType(
                  type: ButtonType.loginButton,
                  onPressed: _signIn,
                  loadingText: 'Signing in...',
                  successText: 'Success!',
                  errorText: 'Failed',
                  successDuration: const Duration(milliseconds: 800),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}