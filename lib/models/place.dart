import 'dart:io';

import 'package:favourite_places/models/coordinates.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Place {
  Place({
    required this.title,
    required this.image,
    required this.coordinates,
    int? createdAt,
    String? id,
  })  : id = id ?? uuid.v4(),
        createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch;

  final String id;
  final String title;
  File image;
  final int createdAt;
  final Coordinates coordinates;

  get asMap => {
        'id': id,
        'title': title,
        'image': image.path,
        'latitude': coordinates.latitude,
        'longitude': coordinates.longitude,
        'created_at': createdAt,
      };
}
