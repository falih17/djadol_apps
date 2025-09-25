import 'package:djadol_mobile/core/widgets/zui.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../pages/async_value.dart';
import 'geo_location.dart';

class GeoWidget extends StatefulWidget {
  final Function(Position) onChanged;

  const GeoWidget({
    super.key,
    required this.onChanged,
  });

  @override
  State<GeoWidget> createState() => _GeoWidgetState();
}

class _GeoWidgetState extends State<GeoWidget> {
  bool isLoading =true;
  Position? position;

  @override
  void initState() {
    super.initState();
    location();
  }

  Future location() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      position = await GeoLocation().getLocation();
      widget.onChanged(position!);
      // return AsyncValue.success(position);
    } catch (e) {
      if (e == 'mocked') {
        ZToast.error(context, 'Disable mock location');
      }
      // return AsyncValue.failure("Error getting location");
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (isLoading) ?Card(
        child: ListTile(
          title: const Text('Location'),
          subtitle: const Text('Loading'),
          trailing: const CircularProgressIndicator(),
        ),
      ) :Card(
          child: (position != null ) ? ListTile(
            title: const Text('GPS'),
            subtitle: const Text('Lokasi berhasil'),
            trailing: const Icon(
              Icons.location_on,
              color: Colors.green,
              size: 30,
            ),
          ):GestureDetector(
            onTap: location,
            child: ListTile(
              title: const Text('Lokasi tidak ditemukan'),
              subtitle: const Text('Tap untuk coba lagi'),
              trailing: const Icon(
                Icons.location_off,
                color: Colors.red,
                size: 30,
              ),
            ),
          ),
        );
  }
}
