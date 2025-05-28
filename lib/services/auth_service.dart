import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Estado del usuario actual
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Iniciar sesión con correo y contraseña
  Future<Map<String, dynamic>> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return {
        'success': true,
        'user': userCredential.user,
        'message': 'Inicio de sesión exitoso'
      };
    } on FirebaseAuthException catch (e) {
      String message = 'Error desconocido al iniciar sesión';
      
      switch (e.code) {
        case 'user-not-found':
          message = 'No existe usuario con este correo electrónico';
          break;
        case 'wrong-password':
          message = 'Contraseña incorrecta';
          break;
        case 'invalid-email':
          message = 'Correo electrónico con formato inválido';
          break;
        case 'user-disabled':
          message = 'Esta cuenta ha sido deshabilitada';
          break;
        case 'too-many-requests':
          message = 'Demasiados intentos fallidos. Intente más tarde';
          break;
        case 'operation-not-allowed':
          message = 'Inicio de sesión con correo y contraseña no habilitado';
          break;
        case 'network-request-failed':
          message = 'Error de conexión. Verifique su conexión a internet';
          break;
      }
      
      print('Error de autenticación: ${e.code} - $message');
      return {
        'success': false,
        'user': null,
        'message': message,
        'code': e.code
      };
    } catch (e) {
      print('Error inesperado al iniciar sesión: $e');
      return {
        'success': false,
        'user': null,
        'message': 'Error inesperado: $e'
      };
    }
  }

  // Registrar nuevo usuario
  Future<Map<String, dynamic>> registerWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return {
        'success': true,
        'user': userCredential.user,
        'message': 'Usuario registrado exitosamente'
      };
    } on FirebaseAuthException catch (e) {
      String message = 'Error desconocido al registrar usuario';
      
      switch (e.code) {
        case 'email-already-in-use':
          message = 'Este correo electrónico ya está registrado';
          break;
        case 'invalid-email':
          message = 'Correo electrónico con formato inválido';
          break;
        case 'weak-password':
          message = 'La contraseña es demasiado débil';
          break;
        case 'operation-not-allowed':
          message = 'Registro con correo y contraseña no habilitado';
          break;
        case 'network-request-failed':
          message = 'Error de conexión. Verifique su conexión a internet';
          break;
      }
      
      print('Error de registro: ${e.code} - $message');
      return {
        'success': false,
        'user': null,
        'message': message,
        'code': e.code
      };
    } catch (e) {
      print('Error inesperado al registrar: $e');
      return {
        'success': false,
        'user': null,
        'message': 'Error inesperado: $e'
      };
    }
  }

  // Verificar si el usuario actual está autenticado
  bool isUserLoggedIn() {
    return _auth.currentUser != null;
  }

  // Obtener el usuario actual
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
  }
}