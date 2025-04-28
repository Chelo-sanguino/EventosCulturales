import 'package:flutter/material.dart';

class EventosPage extends StatefulWidget {
  final String categoria;
  
  const EventosPage({super.key, required this.categoria});

  @override
  State<EventosPage> createState() => _EventosPageState();
}

class _EventosPageState extends State<EventosPage> {
  late List<Evento> eventos;
  
  @override
  void initState() {
    super.initState();
    // Cargar eventos de la categoría seleccionada
    eventos = getEventosPorCategoria(widget.categoria);
  }
  
  List<Evento> getEventosPorCategoria(String categoria) {
    // Aquí podrías cargar los eventos desde una API o base de datos
    // Por ahora, usamos datos de ejemplo
    final List<Evento> todosEventos = [
      Evento(
        id: '1',
        titulo: 'Festival de la Uva y el Vino',
        descripcion: 'El festival más importante de Tarija donde se celebra la vendimia y producción de vinos.',
        fecha: '15 de marzo, 2025',
        lugar: 'Plaza Principal, Tarija',
        imagen: 'assets/imagenes_uva.png',
        categoria: 'Culturales',
      ),
      Evento(
        id: '2',
        titulo: 'Carnaval Chapaco',
        descripcion: 'Celebración tradicional con comparsas, casetas y derroche de espuma.',
        fecha: '12 de febrero, 2025',
        lugar: 'Avenida La Paz, Tarija',
        imagen: 'assets/chapaco_edit.JPG',
        categoria: 'Culturales',
      ),
      Evento(
        id: '3',
        titulo: 'Maratón de Tarija',
        descripcion: 'Carrera anual de 42km por las principales calles de la ciudad.',
        fecha: '5 de mayo, 2025',
        lugar: 'Estadio IV Centenario',
        imagen: 'assets/rally-andaluz.png',
        categoria: 'Deportivos',
      ),
      Evento(
        id: '4',
        titulo: 'Feria Exposición Comercial',
        descripcion: 'La mayor feria comercial del departamento con expositores nacionales e internacionales.',
        fecha: '10 de agosto, 2025',
        lugar: 'Campo Ferial, Tarija',
        imagen: 'assets/imagenes_uva.png',
        categoria: 'Ferias',
      ),
      Evento(
        id: '5',
        titulo: 'San Roque',
        descripcion: 'Celebración tradicional en honor al santo patrono de Tarija.',
        fecha: '16 de agosto, 2025',
        lugar: 'Iglesia San Roque, Tarija',
        imagen: 'assets/San_Roque.PNG',
        categoria: 'Culturales',
      ),
    ];
    
    if (categoria == 'Todos') {
      return todosEventos;
    } else {
      return todosEventos.where((evento) => evento.categoria == categoria).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eventos ${widget.categoria}'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: eventos.isEmpty
          ? const Center(
              child: Text(
                'No hay eventos disponibles en esta categoría',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: eventos.length,
              itemBuilder: (context, index) {
                final evento = eventos[index];
                return EventoCard(evento: evento);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implementar la funcionalidad para filtrar eventos
          _mostrarFiltros();
        },
        child: const Icon(Icons.filter_list),
      ),
    );
  }
  
  void _mostrarFiltros() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Filtrar Eventos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Por Fecha'),
                onTap: () {
                  Navigator.pop(context);
                  // Implementar filtrado por fecha
                },
              ),
              ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text('Por Ubicación'),
                onTap: () {
                  Navigator.pop(context);
                  // Implementar filtrado por ubicación
                },
              ),
              ListTile(
                leading: const Icon(Icons.star),
                title: const Text('Por Popularidad'),
                onTap: () {
                  Navigator.pop(context);
                  // Implementar filtrado por popularidad
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class EventoCard extends StatelessWidget {
  final Evento evento;
  
  const EventoCard({super.key, required this.evento});
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: InkWell(
        onTap: () {
          // Navegar a la página de detalles del evento
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => EventoDetallePage(evento: evento),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del evento
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(evento.imagen),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Contenido del evento
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    evento.titulo,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 4),
                      Text(evento.fecha),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16),
                      const SizedBox(width: 4),
                      Text(evento.lugar),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    evento.descripcion,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventoDetallePage extends StatelessWidget {
  final Evento evento;
  
  const EventoDetallePage({super.key, required this.evento});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar con imagen de fondo
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                evento.titulo,
                style: const TextStyle(
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black,
                      offset: Offset(1.0, 1.0),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    evento.imagen,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Contenido del evento
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sección de información básica
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calendar_today),
                              const SizedBox(width: 8),
                              Text(
                                evento.fecha,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.location_on),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  evento.lugar,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.category),
                              const SizedBox(width: 8),
                              Text(
                                evento.categoria,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Descripción del evento
                  const Text(
                    'Descripción',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    evento.descripcion,
                    style: const TextStyle(fontSize: 16),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Botones de acción
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          // Implementar agregar a favoritos
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Evento agregado a favoritos')),
                          );
                        },
                        icon: const Icon(Icons.favorite_border),
                        label: const Text('Favorito'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Implementar compartir evento
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Compartir evento')),
                          );
                        },
                        icon: const Icon(Icons.share),
                        label: const Text('Compartir'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Evento {
  final String id;
  final String titulo;
  final String descripcion;
  final String fecha;
  final String lugar;
  final String imagen;
  final String categoria;
  
  const Evento({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.lugar,
    required this.imagen,
    required this.categoria,
  });
}