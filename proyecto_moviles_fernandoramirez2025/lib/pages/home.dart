import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter_slidable/flutter_slidable.dart";
import "package:intl/intl.dart";
import "package:material_design_icons_flutter/material_design_icons_flutter.dart";
import "package:proyecto_moviles_fernandoramirez2025/pages/agregar_evento.dart";
import "package:proyecto_moviles_fernandoramirez2025/pages/detalle_evento.dart";
import "package:proyecto_moviles_fernandoramirez2025/services/auth_service.dart";
import "package:proyecto_moviles_fernandoramirez2025/services/fs_service.dart";
import "package:proyecto_moviles_fernandoramirez2025/utils/util_confirmacion.dart";

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade900,
        title: Row(
          children: [Text("Inicio", style: TextStyle(color: Colors.white))],
        ),
        leading: Icon(Icons.home, color: Colors.white),
        actions: [
          PopupMenuButton(
            iconColor: Colors.white,
            itemBuilder: (context) => [
              PopupMenuItem(value: "logout", child: Text("Cerrar Sesion")),
            ],
            onSelected: (value) => {FirebaseAuth.instance.signOut()},
          ),
        ],
      ),
      //mostrar usuario logueado :)
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            color: Colors.black87,
            width: double.infinity,
            child: FutureBuilder(
              future: AuthService().currentUser(),
              builder: (context, AsyncSnapshot<User?> snapshot) {
                if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  return Text(
                    "Bienvenido ${snapshot.data?.email}",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  );
                }
              },
            ),

            //body
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/home.jpg'), fit: BoxFit.cover),
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: StreamBuilder(
                  stream: FsService().eventos(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text("No hay eventos"));
                    }
                    return ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(height: 5),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var evento = snapshot.data!.docs[index];
                        return Slidable(
                          endActionPane: ActionPane(
                            motion: ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) async {
                                  var confirmar = await UtilConfirmacion.mostrarDialogoConfirmacion(
                                    context,
                                    "Confirmar eliminación",
                                    "¿Estás seguro de que deseas eliminar este evento?",
                                  );
                                  if (confirmar) {
                                    await FsService().eliminarEvento(evento.id);
                                  }
                                },
                                icon: MdiIcons.trashCan,
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.red,
                              ),
                            ],
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetalleEvento(eventId: evento.id),
                                  ),
                                );
                              },
                              leading: CircleAvatar(
                                backgroundColor: Colors.red.shade100,
                                child: Icon(Icons.event, color: Colors.red.shade900),
                              ),
                              title: Text(
                                evento["titulo"],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Chip(
                                    label: Text(evento["categoria"].toString()),
                                    backgroundColor: Colors.red.shade50,
                                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    padding: EdgeInsets.zero,
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(Icons.schedule, size: 16, color: Colors.grey.shade600),
                                      Text(
                                        DateFormat(
                                          'dd/MM/yyyy HH:mm',
                                          'es_CL',
                                        ).format(evento["fecha"].toDate()),
                                        style: TextStyle(color: Colors.grey.shade700),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Icon(Icons.chevron_right, color: Colors.grey.shade600),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 24),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AgregarEvento()));
          },
          backgroundColor: Colors.red.shade700,
          foregroundColor: Colors.white,
          icon: Icon(Icons.add),
          label: Text("Nuevo evento"),
        ),
      ),
    );
  }
}
