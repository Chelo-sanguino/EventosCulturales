import 'package:flutter/material.dart';

class ProfileSettingsPage extends StatelessWidget {
  const ProfileSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración de Perfil'),
      ),
      body: Center(
        child: const Text(
          'Aquí puedes configurar tu perfil.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}