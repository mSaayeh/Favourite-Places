import 'dart:io';

import 'package:favourite_places/models/coordinates.dart';
import 'package:favourite_places/models/place.dart';
import 'package:favourite_places/providers/places_provider.dart';
import 'package:favourite_places/widgets/image_input.dart';
import 'package:favourite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key, this.place});

  final Place? place;

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceState();
}

class _AddPlaceState extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? _selectedImage;
  Coordinates? _pickedCoordinates;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.place?.title ?? "";
    _selectedImage = widget.place?.image;
    _pickedCoordinates = widget.place?.coordinates;
  }

  void _savePlace() {
    final enteredText = _titleController.text;

    if (enteredText.isEmpty ||
        _selectedImage == null ||
        _pickedCoordinates == null) {
      return;
    }

    if (widget.place == null) {
      ref.read(favouritePlacesProvider.notifier).addFavouritePlace(
            enteredText,
            _selectedImage!,
            _pickedCoordinates!,
          );
      Navigator.pop(context);
    } else {
      final place = Place(
        id: widget.place!.id,
        title: enteredText,
        image: _selectedImage!,
        coordinates: _pickedCoordinates!,
        createdAt: widget.place!.createdAt,
      );
      ref.read(favouritePlacesProvider.notifier).editPlace(place: place);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Place Edited Successfully'),
        ),
      );
      Navigator.pop(context, place);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.place == null ? 'Add new Place' : 'Edit Place'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Title",
                hintStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              controller: _titleController,
            ),
            const SizedBox(height: 10),
            ImageInput(
              onPickImage: (image) {
                _selectedImage = image;
              },
              initialImage: _selectedImage,
            ),
            const SizedBox(height: 10),
            LocationInput(
              onPlacePicked: (coordinates) {
                _pickedCoordinates = coordinates;
              },
              initialCoordinates: _pickedCoordinates,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _savePlace,
              icon: Icon(widget.place == null ? Icons.add : Icons.edit),
              label: Text(widget.place == null ? "Add Place" : "Edit Place"),
            ),
          ],
        ),
      ),
    );
  }
}
