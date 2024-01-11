import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddLocationNotifer extends StateNotifier<LatLng> {
  AddLocationNotifer() : super(const LatLng(0.0, 0.0));

  void addNewLocation(LatLng location) {
    state = location;
  }
}

final addLocationProvider = StateNotifierProvider<AddLocationNotifer, LatLng>(
  (ref) => AddLocationNotifer(),
);
