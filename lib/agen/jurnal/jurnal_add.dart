import 'dart:convert';

import 'package:djadol_mobile/agen/jurnal/product_list.dart';
import 'package:flutter/material.dart';

import 'package:djadol_mobile/agen/retail/retail_add.dart';

import '../../core/widgets/zui.dart';
import 'cart_page.dart';
import 'product_model.dart';
import 'jurnal.dart';

class JurnalAddPage extends StatefulWidget {
  final Jurnal? item;
  const JurnalAddPage({super.key, this.item});

  @override
  State<JurnalAddPage> createState() => _JurnalAddPageState();
}

class _JurnalAddPageState extends State<JurnalAddPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String retailId = '';
  String productId = '';

  @override
  void initState() {
    super.initState();
  }

  List<CartItem> cartItems = [];
  void addItem(Product item) {
    setState(() {
      cartItems.add(CartItem(product: item, quantity: 1));
    });
  }

  void updateQuantity(int index, int change) {
    setState(() {
      final item = cartItems[index];
      item.quantity += change;
      // if (item.quantity < 1) item.quantity = 1;
      if (item.quantity < 1) cartItems.removeAt(index);
    });
  }

  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  int get totalPrice => cartItems.fold(
      0, (sum, item) => sum + (item.quantity * item.product.priceSale));

  Future<void> submit() async {
    try {
      Map<String, dynamic> data = {
        'form_id': '33',
        'retail_id': retailId,
        'product_id': productId,
        'status': 'out',
        'detail': jsonEncode(cartItems),
      };

      print(data);

      // if (widget.item == null) {
      //   await ApiService().post('/form_action', data, context: context);
      // } else {
      //   data['id'] = widget.item!.id;
      //   await ApiService().post('/form_action', data, context: context);
      // }
      // Navigator.pop(context, true);
    } catch (e) {
      print(e);
      ZToast.error(context, 'Sorry something wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jurnal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: ZInputSelect(
                              label: 'Retail',
                              url: '/all/31',
                              id: widget.item?.retailId,
                              vDisplay: widget.item?.retailIdName,
                              onChanged: (v) {
                                retailId = v;
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RetailAddPage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // Set the radius here
                              ),
                            ),
                            child: Icon(Icons.add),
                          ),
                          // ZButton(
                          //   text: '+',
                          //   onPressed: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) => const CartPage(),
                          //       ),
                          //     );
                          //   },
                          // ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text('Produk'),
                          Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductListPage()),
                              ).then((value) {
                                if (value != null) {
                                  addItem(value as Product);
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // Set the radius here
                              ),
                            ),
                            child: Icon(Icons.add),
                          ),
                        ],
                      ),

                      ListView.builder(
                        itemCount: cartItems.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return ProductItem(
                            name: item.product.name,
                            quantity: item.quantity,
                            price: item.product.priceSale,
                            subtotal: item.subtotal,
                            onAdd: () => updateQuantity(index, 1),
                            onMinus: () => updateQuantity(index, -1),
                            onRemove: () => removeItem(index),
                          );
                        },
                      ),
                      // ZInput(
                      //   label: 'Jumlah',
                      //   controller:
                      //       TextEditingController(text: product.count.toString()),
                      //   required: false,
                      //   onChanged: (v) {
                      //     product.count = int.tryParse(v) ?? 0;
                      //   },
                      // ),
                      // ],

                      // ZInput(
                      //   label: 'Jumlah',
                      //   controller: count,
                      //   required: false,
                      // ),
                      // const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(totalPrice.toString(),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ZButton(
                  text: 'Submit',
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    submit();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
