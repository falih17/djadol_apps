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
  @override
  void initState() {
    super.initState();
    location();
  }

  Future<AsyncValue<Position>> location() async {
    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      Position position = await GeoLocation().getLocation();
      return AsyncValue.success(position);
    } catch (e) {
      if (e == 'mocked') {
        ZToast.error(context, 'Disable mock location');
      }
      return AsyncValue.failure("Error getting location");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ZPageFuture(
      // key: _refreshKey,
      future: location(),
      success: (v) {
        widget.onChanged(v);
        return Card(
          child: ListTile(
            title: const Text('Location'),
            subtitle: const Text('Current location'),
            trailing: const Icon(
              Icons.location_on,
              color: Colors.green,
              size: 30,
            ),
          ),
        );
      },
      loading: () => Card(
        child: ListTile(
          title: const Text('Location'),
          subtitle: const Text('Loading'),
          trailing: const CircularProgressIndicator(),
        ),
      ),
      failure: (error) => Card(
        child: ListTile(
          title: const Text('Location Failed'),
          subtitle: const Text('Tap to get location'),
          trailing: const Icon(
            Icons.location_off,
            color: Colors.grey,
            size: 30,
          ),
          onTap: () {
            location();
          },
        ),
      ),
    );
  }
}
