// lib/pages/settings_page.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/base_layout.dart';
import '../widgets/form_container.dart';
import '../widgets/buttons.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _fullName = "";
  String _email = "";
  String _role = "User";
  bool _isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => _isLoadingUser = false);
      return;
    }

    try {
      final doc =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .get();

      if (doc.exists) {
        final data = doc.data()!;
        final firstName = data["firstName"] as String? ?? "";
        final lastName = data["lastName"] as String? ?? "";
        final fullName = (firstName + " " + lastName).trim();
        final email = data["email"] as String? ?? user.email ?? "";
        final role = data["role"] as String? ?? "User";

        setState(() {
          _fullName = fullName.isNotEmpty ? fullName : "Unknown user";
          _email = email;
          _role = role;
          _isLoadingUser = false;
        });
      } else {
        setState(() {
          _fullName = user.email ?? "Unknown";
          _email = user.email ?? "";
          _role = "User";
          _isLoadingUser = false;
        });
      }
    } catch (_) {
      setState(() {
        _fullName = "Error loading user";
        _email = "";
        _role = "";
        _isLoadingUser = false;
      });
    }
  }

  Widget _buildProfileInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDD0),
        border: Border.all(color: const Color(0xFF0205D3), width: 2),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _fullName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0205D3),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _email,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          Text(
            _role,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      title: 'Settings', // Use page-specific title
      showTitleBox: true, // Show the TitleBox via BaseLayout
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: FormContainer(
          child: Column(
            children: [
              if (_isLoadingUser)
                const Center(child: CircularProgressIndicator())
              else
                _buildProfileInfo(),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppButton(
                    config: ButtonType.usersButton.config,
                    onPressed: () => Navigator.pushNamed(context, '/users'),
                  ),
                  const SizedBox(width: 16),
                  AppButton(
                    config: ButtonType.workersButton.config,
                    onPressed: () => Navigator.pushNamed(context, '/workers'),
                  ),
                  const SizedBox(width: 16),
                  AppButton(
                    config: ButtonType.cardsButton.config,
                    onPressed: () => Navigator.pushNamed(context, '/cards'),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
