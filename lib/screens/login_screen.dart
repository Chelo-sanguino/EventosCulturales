import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isRegistering = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/tarija_app.JPG'),
            fit: BoxFit.cover,
            opacity: 0.4,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _isRegistering ? 'Registrar Usuario' : 'Iniciar Sesión',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 24),
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
                                return 'Por favor ingrese su correo';
                              }
                              if (!value.contains('@')) {
                                return 'Ingrese un correo válido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Contraseña',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.lock),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese su contraseña';
                              }
                              if (_isRegistering && value.length < 6) {
                                return 'La contraseña debe tener al menos 6 caracteres';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleAuthAction,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(_isRegistering ? 'Registrar' : 'Iniciar Sesión'),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                                    setState(() {
                                      _isRegistering = !_isRegistering;
                                      // Limpiar los campos al cambiar de modo
                                      _emailController.clear();
                                      _passwordController.clear();
                                    });
                                  },
                            child: Text(
                              _isRegistering
                                  ? '¿Ya tienes una cuenta? Inicia sesión'
                                  : '¿No tienes una cuenta? Regístrate',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleAuthAction() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      print('Intentando ${_isRegistering ? 'registrar' : 'iniciar sesión'} con: $email');

      Map<String, dynamic> result;
      
      if (_isRegistering) {
        // Registrar usuario
        result = await _authService.registerWithEmailAndPassword(email, password);
        print('Resultado del registro: $result');
      } else {
        // Iniciar sesión
        result = await _authService.signInWithEmailAndPassword(email, password);
        print('Resultado del inicio de sesión: $result');
      }

      if (result['success']) {
        if (_isRegistering) {
          // Si acaba de registrarse, mostrar mensaje y cambiar a pantalla de inicio de sesión
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result['message'] ?? 'Usuario registrado con éxito. Ahora puedes iniciar sesión.'),
                backgroundColor: Colors.green,
              ),
            );
            setState(() {
              _isRegistering = false;
              _emailController.clear();
              _passwordController.clear();
            });
          }
        } else {
          // Si inició sesión exitosamente, el StreamBuilder se encargará de la navegación
          print('Inicio de sesión exitoso. El StreamBuilder debería detectar el cambio.');
          // NO navegamos manualmente aquí, el StreamBuilder lo hará automáticamente
        }
      } else {
        // Mostrar mensaje de error
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Error de autenticación'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('Error inesperado en _handleAuthAction: $e');
      // Manejar errores inesperados
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error inesperado: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      // Independientemente del resultado, detener el indicador de carga
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}