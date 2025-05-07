import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? 'Erro de login')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> downloadDatabase() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final collections = [
        "cards",
        "receipts",
        "timesheet_drafts",
        "timesheets",
        "users",
        "workers",
      ];
      final Map<String, dynamic> database = {};

      for (final collection in collections) {
        final querySnapshot = await firestore.collection(collection).get();
        database[collection] =
            querySnapshot.docs.map((doc) {
              final data = doc.data();
              return data.map((key, value) {
                String type;
                dynamic formattedValue;

                if (value is Timestamp) {
                  type = "Timestamp";
                  formattedValue = {
                    "seconds": value.seconds,
                    "nanoseconds": value.nanoseconds,
                  };
                } else if (value is String) {
                  type = "String";
                  formattedValue = value;
                } else if (value is int) {
                  type = "Integer";
                  formattedValue = value;
                } else if (value is double) {
                  type = "Double";
                  formattedValue = value;
                } else if (value is bool) {
                  type = "Boolean";
                  formattedValue = value;
                } else {
                  type = "Unknown";
                  formattedValue = value.toString();
                }

                return MapEntry(key, {"type": type, "value": formattedValue});
              });
            }).toList();
      }

      final jsonString = jsonEncode(database);
      final directory = Directory.current.path;
      final file = File('$directory/database_with_types.json');
      await file.writeAsString(jsonString);

      print('Database with types successfully saved to ${file.path}');
    } catch (e) {
      print('Error downloading database: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: authState.when(
        data: (user) {
          if (user != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Usuário já está logado'),
                  ElevatedButton(
                    onPressed: downloadDatabase,
                    child: const Text('Download Database'),
                  ),
                ],
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) => val!.isEmpty ? 'Informe o email' : null,
                    onSaved: (val) => _email = val!.trim(),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Senha'),
                    obscureText: true,
                    validator: (val) => val!.isEmpty ? 'Informe a senha' : null,
                    onSaved: (val) => _password = val!.trim(),
                  ),
                  const SizedBox(height: 24),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                        onPressed: _login,
                        child: const Text('Entrar'),
                      ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
      ),
    );
  }
}
