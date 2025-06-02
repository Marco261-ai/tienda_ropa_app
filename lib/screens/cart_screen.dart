import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/carrito_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final carrito = Provider.of<CarritoProvider>(context);
    final items = carrito.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Carrito'),
        backgroundColor: Colors.teal,
      ),
      body:
          items.isEmpty
              ? const Center(child: Text('Tu carrito está vacío'))
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return ListTile(
                          leading: const Icon(Icons.shopping_bag),
                          title: Text(item.producto.nombre),
                          subtitle: Text("Cantidad: ${item.cantidad}"),
                          trailing: Text(
                            "\$${(item.producto.precio * item.cantidad).toStringAsFixed(2)}",
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          "Total: \$${carrito.total.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, '/checkout');
                          },
                          icon: const Icon(Icons.payment),
                          label: const Text("Finalizar pedido"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () {
                            carrito.vaciarCarrito();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Carrito vaciado")),
                            );
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text("Vaciar carrito"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}
