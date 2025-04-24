import 'package:flutter/material.dart';
import 'profile_settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eventos Culturales Tarija', // Cambiado el título de la aplicación
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Eventos Culturales Tarija'), // Cambiado el título de la página principal
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Fondo transparente
        elevation: 0, // Sin sombra
        iconTheme: const IconThemeData(
          color: Colors.white, // Cambia el color del ícono a blanco
        ),
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/chapaco_edit.JPG', // Ruta del ícono
              width: 44, // Ajusta el tamaño del ícono
              height: 44,
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
      extendBodyBehindAppBar: true, // Extiende el cuerpo detrás del AppBar
      body: Column(
        children: [
          // Imagen en la parte superior
          Container(
            height: MediaQuery.of(context).size.height * 0.5, // Ocupa el 50% de la pantalla
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/tarija_app.JPG'), // Ruta de la imagen
                fit: BoxFit.cover, // La imagen cubre el área
              ),
            ),
            child: Align(
              alignment: Alignment.center, // Más centrado
              child: Padding(
                padding: const EdgeInsets.only(top: 150), // Ajusta la posición vertical
                child: Text(
                  'Eventos Culturales Tarija',
                  style: TextStyle(
                    color: Colors.white, // Texto en blanco
                    fontSize: 28, // Tamaño del texto más grande
                    fontWeight: FontWeight.bold, // Negrita
                    shadows: [
                      Shadow(
                        blurRadius: 10.0, // Sombra del texto
                        color: Colors.black,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Parte inferior en blanco
          Expanded(
            child: Container(
              color: Colors.white, // Fondo blanco
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Primera fila de botones
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Acción del botón
                            },
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(), // Forma redonda
                              padding: const EdgeInsets.all(20), // Espaciado interno
                            ),
                            child: Image.asset(
                              'assets/San_Roque.PNG', // Imagen del botón
                              width: 60,
                              height: 60,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text('Culturales'),
                        ],
                      ),
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Acción del botón
                            },
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(), // Forma redonda
                              padding: const EdgeInsets.all(20), // Espaciado interno
                            ),
                            child: Image.asset(
                              'assets/rally-andaluz.png', // Imagen del botón
                              width: 60,
                              height: 60,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text('Deportivos'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Segunda fila de botones
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Acción del botón
                            },
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(), // Forma redonda
                              padding: const EdgeInsets.all(20), // Espaciado interno
                            ),
                            child: Image.asset(
                              'assets/imagenes_uva.png', // Imagen del botón
                              width: 60,
                              height: 60,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text('Ferias'),
                        ],
                      ),
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Acción del botón
                            },
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(), // Forma redonda
                              padding: const EdgeInsets.all(20), // Espaciado interno
                            ),
                            child: Image.asset(
                              'assets/chuncho.png', // Imagen del botón
                              width: 60,
                              height: 60,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text('Calendario'),
                        ],
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
              ),
              child: const Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
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
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
