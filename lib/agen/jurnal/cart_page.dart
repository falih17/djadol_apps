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

  int get finalPrice {
    if (product.priceMinSale3 < quantity && product.priceSale3 > 0) {
      return product.priceSale3;
    } else if (product.priceMinSale2 < quantity && product.priceSale2 > 0) {
      return product.priceSale2;
    }
    return product.priceSale;
  }

  int get subtotal {
    if (product.priceMinSale3 < quantity && product.priceSale3 > 0) {
      return quantity * product.priceSale3;
    } else if (product.priceMinSale2 < quantity && product.priceSale2 > 0) {
      return quantity * product.priceSale2;
    }
    return quantity * product.priceSale;
  }

  Map<String, dynamic> toJson() {
    return {
      "product_name": product.name,
      "product_id": product.productId,
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
  final String picture;
  final VoidCallback onAdd;
  final VoidCallback onMinus;
  final VoidCallback onRemove;

  const ProductItem({
    super.key,
    required this.name,
    required this.quantity,
    required this.price,
    required this.subtotal,
    required this.picture,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: picture.isNotEmpty
                  ? Image.network(
                      picture,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image,
                        color: Colors.grey,
                        size: 32,
                      ),
                    ),
            ),
            SizedBox(width: 16),
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
