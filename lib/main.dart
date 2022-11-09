import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_tutorial/state_managment.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<CartItem> cartItems = ref.watch(filteredCartListProvider);

    // Conteo total de items para añadir uno nuevo a partir del último
    int totalItems = ref.read(cartListProvider.notifier).countTotalItems();

    // Valor del menu dropDown
    String dropDownValue = ref.watch(menuProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Lista del super'),
        actions: [
          DropdownButton(
              dropdownColor: Colors.blue,
              style: const TextStyle(color: Colors.white),
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              ),
              value: dropDownValue,

              // se crea una lista de items a partir de la que definimos en state_managment.dart
              items: menuItems
                  .map((String e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),

              // al cambiar se asigna un nuevo valor al provider del menu
              onChanged: (String? value) => ref
                  .read(menuProvider.notifier)
                  .update((state) => state = value!))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
            itemBuilder: ((context, index) {
              return Card(
                elevation: 2,
                child: CheckboxListTile(
                  title: Text('Item de compra ${cartItems[index].number}'),
                  value: cartItems[index].inCart,
                  onChanged: (value) => ref
                      .read(cartListProvider.notifier)
                      .toggle(cartItems[index].number),
                ),
              );
            }),
            separatorBuilder: ((context, index) => const SizedBox(
                  height: 8,
                )),
            itemCount: cartItems.length),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => ref
            .read(cartListProvider.notifier)
            .add(CartItem(number: totalItems, inCart: false)),
      ),
    );
  }
}
