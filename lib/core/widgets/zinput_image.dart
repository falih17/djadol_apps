import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'zbutton.dart';

class ZInputImage extends StatefulWidget {
  final ValueChanged<XFile?> onChanged;
  final String url;

  const ZInputImage({
    super.key,
    required this.url,
    required this.onChanged,
  });

  @override
  State<ZInputImage> createState() => _ZInputImageState();
}

class _ZInputImageState extends State<ZInputImage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future getImage(int i) async {
    final XFile? image;

    if (i == 1) {
      image = await _picker.pickImage(
          source: ImageSource.gallery, maxHeight: 1200, maxWidth: 1200);
    } else {
      image = await _picker.pickImage(
          source: ImageSource.camera, maxHeight: 1200, maxWidth: 1200);
    }
    setState(() {
      _image = image;
    });
    widget.onChanged(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Center(
            child: _image == null
                ? (widget.url.isEmpty)
                    ? const Center(
                        child: Icon(
                          Icons.image,
                          color: Colors.grey,
                          size: 100,
                        ),
                      )
                    : Image.network(widget.url)
                : Image.file(
                    File(_image!.path),
                    fit: BoxFit.fill,
                  ),
          ),
          Row(
            children: [
              Flexible(
                child: ZButton(
                  text: 'Gallery',
                  onPressed: () => getImage(1),
                ),
              ),
              const SizedBox(
                width: 40,
              ),
              Flexible(
                child: ZButton(
                  text: 'Camera',
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
