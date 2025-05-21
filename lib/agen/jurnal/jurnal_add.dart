import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
      // name.text = widget.item!.name;
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
      };

      if (widget.item == null) {
        await ApiService().post('/form_action', data, context: context);
      } else {
        data['id'] = widget.item!.id;
        await ApiService().post('/form_action', data, context: context);
      }
      Navigator.pop(context, true);
    } catch (e) {
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
                ZInput(
                  label: 'Count',
                  controller: count,
                  required: false,
                ),
                ZInput(
                  label: 'Price',
                  controller: price,
                  required: false,
                ),
                ZInputSelect(
                  label: 'Retail',
                  url: '/all/31',
                  vData: 'name',
                  vKey: 'id',
                  id: widget.item?.retailId,
                  onChanged: (v) {
                    retailId = v;
                  },
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
