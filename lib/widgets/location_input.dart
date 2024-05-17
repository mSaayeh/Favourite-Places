import 'package:favourite_places/models/coordinates.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  const LocationInput(
      {super.key, required this.onPlacePicked, this.initialCoordinates});

  final void Function(Coordinates coordinates) onPlacePicked;
  final Coordinates? initialCoordinates;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  Coordinates? _pickedCoordinates;
  bool _isGettingLocation = false;

  @override
  void initState() {
    super.initState();
    _pickedCoordinates = widget.initialCoordinates;
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();

    setState(() {
      _isGettingLocation = false;
      _pickedCoordinates = Coordinates(
          longitude: locationData.longitude!, latitude: locationData.latitude!);
    });

    widget.onPlacePicked(_pickedCoordinates!);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      _pickedCoordinates == null
          ? 'No location chosen'
          : 'latitude: ${_pickedCoordinates!.latitude}\n'
              'longitude: ${_pickedCoordinates!.longitude}',
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
      textAlign: TextAlign.center,
    );

    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Get Current Location'),
            ),
            TextButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No Google Maps API'),
                  ),
                );
              },
              icon: const Icon(Icons.map),
              label: const Text('Choose on map'),
            ),
          ],
        )
      ],
    );
  }
}
