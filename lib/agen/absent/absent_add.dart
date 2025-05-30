import 'package:djadol_mobile/core/geo_location/geo_widget.dart';
import 'package:djadol_mobile/core/widgets/zui.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/utils/api_service.dart';

class AbsentAddPage extends StatefulWidget {
  final bool type;
  const AbsentAddPage({super.key, required this.type});

  @override
  State<AbsentAddPage> createState() => _AbsentAddPageState();
}

class _AbsentAddPageState extends State<AbsentAddPage> {
  XFile? picture;
  double? latitude;
  double? longitude;

  Future<void> submit() async {
    try {
      String formId = widget.type ? '41' : '42';

      Map<String, dynamic> data = {
        'form_id': formId,
        'absen_lattitude': latitude,
        'absen_longitude': longitude,
      };
      if (picture != null) {
        data.addAll({'absen_foto': multiPartFile(picture!.path)});
      }

      await ApiService().post('/form_action', data, context: context);
      Navigator.pop(context, true);
    } catch (e) {
      ZToast.error(context, 'Sorry something wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type ? 'Presensi Masuk' : ' Presensi Pulang'),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  ZInputImage(
                    onChanged: (value) => picture = value,
                    url: '',
                    cameraOnly: true,
                  ),
                  GeoWidget(
                    onChanged: (value) {
                      latitude = value.latitude;
                      longitude = value.longitude;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            ZButton(
              text: 'Submit',
              onPressed: () {
                if (picture == null) {
                  ZToast.error(context, 'Please take a picture');
                  return;
                } else if (latitude == null || longitude == null) {
                  ZToast.error(context, 'Please get your location');
                  return;
                }
                submit();
              },
            ),
          ],
        ),
      )),
    );
  }
}
