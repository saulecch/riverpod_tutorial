import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class CartItem {
  // variables
  final int number;
  final bool inCart;

  // constructor
  const CartItem({required this.number, required this.inCart});

  // funcion para cambiar alguno de los parametros
  CartItem copyWith({int? number, bool? inCart}) {
    return CartItem(
        number: number ?? this.number, inCart: inCart ?? this.inCart);
  }
}

// Genera una lista de tipo CartItem del 0 al 9 todos con el valor inCart falso
var cartList =
    List<CartItem>.generate(10, (i) => CartItem(number: i++, inCart: false));

// Notifier del estado de la lista de items de compra
class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super(cartList);

  // añade un nuevo item, reemplazando la lista anterior, porque state es immutable
  void add(CartItem item) {
    state = [...state, item];
  }

  // cambia el estado de inCart al valor contrario, falso -> verdadero y viceversa
  void toggle(int itemNumber) {
    state = [
      for (final item in state)
        if (item.number == itemNumber)
          item.copyWith(inCart: !item.inCart)
        else
          item,
    ];
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