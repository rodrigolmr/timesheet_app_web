import 'package:flutter/material.dart';
import '../widgets/buttons.dart';

class TestPage extends StatelessWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Alinha os botões ao centro
            children: [
              // Atalho para Home Page
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Atalho para Página Principal',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      config: ButtonType.sheetsButton.config,
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/home');
                      }, // Corrigido para usar a rota '/home'
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Clique para voltar à Home Page',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              
              const Text('Regular Buttons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...ButtonType.values.map((type) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Center( // Centraliza cada botão
                      child: Column(
                        children: [
                          AppButton(
                            config: type.config,
                            onPressed: () {
                              debugPrint('${type.name} button pressed');
                            },
                          ),
                          const SizedBox(height: 5),
                          Text('Size: ${type.config.width} x ${type.config.height}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                  )),
              const SizedBox(height: 20),
              const Text('Mini Buttons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...MiniButtonType.values.map((type) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Center(
                      child: Column(
                        children: [
                          AppButton(
                            config: type.config,
                            onPressed: () {
                              debugPrint('${type.name} mini button pressed');
                            },
                          ),
                          const SizedBox(height: 5),
                          Text('Size: ${type.config.width} x ${type.config.height}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}