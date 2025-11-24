import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:proyecto_moviles_fernandoramirez2025/constantes.dart";
import "package:proyecto_moviles_fernandoramirez2025/services/fs_service.dart";

class AgregarEvento extends StatefulWidget {
  const AgregarEvento({super.key});

  @override
  State<AgregarEvento> createState() => _AgregarEventoState();
}

class _AgregarEventoState extends State<AgregarEvento> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController tituloCtrl = TextEditingController();
  final TextEditingController lugarCtrl = TextEditingController();
  final TextEditingController autorCtrl = TextEditingController();
  DateTime? fechaSeleccionada;
  String? categoriaSeleccionada;

  Future<void> pickFecha() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: fechaSeleccionada ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3),
      helpText: "Selecciona fecha del evento",
    );
    if (picked != null) {
      setState(() => fechaSeleccionada = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colores.kprimary,
        title: Text("Agregar evento", style: TextStyle(color: Colores.ktext)),
        iconTheme: IconThemeData(color: Colores.ktext),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/agregar.jpg'), fit: BoxFit.cover),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                //Titulo
                Card(
                  color: Colores.kbackground,
                  child: TextFormField(
                    controller: tituloCtrl,
                    decoration: InputDecoration(
                      labelText: "Título",
                      prefixIcon: Icon(Icons.title),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (titulo) {
                      if (titulo!.isEmpty) {
                        return "Ingresa el título";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16),
                //Fecha
                Card(
                  color: Colores.kbackground,
                  child: InkWell(
                    onTap: pickFecha,
                    borderRadius: BorderRadius.circular(12),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: "Fecha",
                        prefixIcon: Icon(Icons.event),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        fechaSeleccionada == null
                            ? "Toca para seleccionar"
                            : "${fechaSeleccionada!.day.toString().padLeft(2, "0")}/${fechaSeleccionada!.month.toString().padLeft(2, "0")}/${fechaSeleccionada!.year}",
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                //Lugar
                Card(
                  color: Colores.kbackground,
                  child: TextFormField(
                    controller: lugarCtrl,
                    decoration: InputDecoration(
                      labelText: "Lugar",
                      prefixIcon: Icon(Icons.place),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (lugar) {
                      if (lugar!.isEmpty) {
                        return "Ingresa el lugar";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16),

                //Categoria
                Card(
                  color: Colores.kbackground,
                  child: FutureBuilder<QuerySnapshot>(
                    future: FsService().categorias(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData ||
                          snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: LinearProgressIndicator());
                      }
                      var categorias = snapshot.data!.docs;
                      return DropdownButtonFormField(
                        validator: (categoria) {
                          if (categoriaSeleccionada == null) {
                            return "Selecciona una categoría";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Categoría",
                          prefixIcon: Icon(Icons.category),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        items: categorias.map((categoria) {
                          return DropdownMenuItem<String>(
                            value: categoria["nombre"],
                            child: Text(categoria["nombre"].toString()),
                          );
                        }).toList(),
                        onChanged: (valor) {
                          categoriaSeleccionada = valor;
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: 16),
                //Autor
                Card(
                  color: Colores.kbackground,
                  child: TextFormField(
                    controller: autorCtrl,
                    decoration: InputDecoration(
                      labelText: "Autor",
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (autor) {
                      if (autor!.isEmpty) {
                        return "Ingresa el autor";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 15),
                SizedBox(
                  height: 50,
                  child: FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: Colores.kprimary),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        if (fechaSeleccionada == null) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text("Selecciona la fecha del evento")));
                          return;
                        }
                        await FsService().agregarEvento(
                          tituloCtrl.text.trim(),
                          fechaSeleccionada!,
                          categoriaSeleccionada!,
                          lugarCtrl.text.trim(),
                          autorCtrl.text.trim(),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      "Guardar evento",
                      style: TextStyle(color: Colores.ktext, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
