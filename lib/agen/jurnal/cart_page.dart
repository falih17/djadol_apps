import 'package:flutter/material.dart';

class CartItem {
  String name;
  int quantity;
  int price;

  CartItem({
    required this.name,
    required this.quantity,
    required this.price,
  });

  int get subtotal => quantity * price;
}

class ProductItem extends StatelessWidget {
  final String name;
  final int quantity;
  final int price;
  final int subtotal;
  final VoidCallback onAdd;
  final VoidCallback onMinus;
  final VoidCallback onRemove;

  const ProductItem({
    super.key,
    required this.name,
    required this.quantity,
    required this.price,
    required this.subtotal,
    required this.onAdd,
    required this.onMinus,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            // IconButton(
            //   icon: Icon(Icons.delete, color: Colors.red),
            //   onPressed: onRemove,
            // ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text('Harga: ${price.toString()}'),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: onMinus,
                      ),
                      Text('$quantity',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: onAdd,
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Spacer(),
                      Text('Subtotal: ${subtotal.toString()}',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
