import 'dart:io';

import 'package:djadol_mobile/core/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'zbutton.dart';

class ZInputImage extends StatefulWidget {
  final ValueChanged<XFile?> onChanged;
  final String url;
  final bool cameraOnly;

  const ZInputImage({
    super.key,
    required this.url,
    required this.onChanged,
    this.cameraOnly = false,
  });

  @override
  State<ZInputImage> createState() => _ZInputImageState();
}

class _ZInputImageState extends State<ZInputImage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future getImage(int i) async {
    final XFile? image;
    try {
      if (i == 1) {
        image = await _picker.pickImage(
            source: ImageSource.gallery, maxHeight: 1024, maxWidth: 1024);
      } else {
        image = await _picker.pickImage(
            source: ImageSource.camera, maxHeight: 1024, maxWidth: 1024);
      }
      setState(() {
        _image = image;
      });
      widget.onChanged(_image);
    } catch (e) {
      zprint(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            color: Colors.grey[100],
            height: 200,
            child: Center(
              child: _image == null
                  ? (widget.url.isEmpty)
                      ? const Center(
                          child: Icon(
                            Icons.image,
                            color: Colors.grey,
                            size: 100,
                          ),
                        )
                      : Image.network(
                          widget.url,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.image,
                            color: Colors.grey,
                            size: 100,
                          ),
                        )
                  : Image.file(
                      File(_image!.path),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Row(
            children: [
              if (!widget.cameraOnly) ...[
                Flexible(
                  child: ZButton(
                    text: 'Gallery',
                    buttonType: ButtonType.secondary,
                    onPressed: () => getImage(1),
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
              ],
              Flexible(
                child: ZButton(
                  text: 'Camera',
                  buttonType: ButtonType.secondary,
                  onPressed: () => getImage(0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
