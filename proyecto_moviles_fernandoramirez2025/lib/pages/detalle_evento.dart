import 'package:flutter/material.dart';

class DetalleEvento extends StatelessWidget {
  const DetalleEvento({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade900,
        title: Text('Detalle del Evento', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(child: Text('Detalles del evento')),
    );
  }
}
