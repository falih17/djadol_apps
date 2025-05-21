import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/utils/api_service.dart';
import '../../core/widgets/zui.dart';
import 'retail.dart';

class RetailAddPage extends StatefulWidget {
  final Retail? item;
  const RetailAddPage({super.key, this.item});

  @override
  State<RetailAddPage> createState() => _RetailAddPageState();
}

class _RetailAddPageState extends State<RetailAddPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  XFile? picture;

  @override
  void initState() {
    initData();
    super.initState();
  }

  Future<void> initData() async {
    if (widget.item != null) {
      name.text = widget.item!.name;
      address.text = widget.item!.address;
    }
  }

  Future<void> submit() async {
    try {
      final data = {
        'form_id': '31',
        'name': name.text,
        'address': address,
      };
      if (picture != null) {
        data.addAll({'picture': multiPartFile(picture!.path)});
      }

      if (widget.item == null) {
        await ApiService().post('/form_action', data, context: context);
      } else {
        String id = widget.item!.id;
        await ApiService().patch('/form_action', id, data, context: context);
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
        title: const Text('Retail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ZInputImage(
                  url: (widget.item?.picture.isEmpty ?? true)
                      ? ''
                      : widget.item!.picture,
                  onChanged: (value) => picture = value,
                ),
                ZInput(
                  label: 'Name',
                  controller: name,
                  required: false,
                ),
                ZInput(
                  label: 'Address',
                  controller: address,
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
