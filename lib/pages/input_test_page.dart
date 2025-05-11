// lib/pages/input_test_page.dart

import 'package:flutter/material.dart';
import '../widgets/base_input.dart';
import '../widgets/input_field_new.dart';
import '../widgets/input_validator.dart';
import '../core/theme/app_theme.dart';
import '../widgets/text_formatter.dart';
import '../widgets/app_button.dart';

/// Página de teste para os componentes de input melhorados.
///
/// Esta página exibe todos os componentes de input com suas novas funcionalidades
/// para demonstração e testes.
class InputTestPage extends StatefulWidget {
  static const routeName = '/input-test';

  const InputTestPage({Key? key}) : super(key: key);

  @override
  State<InputTestPage> createState() => _InputTestPageState();
}

class _InputTestPageState extends State<InputTestPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _hoursController = TextEditingController();
  final _notesController = TextEditingController();
  
  InputValidationState _nameValidationState = InputValidationState.none;
  InputValidationState _emailValidationState = InputValidationState.none;
  InputValidationState _phoneValidationState = InputValidationState.none;
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _hoursController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teste de Inputs Melhorados'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Testes dos Componentes de Input',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Input de texto padrão
                  InputField(
                    label: 'Nome Completo',
                    hintText: 'Digite seu nome completo',
                    controller: _nameController,
                    validationState: _nameValidationState,
                    errorText: 'Por favor, insira um nome válido',
                    validator: InputValidator.validateRequired,
                    capitalizationType: CapitalizationType.words,
                    textInputAction: TextInputAction.next,
                    maxWidth: 500,
                    onChanged: (value) {
                      setState(() {
                        _nameValidationState = value.isEmpty
                            ? InputValidationState.invalid
                            : InputValidationState.valid;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Input de email
                  InputField(
                    label: 'Email',
                    hintText: 'Digite seu email',
                    controller: _emailController,
                    validationState: _emailValidationState,
                    errorText: 'Email inválido',
                    validator: InputValidator.validateEmail,
                    capitalizationType: CapitalizationType.none,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    maxWidth: 500,
                    suffixIcon: const Icon(Icons.email),
                    onChanged: (value) {
                      setState(() {
                        final error = InputValidator.validateEmail(value);
                        _emailValidationState = error == null
                            ? InputValidationState.valid
                            : InputValidationState.invalid;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Input de telefone com formatação
                  InputField(
                    label: 'Telefone',
                    hintText: '(XX) XXXXX-XXXX',
                    controller: _phoneController,
                    validationState: _phoneValidationState,
                    errorText: 'Telefone inválido',
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      TextFormatter.numeric(NumericFormatterType.integer),
                    ],
                    maxWidth: 300,
                    onChanged: (value) {
                      setState(() {
                        _phoneValidationState = value.length < 10
                            ? InputValidationState.invalid
                            : InputValidationState.valid;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Input numérico
                  InputField(
                    label: 'Horas Trabalhadas',
                    hintText: 'Digite o número de horas',
                    controller: _hoursController,
                    inputFormatters: [
                      TextFormatter.numeric(NumericFormatterType.decimal),
                    ],
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    prefixText: 'HR:',
                    maxWidth: 200,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Botão de validação
                  Center(
                    child: AppButton.fromType(
                      type: ButtonType.submitButton,
                      onPressed: _validateForm,
                      isExpanded: false,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Resultados
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundYellow,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.primaryBlue),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Resultados:',
                          style: TextStyle(
                            fontSize: 18, 
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Nome: ${_nameController.text}'),
                        Text('Email: ${_emailController.text}'),
                        Text('Telefone: ${_phoneController.text}'),
                        Text('Horas: ${_hoursController.text}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  void _validateForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Formulário válido!'),
          backgroundColor: AppTheme.successColor,
        ),
      );
      
      // Força reconstrução para atualizar o resultado
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, corrija os erros no formulário.'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      
      // Atualiza estados de validação
      setState(() {
        _nameValidationState = _nameController.text.isEmpty
            ? InputValidationState.invalid
            : InputValidationState.valid;
        
        final emailError = InputValidator.validateEmail(_emailController.text);
        _emailValidationState = emailError == null
            ? InputValidationState.valid
            : InputValidationState.invalid;
        
        _phoneValidationState = _phoneController.text.length < 10
            ? InputValidationState.invalid
            : InputValidationState.valid;
      });
    }
  }
}