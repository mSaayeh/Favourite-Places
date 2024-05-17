import 'package:favourite_places/models/place.dart';
import 'package:favourite_places/providers/places_provider.dart';
import 'package:favourite_places/screens/add_place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaceDetailsScreen extends ConsumerStatefulWidget {
  const PlaceDetailsScreen(this.place, {super.key});

  final Place place;

  @override
  ConsumerState<PlaceDetailsScreen> createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends ConsumerState<PlaceDetailsScreen> {
  late Place _place;

  @override
  void initState() {
    super.initState();
    _place = widget.place;
  }

  void _editPlace() async {
    Place place = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => AddPlaceScreen(
          place: _place,
        ),
      ),
    );
    setState(() {
      _place = place;
    });
  }

  void _deletePlace() {
    ref.read(favouritePlacesProvider.notifier).deletePlace(_place);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Place deleted Successfully.'),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_place.title),
        actions: [
          IconButton(
            onPressed: _editPlace,
            icon: const Icon(
              Icons.edit,
              semanticLabel: 'Edit',
            ),
          ),
          IconButton(
            onPressed: _deletePlace,
            icon: const Icon(
              Icons.delete,
              semanticLabel: 'Delete',
            ),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Image.file(
            _place.image,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Card(
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _place.title,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "lat: ${_place.coordinates.latitude.toString()}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(width: 32),
                      Text(
                        "long: ${_place.coordinates.longitude.toString()}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
