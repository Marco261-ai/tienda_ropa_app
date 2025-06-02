import 'package:flutter/material.dart';
import '../models/carrito_item.dart';
import '../models/producto.dart';

class CarritoProvider with ChangeNotifier {
  final List<CarritoItem> _items = [];

  List<CarritoItem> get items => _items;

  void agregarProducto(Producto producto) {
    final index = _items.indexWhere((item) => item.producto.id == producto.id);
    if (index != -1) {
      _items[index].cantidad += 1;
    } else {
      _items.add(CarritoItem(producto: producto));
    }
    notifyListeners();
  }

  double get total {
    return _items.fold(
      0,
      (sum, item) => sum + item.producto.precio * item.cantidad,
    );
  }

  void eliminarProducto(Producto producto) {
    _items.removeWhere((item) => item.producto.id == producto.id);
    notifyListeners();
  }

  void vaciarCarrito() {
    _items.clear();
    notifyListeners();
  }
}
