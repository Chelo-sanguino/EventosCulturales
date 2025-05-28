import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class EventosPage extends StatefulWidget {
  final String categoria;

  const EventosPage({super.key, required this.categoria});

  @override
  State<EventosPage> createState() => _EventosPageState();
}

class _EventosPageState extends State<EventosPage> {
  final FirestoreService _firestoreService = FirestoreService();
  late Stream<List<Map<String, dynamic>>> eventosStream;

  @override
  void initState() {
    super.initState();
    eventosStream = _firestoreService.obtenerEventos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Eventos - ${widget.categoria}')),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: eventosStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar eventos'));
          }
          final eventos = snapshot.data ?? [];
          return ListView.builder(
            itemCount: eventos.length,
            itemBuilder: (context, index) {
              final evento = eventos[index];
              return ListTile(
                title: Text(evento['titulo']),
                subtitle: Text(evento['descripcion']),
              );
            },
          );
        },
      ),
    );
  }
}