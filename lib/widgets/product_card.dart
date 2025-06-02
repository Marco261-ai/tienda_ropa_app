import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../screens/product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  final Producto producto;

  const ProductCard({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal,
          child: Text(
            producto.nombre[0],
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(producto.nombre),
        subtitle: Text(
          "\$${producto.precio.toStringAsFixed(2)} - ${producto.marca}",
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.teal),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailScreen(producto: producto),
            ),
          );
        },
      ),
    );
  }
}
