import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Estado del usuario actual
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Iniciar sesión con correo y contraseña
  Future<Map<String, dynamic>> signInWithEmailAndPassword(String email, String password) async {
    try {
      // Realizar la autenticación
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Verificar si el usuario existe
      if (userCredential.user != null) {
        // Devolver solo los datos necesarios, no el objeto User completo
        return {
          'success': true,
          'message': 'Inicio de sesión exitoso',
          'data': {
            'uid': userCredential.user?.uid,
            'email': userCredential.user?.email,
          }
        };
      } else {
        return {
          'success': false,
          'message': 'Error al iniciar sesión: usuario no encontrado'
        };
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No existe usuario con este correo electrónico';
          break;
        case 'wrong-password':
          message = 'Contraseña incorrecta';
          break;
        case 'invalid-email':
          message = 'Correo electrónico inválido';
          break;
        case 'user-disabled':
          message = 'Esta cuenta ha sido deshabilitada';
          break;
        default:
          message = 'Error al iniciar sesión: ${e.message}';
      }
      print('Error de autenticación: $message');
      return {
        'success': false,
        'message': message
      };
    } catch (e) {
      print('Error inesperado en signInWithEmailAndPassword: $e');
      return {
        'success': false,
        'message': 'Error inesperado al iniciar sesión'
      };
    }
  }

  // Registrar nuevo usuario
  Future<Map<String, dynamic>> registerWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        return {
          'success': true,
          'message': 'Usuario registrado exitosamente',
          'data': {
            'uid': userCredential.user?.uid,
            'email': userCredential.user?.email,
          }
        };
      } else {
        return {
          'success': false,
          'message': 'Error al registrar usuario'
        };
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'Este correo ya está registrado';
          break;
        case 'weak-password':
          message = 'La contraseña es muy débil';
          break;
        case 'invalid-email':
          message = 'Correo electrónico inválido';
          break;
        default:
          message = 'Error al registrar: ${e.message}';
      }
      return {
        'success': false,
        'message': message
      };
    } catch (e) {
      print('Error inesperado en registerWithEmailAndPassword: $e');
      return {
        'success': false,
        'message': 'Error inesperado al registrar usuario'
      };
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error al cerrar sesión: $e');
      throw Exception('Error al cerrar sesión');
    }
  }

  // Verificar si hay un usuario autenticado
  bool isUserLoggedIn() {
    return _auth.currentUser != null;
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }
}