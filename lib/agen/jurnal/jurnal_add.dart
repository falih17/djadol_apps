import 'dart:convert';

import 'package:djadol_mobile/agen/jurnal/product_list.dart';
import 'package:djadol_mobile/core/utils/ext_currency.dart';
import 'package:flutter/material.dart';

import '../../core/utils/api_service.dart';
import '../../core/widgets/zui.dart';
import 'cart_page.dart';
import 'product_model.dart';

class JurnalAddPage extends StatefulWidget {
  const JurnalAddPage({super.key});

  @override
  State<JurnalAddPage> createState() => _JurnalAddPageState();
}

class _JurnalAddPageState extends State<JurnalAddPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String retailId = '';
  bool newRetail = false;
  // XFile? picture;
  double? latitude;
  double? longitude;

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

  int get totalPrice => cartItems.fold(0, (sum, item) => sum + (item.subtotal));

  Future<void> submit() async {
    try {
      Map<String, dynamic> data = {
        'retail_id': retailId,
        'status': 'out',
        'latlong': '$latitude,$longitude',
        'is_new': newRetail ? '1' : '0',
        'total_price': totalPrice,
        'detail': jsonEncode(cartItems),
      };
      // if (picture != null) {
      //   data.addAll({'photo': multiPartFile(picture!.path)});
      // }

      await ApiService().post('/bulk/form_action/20', data, context: context);
      Navigator.pop(context, true);
    } catch (e) {
      ZToast.error(context, 'Sorry something wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales'),
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
                      // ZInputImage(
                      //   onChanged: (value) => picture = value,
                      //   url: '',
                      //   cameraOnly: true,
                      // ),
                      // ZInputSwitch(
                      //     label: "Toko Baru",
                      //     value: newRetail,
                      //     onChanged: (v) {
                      //       setState(() {
                      //         newRetail = v;
                      //       });
                      //     }),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: ZInputSelect(
                              label: 'Toko',
                              url: '/all/31',
                              onChanged: (v) {
                                retailId = v;
                              },
                            ),
                          ),
                          // SizedBox(width: 10),
                          // ZIconButton(
                          //   onPressed: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) => const RetailAddPage(),
                          //       ),
                          //     );
                          //   },
                          // ),
                        ],
                      ),
                      // const SizedBox(height: 20),
                      // GeoWidget(
                      //   onChanged: (value) {
                      //     latitude = value.latitude;
                      //     longitude = value.longitude;
                      //   },
                      // ),

                      const SizedBox(height: 20),
                      ZButton(
                        text: '+ Tambah Produk',
                        radius: 20,
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
                      ),

                      ListView.builder(
                        itemCount: cartItems.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return ProductItem(
                            name: item.product.name,
                            picture: item.product.picture,
                            quantity: item.quantity,
                            price: item.finalPrice,
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
                    Text(totalPrice.toString().toCurrency(),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ZButton(
                  text: 'Simpan',
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    if (retailId.isEmpty) {
                      ZToast.error(context, 'Toko harus diisi');
                      return;
                    }
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
