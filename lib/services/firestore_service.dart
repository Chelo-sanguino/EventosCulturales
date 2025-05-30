import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Agregar evento con manejo de errores mejorado
  Future<Map<String, dynamic>> agregarEvento(Map<String, dynamic> evento) async {
    try {
      // Agregar timestamp de creación
      evento['fechaCreacion'] = FieldValue.serverTimestamp();
      evento['fechaModificacion'] = FieldValue.serverTimestamp();
      
      DocumentReference docRef = await _firestore.collection('eventos').add(evento);
      
      return {
        'success': true,
        'message': 'Evento agregado exitosamente',
        'eventoId': docRef.id
      };
    } on FirebaseException catch (e) {
      print('Error de Firebase al agregar evento: ${e.code} - ${e.message}');
      return {
        'success': false,
        'message': 'Error al guardar el evento: ${e.message}',
        'code': e.code
      };
    } catch (e) {
      print('Error inesperado al agregar evento: $e');
      return {
        'success': false,
        'message': 'Error inesperado al guardar el evento'
      };
    }
  }

  // Obtener todos los eventos
  Stream<List<Map<String, dynamic>>> obtenerEventos() {
    return _firestore
        .collection('eventos')
        .orderBy('fechaEvento', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        data['id'] = doc.id; // Agregar el ID del documento
        return data;
      }).toList();
    });
  }

  // Obtener eventos por categoría
  Stream<List<Map<String, dynamic>>> obtenerEventosPorCategoria(String categoria) {
    if (categoria == 'Todos' || categoria == 'Calendario') {
      return obtenerEventos();
    }
    
    print('Buscando eventos de categoría: $categoria'); // Agregar debug print
    
    return _firestore
        .collection('eventos')
        .where('categoria', isEqualTo: categoria)
        .snapshots()
        .map((snapshot) {
      print('Eventos encontrados: ${snapshot.docs.length}'); // Agregar debug print
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        data['id'] = doc.id;
        print('Evento: ${data['titulo']} - Categoría: ${data['categoria']}'); // Debug
        return data;
      }).toList();
    });
  }

  // Obtener eventos próximos (para calendario)
  Stream<List<Map<String, dynamic>>> obtenerEventosProximos({int dias = 30}) {
    DateTime ahora = DateTime.now();
    DateTime limite = ahora.add(Duration(days: dias));
    
    return _firestore
        .collection('eventos')
        .where('fechaEvento', isGreaterThanOrEqualTo: Timestamp.fromDate(ahora))
        .where('fechaEvento', isLessThanOrEqualTo: Timestamp.fromDate(limite))
        .orderBy('fechaEvento', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  // Obtener un evento específico por ID
  Future<Map<String, dynamic>?> obtenerEventoPorId(String eventoId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('eventos').doc(eventoId).get();
      
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }
      return null;
    } catch (e) {
      print('Error al obtener evento por ID: $e');
      return null;
    }
  }

  // Actualizar evento
  Future<Map<String, dynamic>> actualizarEvento(String eventoId, Map<String, dynamic> datosActualizados) async {
    try {
      datosActualizados['fechaModificacion'] = FieldValue.serverTimestamp();
      
      await _firestore.collection('eventos').doc(eventoId).update(datosActualizados);
      
      return {
        'success': true,
        'message': 'Evento actualizado exitosamente'
      };
    } on FirebaseException catch (e) {
      print('Error de Firebase al actualizar evento: ${e.code} - ${e.message}');
      return {
        'success': false,
        'message': 'Error al actualizar el evento: ${e.message}'
      };
    } catch (e) {
      print('Error inesperado al actualizar evento: $e');
      return {
        'success': false,
        'message': 'Error inesperado al actualizar el evento'
      };
    }
  }

  // Eliminar evento
  Future<Map<String, dynamic>> eliminarEvento(String eventoId) async {
    try {
      await _firestore.collection('eventos').doc(eventoId).delete();
      
      return {
        'success': true,
        'message': 'Evento eliminado exitosamente'
      };
    } on FirebaseException catch (e) {
      print('Error de Firebase al eliminar evento: ${e.code} - ${e.message}');
      return {
        'success': false,
        'message': 'Error al eliminar el evento: ${e.message}'
      };
    } catch (e) {
      print('Error inesperado al eliminar evento: $e');
      return {
        'success': false,
        'message': 'Error inesperado al eliminar el evento'
      };
    }
  }

  // Buscar eventos por texto
  Stream<List<Map<String, dynamic>>> buscarEventos(String textoBusqueda) {
    return _firestore
        .collection('eventos')
        .where('titulo', isGreaterThanOrEqualTo: textoBusqueda)
        .where('titulo', isLessThanOrEqualTo: textoBusqueda + '\uf8ff')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }
}