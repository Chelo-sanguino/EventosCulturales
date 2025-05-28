import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> agregarEvento(Map<String, dynamic> evento) async {
    try {
      await _firestore.collection('eventos').add(evento);
    } catch (e) {
      print('Error al agregar evento: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> obtenerEventos() {
    return _firestore.collection('eventos').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }
}