import "package:flutter/material.dart";

class UtilConfirmacion {
  static Future<bool> mostrarDialogoConfirmacion(
    BuildContext context,
    String titulo,
    String contenido,
  ) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(titulo),
              content: Text(contenido),
              actions: <Widget>[
                TextButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: Text("Aceptar"),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
