import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:proyecto_moviles_fernandoramirez2025/services/fs_service.dart";

class DetalleEvento extends StatelessWidget {
  const DetalleEvento({super.key, required this.eventId});
  final String eventId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade900,
        title: Text("Detalle del Evento", style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        color: Colors.grey.shade200,

        child: Column(
          children: [
            FutureBuilder(
              future: FsService().eventoId(eventId),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                var eventoData = snapshot.data!.data() as Map<String, dynamic>;
                return Card(
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          eventoData["titulo"],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Categoría: ${eventoData["categoria"]}",
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        Divider(height: 24, thickness: 1),
                        Row(
                          children: [
                            Icon(Icons.person_outline, color: Colors.red),
                            SizedBox(width: 8),
                            Text("Autor: ${eventoData["autor"]}", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, color: Colors.red),
                            SizedBox(width: 8),
                            Text("Lugar: ${eventoData["lugar"]}", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_outlined, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              "Fecha: ${eventoData["fecha"] != null ? (eventoData["fecha"] as Timestamp).toDate().toString().split(' ')[0] : "Desconocido"}",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
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
