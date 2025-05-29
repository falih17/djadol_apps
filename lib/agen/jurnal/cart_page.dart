import 'package:djadol_mobile/agen/jurnal/product_model.dart';
import 'package:flutter/material.dart';
import '../../core/utils/ext_currency.dart';

class CartItem {
  int quantity;
  Product product;

  CartItem({
    required this.quantity,
    required this.product,
  });

  int get subtotal => quantity * product.priceSale;

  Map<String, dynamic> toJson() {
    return {
      "product_name": product.name,
      "product_id": product.id,
      "count": quantity,
      "price": product.priceSale,
      "subtotal": subtotal * -1,
      "status": 'out',
    };
  }
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
      color: Colors.white,
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
                      Text('Rp ${price.toString().toCurrency()}',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.remove),
                        color: Colors.red,
                        onPressed: onMinus,
                      ),
                      Text('$quantity',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: Icon(Icons.add),
                        color: Colors.green,
                        onPressed: onAdd,
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Spacer(),
                      Text('Subtotal: ${subtotal.toString().toCurrency()}',
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
