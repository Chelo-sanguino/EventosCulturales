import 'package:flutter/material.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'Español';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración de Perfil'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar y botón para cambiar foto
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: const AssetImage('assets/chapaco_edit.JPG'),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, color: Colors.white),
                          onPressed: () {
                            // Implementar lógica para cambiar la foto
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Cambiar foto de perfil')),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Campos de formulario
              const Text(
                'Información Personal',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu nombre';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu correo electrónico';
                  }
                  if (!value.contains('@')) {
                    return 'Por favor ingresa un correo electrónico válido';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              // Preferencias
              const Text(
                'Preferencias',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              
              // Configuración de idioma
              ListTile(
                title: const Text('Idioma'),
                subtitle: Text(_selectedLanguage),
                leading: const Icon(Icons.language),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  _showLanguageDialog();
                },
              ),
              
              const Divider(),
              
              // Notificaciones
              SwitchListTile(
                title: const Text('Notificaciones'),
                subtitle: const Text('Recibir alertas sobre eventos nuevos'),
                value: _notificationsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
                secondary: const Icon(Icons.notifications),
              ),
              
              const Divider(),
              
              // Categorías preferidas
              ListTile(
                title: const Text('Categorías preferidas'),
                subtitle: const Text('Selecciona tus tipos de eventos favoritos'),
                leading: const Icon(Icons.category),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Implementar pantalla de selección de categorías
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Seleccionar categorías favoritas')),
                  );
                },
              ),
              
              const SizedBox(height: 32),
              
              // Botón para guardar cambios
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Implementar lógica para guardar los cambios
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cambios guardados correctamente')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Guardar Cambios'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccionar idioma'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLanguageOption('Español'),
                _buildLanguageOption('English'),
                _buildLanguageOption('Quechua'),
                _buildLanguageOption('Aymara'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(String language) {
    return ListTile(
      title: Text(language),
      trailing: _selectedLanguage == language 
          ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
          : null,
      onTap: () {
        setState(() {
          _selectedLanguage = language;
        });
        Navigator.pop(context);
      },
    );
  }
}