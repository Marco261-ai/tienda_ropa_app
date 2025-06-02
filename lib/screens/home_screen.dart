import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../models/producto.dart';
import '../services/api_service.dart';
import '../widgets/product_card.dart';
import '../providers/carrito_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        title: Text("Catálogo de Ropa", style: GoogleFonts.poppins()),
        backgroundColor: Colors.teal,
        actions: [
          Consumer<CarritoProvider>(
            builder: (context, carrito, child) {
              return GestureDetector(
                onTap: () {
                  print("🛒 Icono tocado");
                  Navigator.pushNamed(context, '/carrito');
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Icon(Icons.shopping_cart, size: 28),
                    ),
                    if (carrito.items.isNotEmpty)
                      Positioned(
                        right: 10,
                        top: 10,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder:
                              (child, animation) => ScaleTransition(
                                scale: animation,
                                child: child,
                              ),
                          child: Container(
                            key: ValueKey<int>(carrito.items.length),
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              carrito.items.length.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Producto>>(
        future: ApiService.obtenerProductos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SpinKitFadingCircle(color: Colors.teal, size: 50),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final productos = snapshot.data!;
            return ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, index) {
                return ProductCard(producto: productos[index]);
              },
            );
          } else {
            return const Center(child: Text("No hay productos"));
          }
        },
      ),
    );
  }
}
