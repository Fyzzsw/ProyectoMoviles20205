import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
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
      body: Expanded(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/detalle.jpg'), fit: BoxFit.cover),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              FutureBuilder(
                future: FsService().eventoId(eventId),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  final eventoData = snapshot.data!.data() as Map<String, dynamic>;
                  final fecha = (eventoData["fecha"] as Timestamp?)?.toDate();
                  final fechaFmt = fecha != null
                      ? DateFormat("dd/MM/yyyy HH:mm").format(fecha)
                      : "Desconocido";

                  return Card(
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //imagen con categoria
                          FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
                            future: FsService().categoriaPorNombre(eventoData["categoria"]),
                            builder: (context, snapshotCat) {
                              if (!snapshotCat.hasData ||
                                  snapshotCat.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }
                              //variable snapshot de la imagen especifica
                              final base = (eventoData["categoria"] ?? "")
                                  .toString()
                                  .toLowerCase()
                                  .trim();

                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      "assets/categorias/" + base + ".jpg",
                                      width: 64,
                                      height: 64,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Image.asset(
                                        "assets/categorias/" + base + ".jpg",
                                        width: 64,
                                        height: 64,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Image.asset(
                                          "assets/categorias/" + base + ".jpeg",
                                          width: 64,
                                          height: 64,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            width: 64,
                                            height: 64,
                                            color: Colors.grey.shade300,
                                            child: Icon(
                                              Icons.image_not_supported,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          eventoData["titulo"],
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "Categoría: ${eventoData["categoria"]}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          Divider(height: 24),
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
                              Text("Fecha: $fechaFmt", style: TextStyle(fontSize: 16)),
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
      ),
    );
  }
}
