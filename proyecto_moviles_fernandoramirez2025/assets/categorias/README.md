Coloca aquí las imágenes de cada categoría.

Recomendación:
- Nombres de archivo simples, sin espacios. Ej: charla.png, coloquio.jpg, workshop.png
- En la colección `categorias` de Firestore, cada documento debe tener:
  - nombre: "Charla" | "Coloquio" | "Workshop" (o las que uses)
  - imagen: nombre del archivo, por ejemplo "charla.png"

Ejemplo de documentos en Firestore (colección `categorias`):
- { nombre: "Charla", imagen: "charla.png" }
- { nombre: "Coloquio", imagen: "coloquio.png" }
- { nombre: "Workshop", imagen: "workshop.png" }

Si una imagen no existe, la app mostrará un ícono de imagen como placeholder.
