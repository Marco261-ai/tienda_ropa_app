import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../providers/carrito_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _tarjetaController = TextEditingController();
  final _fechaController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _tarjetaController.dispose();
    _fechaController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _finalizarPago(CarritoProvider carrito) async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse('http://192.168.68.61:3000/api/pedidos');
      final body = {
        'usuario_id': 2,
        'total': carrito.total.toStringAsFixed(2),
        'estado': 'pagado',
        'productos':
            carrito.items
                .map(
                  (item) => {
                    'producto_id': item.producto.id,
                    'cantidad': item.cantidad,
                    'precio_unitario': item.producto.precio,
                  },
                )
                .toList(),
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        carrito.vaciarCarrito();

        if (!mounted) return;

        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text("¡Compra realizada!"),
                content: const Text(
                  "Gracias por tu compra. Recibirás un correo con los detalles.",
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: const Text("Aceptar"),
                  ),
                ],
              ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al registrar el pedido")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final carrito = Provider.of<CarritoProvider>(context);
    final items = carrito.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Finalizar Pedido"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Resumen del pedido",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...items.map(
                (item) => ListTile(
                  title: Text(item.producto.nombre),
                  subtitle: Text("Cantidad: ${item.cantidad}"),
                  trailing: Text(
                    "\$${(item.producto.precio * item.cantidad).toStringAsFixed(2)}",
                  ),
                ),
              ),
              const Divider(),
              Text(
                "Total: \$${carrito.total.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Información de Pago",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nombreController,
                      decoration: const InputDecoration(
                        labelText: "Nombre del titular",
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? "Campo requerido"
                                  : null,
                    ),
                    TextFormField(
                      controller: _tarjetaController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Número de tarjeta",
                      ),
                      validator:
                          (value) =>
                              value!.length < 16
                                  ? "Debe tener 16 dígitos"
                                  : null,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _fechaController,
                            decoration: const InputDecoration(
                              labelText: "MM/AA",
                            ),
                            validator:
                                (value) => value!.isEmpty ? "Requerido" : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _cvvController,
                            decoration: const InputDecoration(labelText: "CVV"),
                            validator:
                                (value) =>
                                    value!.length != 3 ? "3 dígitos" : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => _finalizarPago(carrito),
                      icon: const Icon(Icons.check_circle),
                      label: const Text("Pagar ahora"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
