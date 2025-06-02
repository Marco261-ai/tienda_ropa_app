class Producto {
  final int id;
  final String nombre;
  final String descripcion;
  final String imagen;
  final String talla;
  final String color;
  final double precio;
  final String marca;

  Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.imagen,
    required this.talla,
    required this.color,
    required this.precio,
    required this.marca,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      imagen: json['imagen'],
      talla: json['talla'],
      color: json['color'],
      precio: double.parse(json['precio'].toString()),
      marca: json['marca'],
    );
  }
}
