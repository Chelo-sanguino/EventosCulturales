import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Estado del usuario actual
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Iniciar sesión con correo y contraseña
  Future<Map<String, dynamic>> signInWithEmailAndPassword(String email, String password) async {
    try {
      print('Intentando iniciar sesión con: $email');
      
      // Realizar la autenticación
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('UserCredential obtenido: ${userCredential.user?.email}');

      // Verificar si el usuario existe
      if (userCredential.user != null) {
        print('Usuario autenticado exitosamente: ${userCredential.user?.email}');
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
        print('Error: userCredential.user es null');
        return {
          'success': false,
          'message': 'Error al iniciar sesión: usuario no encontrado'
        };
      }
    } on FirebaseAuthException catch (e) {
      String message;
      print('FirebaseAuthException: ${e.code} - ${e.message}');
      
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
        case 'invalid-credential':
          message = 'Las credenciales proporcionadas son incorrectas o han expirado';
          break;
        case 'too-many-requests':
          message = 'Demasiados intentos fallidos. Intenta más tarde';
          break;
        default:
          message = 'Error al iniciar sesión: ${e.message}';
      }
      
      return {
        'success': false,
        'message': message
      };
    } catch (e) {
      print('Error inesperado en signInWithEmailAndPassword: $e');
      return {
        'success': false,
        'message': 'Error inesperado al iniciar sesión: $e'
      };
    }
  }

  // Registrar nuevo usuario
  Future<Map<String, dynamic>> registerWithEmailAndPassword(String email, String password) async {
    try {
      print('Intentando registrar usuario con: $email');
      
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('Usuario registrado: ${userCredential.user?.email}');

      if (userCredential.user != null) {
        // Cerrar sesión inmediatamente después del registro
        // para que el usuario tenga que iniciar sesión manualmente
        await _auth.signOut();
        print('Sesión cerrada después del registro');
        
        return {
          'success': true,
          'message': 'Usuario registrado exitosamente. Ahora puedes iniciar sesión.',
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
      print('FirebaseAuthException en registro: ${e.code} - ${e.message}');
      
      switch (e.code) {
        case 'email-already-in-use':
          message = 'Este correo ya está registrado';
          break;
        case 'weak-password':
          message = 'La contraseña es muy débil. Debe tener al menos 6 caracteres';
          break;
        case 'invalid-email':
          message = 'Correo electrónico inválido';
          break;
        case 'operation-not-allowed':
          message = 'El registro con correo y contraseña no está habilitado';
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
        'message': 'Error inesperado al registrar usuario: $e'
      };
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    try {
      print('Cerrando sesión...');
      User? currentUser = _auth.currentUser;
      print('Usuario actual antes de cerrar sesión: ${currentUser?.email}');
      
      await _auth.signOut();
      
      // Verificar que se cerró la sesión
      User? userAfterSignOut = _auth.currentUser;
      print('Usuario después de cerrar sesión: $userAfterSignOut');
      
      if (userAfterSignOut == null) {
        print('Sesión cerrada exitosamente');
      } else {
        print('Advertencia: Parece que la sesión no se cerró completamente');
      }
      
    } catch (e) {
      print('Error al cerrar sesión: $e');
      throw Exception('Error al cerrar sesión: $e');
    }
  }

  // Verificar si hay un usuario autenticado
  bool isUserLoggedIn() {
    final user = _auth.currentUser;
    print('Verificando si hay usuario logueado: ${user?.email}');
    return user != null;
  }

  // Obtener usuario actual
  User? getCurrentUser() {
    final user = _auth.currentUser;
    print('Usuario actual: ${user?.email}');
    return user;
  }

  // Método para verificar el estado actual de autenticación
  void checkCurrentAuthState() {
    final user = _auth.currentUser;
    print('=== ESTADO DE AUTENTICACIÓN ===');
    print('Usuario actual: ${user?.email}');
    print('UID: ${user?.uid}');
    print('Email verificado: ${user?.emailVerified}');
    print('===============================');
  }
}