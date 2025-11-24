import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/geo_location/geo_widget.dart';
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
  TextEditingController phone = TextEditingController();
  double? latitude;
  double? longitude;
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
      phone.text = widget.item!.phone;
    }
  }

  Future<void> submit() async {
    try {
      Map<String, dynamic> data = {
        'form_id': '31',
        'name': name.text,
        'address': address.text,
        'phone': phone.text,
      };
      if (picture != null) {
        data.addAll({'picture': multiPartFile(picture!.path)});
      }

      if (widget.item == null) {
        data['location_lat'] = latitude;
        data['location_long'] = longitude;

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
                  required: true,
                ),
                ZInput(
                  label: 'Phone',
                  controller: phone,
                  required: false,
                ),
                ZInput(
                  label: 'Address',
                  controller: address,
                  maxLines: 5,
                  required: false,
                ),
                const SizedBox(height: 30),
                if (widget.item == null)
                  GeoWidget(
                    onChanged: (value) {
                      latitude = value.latitude;
                      longitude = value.longitude;
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
