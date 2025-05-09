// lib/pages/login_page.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../widgets/input_field.dart';
import '../widgets/buttons.dart';
import '../widgets/base_layout.dart';
import '../widgets/logo_text.dart';
import '../widgets/form_container.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _showEmailError = false;
  bool _showPasswordError = false;
  bool _obscurePassword = true;
  bool _loading = false;

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

  Future<void> _signIn() async {
    if (!_validate()) return;
    setState(() => _loading = true);

    try {
      // Autenticar com email/senha
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      // Verificar status do usuário no Firestore
      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        final status = userData['status'] as String? ?? 'active';

        if (status == 'inactive') {
          // Usuário inativo, fazer logout e mostrar erro
          await FirebaseAuth.instance.signOut();

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'This account has been deactivated. Please contact an administrator.',
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 5),
            ),
          );
          setState(() => _loading = false);
          return;
        }
      }

      // Se chegou aqui, o usuário está ativo
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? 'Login failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
      setState(() => _loading = false);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An unexpected error occurred: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double topOffset = MediaQuery.of(context).padding.top + 60 + 32;
    return BaseLayout(
      title: 'Login',
      showHeader: false,
      showTitleBox: false, // disable TitleBox
      child: FormContainer(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: topOffset, bottom: 48),
                child: const LogoText(),
              ),
              InputField(
                label: 'Email',
                hintText: 'Enter your email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(50), // Limite de 50 caracteres
                ],
                error: _showEmailError,
                onClearError: () => setState(() => _showEmailError = false),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              InputField(
                label: 'Password',
                hintText: 'Enter your password',
                controller: _passwordController,
                obscureText: _obscurePassword,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(20), // Limite de 20 caracteres
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
              const SizedBox(height: 32),
              _loading
                  ? const CircularProgressIndicator()
                  : AppButton(
                    config: ButtonType.loginButton.config,
                    onPressed: _signIn,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
