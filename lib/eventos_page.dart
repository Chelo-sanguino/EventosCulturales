import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventosPage extends StatefulWidget {
  final String categoria;

  const EventosPage({super.key, required this.categoria});

  @override
  State<EventosPage> createState() => _EventosPageState();
}

class _EventosPageState extends State<EventosPage> {
  final FirestoreService _firestoreService = FirestoreService();
  late Stream<List<Map<String, dynamic>>> eventosStream;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _initializeEventStream();
  }

  void _initializeEventStream() {
    if (widget.categoria == 'Calendario') {
      eventosStream = _firestoreService.obtenerEventosProximos();
    } else {
      eventosStream = _firestoreService.obtenerEventosPorCategoria(widget.categoria);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eventos - ${widget.categoria}'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _initializeEventStream();
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          if (_isSearching)
            Container(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Buscar eventos...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      eventosStream = _firestoreService.buscarEventos(value);
                    });
                  } else {
                    _initializeEventStream();
                  }
                },
              ),
            ),
          
          // Lista de eventos
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: eventosStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Error al cargar eventos',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Por favor, intenta de nuevo más tarde',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _initializeEventStream();
                            });
                          },
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }
                
                final eventos = snapshot.data ?? [];
                
                if (eventos.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.event_busy, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          'No hay eventos disponibles',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isSearching 
                            ? 'Intenta con otros términos de búsqueda'
                            : 'Los eventos aparecerán aquí cuando estén disponibles',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: eventos.length,
                  itemBuilder: (context, index) {
                    final evento = eventos[index];
                    return _buildEventCard(evento);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEventDialog();
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> evento) {
    // Convertir timestamp a fecha legible
    String fechaEvento = 'Fecha no especificada';
    if (evento['fechaEvento'] != null) {
      try {
        DateTime fecha;
        if (evento['fechaEvento'] is Timestamp) {
          fecha = (evento['fechaEvento'] as Timestamp).toDate();
        } else if (evento['fechaEvento'] is String) {
          fecha = DateTime.parse(evento['fechaEvento']);
        } else {
          fecha = DateTime.now();
        }
        fechaEvento = '${fecha.day}/${fecha.month}/${fecha.year}';
      } catch (e) {
        print('Error al convertir fecha: $e');
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          evento['titulo'] ?? 'Sin título',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(evento['descripcion'] ?? 'Sin descripción'),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  fechaEvento,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(width: 16),
                if (evento['ubicacion'] != null) ...[
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      evento['ubicacion'],
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(
            (evento['titulo'] ?? 'E')[0].toUpperCase(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (String value) {
            switch (value) {
              case 'editar':
                _showEditEventDialog(evento);
                break;
              case 'eliminar':
                _showDeleteConfirmation(evento);
                break;
            }
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem<String>(
              value: 'editar',
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text('Editar'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem<String>(
              value: 'eliminar',
              child: ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Eliminar', style: TextStyle(color: Colors.red)),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddEventDialog() {
    _showEventDialog();
  }

  void _showEditEventDialog(Map<String, dynamic> evento) {
    _showEventDialog(evento: evento);
  }

  void _showEventDialog({Map<String, dynamic>? evento}) {
    final isEditing = evento != null;
    final titleController = TextEditingController(text: evento?['titulo'] ?? '');
    final descriptionController = TextEditingController(text: evento?['descripcion'] ?? '');
    final locationController = TextEditingController(text: evento?['ubicacion'] ?? '');
    String selectedCategory = evento?['categoria'] ?? 'Culturales';
    // Lista de categorías disponibles
    final List<String> categorias = ['Culturales', 'Deportivos', 'Ferias'];
    
    // Si la categoría no está en la lista, usar la primera categoría
    if (!categorias.contains(selectedCategory)) {
      selectedCategory = categorias[0];
    }
    
    DateTime selectedDate = DateTime.now();
    
    // Si estamos editando y hay fecha, usarla
    if (isEditing && evento!['fechaEvento'] != null) {
      try {
        if (evento['fechaEvento'] is Timestamp) {
          selectedDate = (evento['fechaEvento'] as Timestamp).toDate();
        } else if (evento['fechaEvento'] is String) {
          selectedDate = DateTime.parse(evento['fechaEvento']);
        }
      } catch (e) {
        print('Error al parsear fecha: $e');
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(isEditing ? 'Editar Evento' : 'Nuevo Evento'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Título del evento',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: locationController,
                      decoration: const InputDecoration(
                        labelText: 'Ubicación',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Categoría',
                        border: OutlineInputBorder(),
                      ),
                      items: categorias.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedCategory = newValue;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: const Text('Fecha del evento'),
                      subtitle: Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null && picked != selectedDate) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.isNotEmpty) {
                      final eventoData = {
                        'titulo': titleController.text,
                        'descripcion': descriptionController.text,
                        'ubicacion': locationController.text,
                        'categoria': selectedCategory,
                        'fechaEvento': Timestamp.fromDate(selectedDate),
                      };

                      Map<String, dynamic> result;
                      if (isEditing) {
                        result = await _firestoreService.actualizarEvento(
                          evento!['id'], 
                          eventoData
                        );
                      } else {
                        result = await _firestoreService.agregarEvento(eventoData);
                      }

                      Navigator.pop(context);
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(result['message'] ?? 'Operación completada'),
                          backgroundColor: result['success'] ? Colors.green : Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text(isEditing ? 'Actualizar' : 'Agregar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> evento) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Evento'),
          content: Text('¿Estás seguro de que quieres eliminar "${evento['titulo']}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                
                final result = await _firestoreService.eliminarEvento(evento['id']);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(result['message'] ?? 'Operación completada'),
                    backgroundColor: result['success'] ? Colors.green : Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}