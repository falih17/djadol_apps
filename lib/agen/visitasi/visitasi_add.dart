import 'package:djadol_mobile/agen/retail/retail_add.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/geo_location/geo_widget.dart';
import '../../core/utils/api_service.dart';
import '../../core/widgets/zui.dart';

class VisitasiAddPage extends StatefulWidget {
  const VisitasiAddPage({super.key});

  @override
  State<VisitasiAddPage> createState() => _VisitasiAddPageState();
}

class _VisitasiAddPageState extends State<VisitasiAddPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String retailId = '';
  bool newRetail = false;
  XFile? picture;
  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
  }

  Future<void> submit() async {
    try {
      Map<String, dynamic> data = {
        'retail_id': retailId,
        'status': 'out',
        'latlong': '$latitude,$longitude',
        'is_new': newRetail ? '1' : '0',
      };
      if (picture != null) {
        data.addAll({'photo': multiPartFile(picture!.path)});
      }

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
        title: const Text('Kunjungan'),
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
                      ZInputImage(
                        onChanged: (value) => picture = value,
                        url: '',
                        cameraOnly: true,
                      ),

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
                          SizedBox(width: 20),
                          ZIconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RetailAddPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      ZInputSwitch(
                          label: "Pertama kali kunjungan",
                          value: newRetail,
                          onChanged: (v) {
                            setState(() {
                              newRetail = v;
                            });
                          }),
                      const SizedBox(height: 10),
                      GeoWidget(
                        onChanged: (value) {
                          latitude = value.latitude;
                          longitude = value.longitude;
                        },
                      ),

                      const SizedBox(height: 20),

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
