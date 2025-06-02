import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/producto.dart';
import '../providers/carrito_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Producto producto;

  const ProductDetailScreen({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(producto.nombre),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Icon(Icons.image, size: 120, color: Colors.teal)),
            const SizedBox(height: 20),
            Text(producto.descripcion, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            Text("Talla: ${producto.talla}"),
            Text("Color: ${producto.color}"),
            Text("Marca: ${producto.marca}"),
            const SizedBox(height: 10),
            Text(
              "\$${producto.precio.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Provider.of<CarritoProvider>(
                    context,
                    listen: false,
                  ).agregarProducto(producto);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Producto agregado al carrito"),
                    ),
                  );
                },
                icon: const Icon(Icons.shopping_cart),
                label: const Text("Agregar al carrito"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
