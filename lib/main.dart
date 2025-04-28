import 'package:flutter/material.dart';
import 'profile_settings.dart';
import 'eventos_page.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eventos Culturales Tarija',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          primary: Colors.deepPurple,
          secondary: Colors.amber,
        ),
        useMaterial3: true,
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
      ),
      home: const MyHomePage(title: 'Eventos Culturales Tarija'),
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
  // Función para navegar a la página de eventos con la categoría seleccionada
  void _navigateToEventos(String categoria) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventosPage(categoria: categoria),
      ),
    );
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