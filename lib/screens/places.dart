import 'package:favourite_places/providers/places_provider.dart';
import 'package:favourite_places/screens/add_place.dart';
import 'package:favourite_places/screens/place_details.dart';
import 'package:favourite_places/widgets/places_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlacesState();
}

class _PlacesState extends ConsumerState<PlacesScreen> {
  late Future<void> _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(favouritePlacesProvider.notifier).getAllPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final favouritePlaces = ref.watch(favouritePlacesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => const AddPlaceScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.add,
              semanticLabel: "Add",
            ),
            tooltip: "Add Place",
          )
        ],
      ),
      body: FutureBuilder(
        future: _placesFuture,
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : PlacesList(
                    places: favouritePlaces,
                    onPlaceClicked: (place) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => PlaceDetailsScreen(place),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
