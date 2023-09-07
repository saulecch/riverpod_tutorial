import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class CartItem {
  // variables
  int? id;
  final String name;
  final int quantity;
  final bool inCart;

  // constructor
  CartItem(
      {this.id,
      required this.name,
      required this.quantity,
      required this.inCart});

  // funcion para cambiar alguno de los parametros
  CartItem copyWith({String? name, int? quantity, bool? inCart}) {
    return CartItem(
        id: this.id,
        name: name ?? this.name,
        quantity: quantity ?? this.quantity,
        inCart: inCart ?? this.inCart);
  }
}

// Genera una lista de tipo CartItem del 0 al 9 todos con el valor inCart falso
// var cartList = List<CartItem>.generate(
//     3, (i) => CartItem(id: i++, name: 'Item', quantity: i++, inCart: false));
var cartList = List<CartItem>.empty();
// Notifier del estado de la lista de items de compra
class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super(cartList);
  int _idCounter = 0;
  int _generateUniqueID() {
    _idCounter++;
    return _idCounter;
  }

  // añade un nuevo item, reemplazando la lista anterior, porque state es immutable
  void add(CartItem item) {
    final uniqueID = _generateUniqueID();
    item.id = uniqueID;
    state = [...state, item];
  }

  // cambia el estado de inCart al valor contrario, falso -> verdadero y viceversa
  void toggle(int itemId) {
    state = [
      for (final item in state)
        if (item.id == itemId) item.copyWith(inCart: !item.inCart) else item,
    ];
  }

  // edita el item segun el id
  void edit(int id, String name, int quantity) {
    state[id] = state[id].copyWith(name: name, quantity: quantity);
    state = [...state];
  }

  // elimina el item segun el id
  void delete(int id) {
    state.removeWhere((element) => element.id == id);
    state = [...state];
  }

  // retorna un entero para saber el total de items en la lista completa
  int countTotalItems() {
    return state.length;
  }
}

// Provider de la lista de compras
final cartListProvider =
    StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

// Lista del menu desplegable
var menuItems = [
  'En el carrito',
  'Por comprar',
  'Completa',
];

// Provider para saber el estado del menu, por defecto inicia con la lista completa
final menuProvider = StateProvider<String>((ref) {
  return 'Completa';
});

// Provider para retornar la lista filtrada segun los items del menu
final filteredCartListProvider = Provider<List<CartItem>>((ref) {
  final filter = ref.watch(menuProvider);
  final cartList = ref.watch(cartListProvider);
  switch (filter) {
    case 'Completa':
      return cartList;
    case 'En el carrito':
      return cartList.where((item) => item.inCart).toList();
    case 'Por comprar':
      return cartList.where((item) => !item.inCart).toList();
  }
  throw {};
});
