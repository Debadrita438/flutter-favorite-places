import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;

import 'package:favorite_places/models/place.dart';

class AddPlaceNotifier extends StateNotifier<List<Place>> {
  AddPlaceNotifier() : super(const []);

  void addNewPlace(Place newPlace) {
    state = [newPlace, ...state];
  }
}

final addPlaceProvider = StateNotifierProvider<AddPlaceNotifier, List<Place>>(
  (ref) => AddPlaceNotifier(),
);
