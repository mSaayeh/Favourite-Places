import 'dart:io';

import 'package:favourite_places/models/coordinates.dart';
import 'package:favourite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

const tableName = "user_places";

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute('CREATE TABLE user_places(id TEXT PRIMARY KEY, '
          'title TEXT, image TEXT, latitude REAL, longitude REAL, created_at INT)');
    },
    version: 1,
  );
  return db;
}

class FavouritePlacesNotifier extends StateNotifier<List<Place>> {
  FavouritePlacesNotifier() : super([]);

  void addFavouritePlace(
      String title, File image, Coordinates coordinates) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final copiedImage = await image.copy("${appDir.path}/$fileName");

    final place =
        Place(title: title, image: copiedImage, coordinates: coordinates);
    final db = await _getDatabase();
    db.insert(
      tableName,
      place.asMap,
    );

    state = [place, ...state];
  }

  void deletePlace(Place place) async {
    final db = await _getDatabase();
    db.delete(tableName, where: "id = ?", whereArgs: [place.id]);

    place.image.delete();

    state = state.where((element) => element.id != place.id).toList();
  }

  void editPlace({required Place place}) async {
    final db = await _getDatabase();

    db.update(tableName, place.asMap, where: "id = ?", whereArgs: [place.id]);

    final appDir = await syspaths.getApplicationDocumentsDirectory();

    state = await Future.wait(state.map(
      (element) async {
        if (element.id == place.id) {
          if (element.image.path != place.image.path) {
            element.image.delete();
            final fileName = path.basename(place.image.path);
            final copiedImage =
                await place.image.copy("${appDir.path}/$fileName");
            place.image = copiedImage;
          }
          return place;
        } else {
          return element;
        }
      },
    ).toList());
  }

  Future<void> getAllPlaces() async {
    final db = await _getDatabase();
    final data = await db.query(tableName, orderBy: 'created_at desc');
    final places = data
        .map(
          (row) => Place(
            id: row['id'] as String,
            title: row['title'] as String,
            image: File(row['image'] as String),
            coordinates: Coordinates(
              longitude: (row['longitude'] as double),
              latitude: (row['latitude'] as double),
            ),
            createdAt: row['created_at'] as int,
          ),
        )
        .toList();
    state = places;
  }
}

final favouritePlacesProvider =
    StateNotifierProvider<FavouritePlacesNotifier, List<Place>>(
        (ref) => FavouritePlacesNotifier());
