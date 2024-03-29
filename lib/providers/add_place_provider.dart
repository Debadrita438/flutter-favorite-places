import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

import 'package:favorite_places/models/place.dart';

Future<Database> _getDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(
      path.join(dbPath, 'places.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
      },
      version: 1,
    );
    return db;
  }

class AddPlaceNotifier extends StateNotifier<List<Place>> {
  AddPlaceNotifier() : super(const []);

  Future<void> fetchPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');

    final placeList = data
        .map(
          (row) => Place(
            id: row['id'] as String,
            name: row['title'] as String,
            image: File(row['image'] as String),
            location: PlaceLocation(
              address: row['address'] as String,
              latitude: row['lat'] as double,
              longitude: row['lng'] as double,
            ),
          ),
        )
        .toList();

    state = placeList;
  }

  void addNewPlace(String placeName, File image, PlaceLocation location) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$fileName');

    final newPlace = Place(
      name: placeName,
      image: copiedImage,
      location: location,
    );

    final db = await _getDatabase();
    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.name,
      'image': newPlace.image.path,
      'lat': location.latitude,
      'lng': location.longitude,
      'address': location.address
    });

    state = [newPlace, ...state];
  }
}

final addPlaceProvider = StateNotifierProvider<AddPlaceNotifier, List<Place>>(
  (ref) => AddPlaceNotifier(),
);
