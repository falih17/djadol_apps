import 'package:djadol_mobile/agen/retail/retail_add.dart';
import 'package:flutter/material.dart';
import '../../core/utils/api_service.dart';
import '../../core/widgets/zui.dart';
import 'jurnal.dart';

class JurnalAddPage extends StatefulWidget {
  final Jurnal? item;
  const JurnalAddPage({super.key, this.item});

  @override
  State<JurnalAddPage> createState() => _JurnalAddPageState();
}

class _JurnalAddPageState extends State<JurnalAddPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController count = TextEditingController();
  TextEditingController price = TextEditingController();
  String retailId = '';
  String productId = '';

  @override
  void initState() {
    initData();
    super.initState();
  }

  Future<void> initData() async {
    if (widget.item != null) {
      count.text = widget.item!.count;
      retailId = widget.item!.retailId;
      productId = widget.item!.productId;
      price.text = widget.item!.price;
      // address.text = widget.item!.address;
    }
  }

  Future<void> submit() async {
    try {
      Map<String, dynamic> data = {
        'form_id': '33',
        'count': count.text,
        'price': price.text,
        'retail_id': retailId,
        'product_id': productId,
        'status': 'out',
      };

      if (widget.item == null) {
        await ApiService().post('/form_action', data, context: context);
      } else {
        data['id'] = widget.item!.id;
        await ApiService().post('/form_action', data, context: context);
      }
      Navigator.pop(context, true);
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
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ZInputSelect(
                  label: 'Retail',
                  url: '/all/31',
                  id: widget.item?.retailId,
                  vDisplay: widget.item?.retailIdName,
                  onChanged: (v) {
                    retailId = v;
                  },
                ),
                ZButton(
                  text: 'Tambah Retail Baru',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RetailAddPage(),
                      ),
                    );
                  },
                ),
                ZInputSelect(
                  label: 'Product',
                  url: '/all/30',
                  id: widget.item?.productId,
                  vDisplay: widget.item?.productIdName,
                  onChanged: (v) {
                    productId = v;
                  },
                ),
                ZInput(
                  label: 'Jumlah',
                  controller: count,
                  required: false,
                ),
                ZInput(
                  label: 'Harga',
                  controller: price,
                  required: false,
                ),
                const SizedBox(height: 30),
                ZButton(
                  text: 'Submit',
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    submit();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
