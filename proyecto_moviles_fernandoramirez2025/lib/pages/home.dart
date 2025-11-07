import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:proyecto_moviles_fernandoramirez2025/pages/agregar_evento.dart';
import 'package:proyecto_moviles_fernandoramirez2025/pages/detalle_evento.dart';
import 'package:proyecto_moviles_fernandoramirez2025/services/auth_service.dart';
import 'package:proyecto_moviles_fernandoramirez2025/services/fs_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade900,
        title: Row(
          children: [Text('Inicio', style: TextStyle(color: Colors.white))],
        ),
        leading: Icon(Icons.home, color: Colors.white),
        actions: [
          PopupMenuButton(
            iconColor: Colors.white,
            itemBuilder: (context) => [
              PopupMenuItem(value: 'logout', child: Text('Cerrar Sesion')),
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
                    'Bienvenido ${snapshot.data?.email}',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  );
                }
              },
            ),

            //body
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: StreamBuilder(
                stream: FsService().eventos(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No hay eventos'));
                  }
                  return ListView.separated(
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var evento = snapshot.data!.docs[index];
                      return Slidable(
                        endActionPane: ActionPane(
                          motion: ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) async {
                                await FsService().eliminarEvento(evento.id);
                              },
                              icon: MdiIcons.trashCan,
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.red,
                            ),
                          ],
                        ),
                        child: ListTile(
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetalleEvento(eventId: evento.id),
                              ),
                            );
                          },
                          leading: Icon(Icons.event, color: Colors.red.shade900),
                          title: Text(evento["titulo"]),
                          subtitle: Text(
                            DateFormat(
                              'dd/MM/yyyy HH:mm',
                              'es_CL',
                            ).format(evento["fecha"].toDate()),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 30),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AgregarEvento()));
          },
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
