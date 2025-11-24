import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter_slidable/flutter_slidable.dart";
import "package:intl/intl.dart";
import "package:material_design_icons_flutter/material_design_icons_flutter.dart";
import "package:proyecto_moviles_fernandoramirez2025/constantes.dart";
import "package:proyecto_moviles_fernandoramirez2025/pages/agregar_evento.dart";
import "package:proyecto_moviles_fernandoramirez2025/pages/detalle_evento.dart";
import "package:proyecto_moviles_fernandoramirez2025/services/auth_service.dart";
import "package:proyecto_moviles_fernandoramirez2025/services/fs_service.dart";
import "package:proyecto_moviles_fernandoramirez2025/utils/util_confirmacion.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? categoriaSeleccionada;
  bool _verSoloMisEventos = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colores.kprimary,
        title: Row(
          children: [Text("Inicio", style: TextStyle(color: Colores.ktext))],
        ),
        leading: Icon(Icons.home, color: Colores.ktext),
        actions: [
          PopupMenuButton(
            iconColor: Colores.ktext,
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
            color: Colores.kprimary,
            width: double.infinity,
            child: FutureBuilder(
              future: AuthService().currentUser(),
              builder: (context, AsyncSnapshot<User?> snapshot) {
                if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  return Text(
                    "Bienvenido ${snapshot.data?.email}",
                    style: TextStyle(fontSize: 15, color: Colores.ktext),
                  );
                }
              },
            ),
          ),
          //mostrar lista de categorias
          FutureBuilder<QuerySnapshot>(
            future: FsService().categorias(),
            builder: (context, snapshot) {
              if (!snapshot.hasData ||
                  snapshot.data!.docs.isEmpty ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              var docs = snapshot.data!.docs;
              return Container(
                height: 50,
                color: Colores.kbackground,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          categoriaSeleccionada = null;
                          _verSoloMisEventos = false;
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: categoriaSeleccionada == null && !_verSoloMisEventos
                            ? Colores.kprimary
                            : Colores.ksecondary,
                        foregroundColor: categoriaSeleccionada == null && !_verSoloMisEventos
                            ? Colores.ktext
                            : Colores.kprimary,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: Text("Todas"),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _verSoloMisEventos = true;
                          categoriaSeleccionada = null;
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: _verSoloMisEventos ? Colores.kprimary : Colores.ksecondary,
                        foregroundColor: _verSoloMisEventos ? Colores.ktext : Colores.kprimary,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: Text("Mis Eventos"),
                    ),
                    ...docs.map((c) {
                      var nombre = c["nombre"].toString();
                      bool activo = categoriaSeleccionada == nombre;
                      return Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              categoriaSeleccionada = nombre;
                              _verSoloMisEventos = false;
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: activo ? Colores.kprimary : Colores.ksecondary,
                            foregroundColor: activo ? Colores.ktext : Colores.kprimary,
                            padding: EdgeInsets.symmetric(horizontal: 12),
                          ),
                          child: Text(nombre),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              );
            },
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
                    if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty ||
                        snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final userEmail = FirebaseAuth.instance.currentUser?.email;
                    var todos = snapshot.data!.docs;
                    var filtrados = todos;

                    if (_verSoloMisEventos) {
                      filtrados = todos.where((e) => e["autor"] == userEmail).toList();
                    } else if (categoriaSeleccionada != null) {
                      filtrados = todos
                          .where((e) => e["categoria"].toString() == categoriaSeleccionada)
                          .toList();
                    }

                    if (filtrados.isEmpty) {
                      return Center(
                        child: Text(
                          _verSoloMisEventos
                              ? "No has creado eventos"
                              : "Sin eventos en ${categoriaSeleccionada}",
                        ),
                      );
                    }

                    return ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(height: 5),
                      itemCount: filtrados.length,
                      itemBuilder: (context, index) {
                        var evento = filtrados[index];
                        final esAutor = (userEmail != null && evento["autor"] == userEmail);

                        final card = Card(
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
                              backgroundColor: Colores.kaccent,
                              child: Icon(Icons.event, color: Colores.kprimary),
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
                                  backgroundColor: Colores.ksecondary,
                                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  padding: EdgeInsets.zero,
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(Icons.schedule, size: 16, color: Colores.ksecondary),
                                    Text(
                                      DateFormat(
                                        'dd/MM/yyyy HH:mm',
                                        'es_CL',
                                      ).format(evento["fecha"].toDate()),
                                      style: TextStyle(color: Colores.kprimary),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Icon(Icons.chevron_right, color: Colores.ksecondary),
                          ),
                        );

                        if (!esAutor) return card;

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
                                foregroundColor: Colores.ktext,
                                backgroundColor: Colores.kaccent,
                              ),
                            ],
                          ),
                          child: card,
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
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "fabAgregar",
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AgregarEvento()));
        },
        backgroundColor: Colores.kprimary,
        foregroundColor: Colores.ktext,
        icon: Icon(Icons.add),
        label: Text("Nuevo evento"),
      ),
    );
  }
}
