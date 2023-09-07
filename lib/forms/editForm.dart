import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_tutorial/state_managment.dart';

class EditItem extends ConsumerStatefulWidget {
  final int id;
  final String currentName;
  final int currentQuantity;
  const EditItem({
    super.key,
    required this.id,
    required this.currentName,
    required this.currentQuantity,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditItemState();
}

class _EditItemState extends ConsumerState<EditItem> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  @override
  void initState() {
    productNameController.text = widget.currentName;
    quantityController.text = widget.currentQuantity.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    // Eliminar item
                    ref.read(cartListProvider.notifier).delete(widget.id);
                    // Ocultar modal
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.delete)),
            ],
          ),
          TextField(
            controller: productNameController,
            decoration: const InputDecoration(labelText: 'Nombre del producto'),
          ),
          TextField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Cantidad'),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () {
              final productName = productNameController.text;
              final quantity = int.tryParse(quantityController.text);

              if (productName.isNotEmpty && quantity != null) {
                // Actualizar item en la lista
                ref.read(cartListProvider.notifier).edit(
                      widget.id,
                      productName,
                      quantity,
                    );

                // Limpiar campos
                productNameController.clear();
                quantityController.clear();

                // Ocultar modal
                Navigator.of(context).pop();
              }
            },
            child: const Text('Actualizar'),
          ),
        ],
      ),
    );
  }
}
