import "package:cloud_firestore/cloud_firestore.dart";

class FsService {
  Stream<QuerySnapshot> eventos() {
    return FirebaseFirestore.instance.collection("eventos").snapshots();
  }

  Future<void> eliminarEvento(String id) {
    return FirebaseFirestore.instance.collection("eventos").doc(id).delete();
  }

  Future<QuerySnapshot> categorias() {
    return FirebaseFirestore.instance.collection("categorias").orderBy("nombre").get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> categoriaPorNombre(String nombre) async {
    final query = await FirebaseFirestore.instance
        .collection("categorias")
        .where("nombre", isEqualTo: nombre)
        .limit(1)
        .get();
    if (query.docs.isEmpty) return null;
    return query.docs.first;
  }

  Future<void> agregarEvento(
    String titulo,
    DateTime fecha,
    String categoria,
    String lugar,
    String autor,
  ) {
    return FirebaseFirestore.instance.collection("eventos").doc().set({
      "titulo": titulo,
      "fecha": fecha,
      "categoria": categoria,
      "lugar": lugar,
      "autor": autor,
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> eventoId(String id) {
    return FirebaseFirestore.instance.collection("eventos").doc(id).get();
  }
}
