// lib/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/base_layout.dart';
import '../widgets/logo_text.dart';
import '../widgets/buttons.dart';
import '../pages/test_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _fullName = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFullName();
  }

  Future<void> _loadFullName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _fullName = '';
        _isLoading = false;
      });
      return;
    }

    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      if (doc.exists) {
        final data = doc.data()!;
        final firstName = (data['firstName'] as String?)?.trim() ?? '';
        final lastName = (data['lastName'] as String?)?.trim() ?? '';
        final combined = '$firstName $lastName'.trim();
        setState(() {
          _fullName =
              combined.isNotEmpty
                  ? combined
                  : user.email?.split('@').first ?? '';
          _isLoading = false;
        });
      } else {
        setState(() {
          _fullName = user.email?.split('@').first ?? '';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _fullName = user.email?.split('@').first ?? '';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      title: 'Central Island Floors',
      showTitleBox: false, // disable TitleBox
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const LogoText(),
            const SizedBox(height: 16),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_fullName.isNotEmpty)
              Text(
                'Welcome, $_fullName',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            const SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 16,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: [
                  AppButton(
                    config: ButtonType.sheetsButton.config,
                    onPressed:
                        () => Navigator.pushNamed(context, '/timesheets'),
                  ),
                  AppButton(
                    config: ButtonType.settingsButton.config,
                    onPressed: () => Navigator.pushNamed(context, '/settings'),
                  ),
                  AppButton(
                    config: ButtonType.newButton.config,
                    onPressed: () => Navigator.pushNamed(context, '/test'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
