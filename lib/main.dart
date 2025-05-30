import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'profile_settings.dart';
import 'eventos_page.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase inicializado correctamente');
  } catch (e) {
    print('Error al inicializar Firebase: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eventos Culturales Tarija',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          primary: Colors.deepPurple,
          secondary: Colors.amber,
        ),
        useMaterial3: true,
      ),
      // Usar LoginScreenWrapper como pantalla inicial
      home: const LoginScreenWrapper(),
    );
  }
}

// Wrapper para manejar el estado de autenticación - CORREGIDO
class LoginScreenWrapper extends StatelessWidget {
  const LoginScreenWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Mostrar indicador de carga mientras se verifica el estado
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Manejar errores
        if (snapshot.hasError) {
          print('Error en authStateChanges: ${snapshot.error}');
          return const LoginScreen(); // En caso de error, mostrar login
        }

        // Verificar el estado de autenticación de manera más robusta
        final user = snapshot.data;
        if (user != null) {
          // Verificar que el usuario esté realmente autenticado
          print('Usuario detectado: ${user.email}, UID: ${user.uid}');
          print('Email verificado: ${user.emailVerified}');
          
          // Solo mostrar la página principal si el usuario está realmente autenticado
          return const MyHomePage(title: 'Eventos Culturales Tarija');
        } else {
          // Usuario no autenticado
          print('No hay usuario autenticado');
          return const LoginScreen();
        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AuthService _authService = AuthService();
  
  // Función para navegar a la página de eventos con la categoría seleccionada
  void _navigateToEventos(String categoria) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventosPage(categoria: categoria),
      ),
    );
  }

  void _cerrarSesion() async {
    try {
      print('Cerrando sesión...');
      await _authService.signOut();
      print('Sesión cerrada correctamente');
      
      if (mounted) {
        // Usar pushAndRemoveUntil para limpiar toda la pila de navegación
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false, // Esto elimina todas las rutas anteriores
        );
      }
    } catch (e) {
      print('Error al cerrar sesión: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cerrar sesión: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: ClipOval(
              child: Image.asset(
                'assets/chapaco_edit.JPG',
                width: 44,
                height: 44,
                fit: BoxFit.cover,
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileSettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          // Imagen en la parte superior
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/tarija_app.JPG'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
              child: const Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: 150),
                  child: Text(
                    'Eventos Culturales Tarija',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Parte inferior en blanco
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Primera fila de botones
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CategoryButton(
                        image: 'assets/San_Roque.PNG',
                        label: 'Culturales',
                        onPressed: () => _navigateToEventos('Culturales'),
                      ),
                      CategoryButton(
                        image: 'assets/rally-andaluz.png',
                        label: 'Deportivos',
                        onPressed: () => _navigateToEventos('Deportivos'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Segunda fila de botones
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CategoryButton(
                        image: 'assets/imagenes_uva.png',
                        label: 'Ferias',
                        onPressed: () => _navigateToEventos('Ferias'),
                      ),
                      CategoryButton(
                        image: 'assets/chuncho.png',
                        label: 'Calendario',
                        onPressed: () => _navigateToEventos('Calendario'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                image: const DecorationImage(
                  image: AssetImage('assets/tarija_app.JPG'),
                  fit: BoxFit.cover,
                  opacity: 0.7,
                ),
              ),
              child: const Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 5.0,
                      color: Colors.black,
                      offset: Offset(1.0, 1.0),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('Eventos'),
              onTap: () {
                Navigator.pop(context);
                _navigateToEventos('Todos');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileSettingsPage(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Cerrar Sesión'),
                      content: const Text('¿Estás seguro que deseas cerrar sesión?'),
                      actions: [
                        TextButton(
                          child: const Text('Cancelar'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Sí, cerrar sesión'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            _cerrarSesion();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Widget para botones de categoría reutilizables
class CategoryButton extends StatelessWidget {
  final String image;
  final String label;
  final VoidCallback onPressed;

  const CategoryButton({
    super.key,
    required this.image,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(20),
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 4,
          ),
          child: Image.asset(
            image,
            width: 60,
            height: 60,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}