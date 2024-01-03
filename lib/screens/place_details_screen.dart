import 'package:flutter/material.dart';

import 'package:favorite_places/models/place.dart';

class PlaceDetailsScreen extends StatelessWidget {
  const PlaceDetailsScreen({
    super.key,
    required this.selectedPlace,
  });

  final Place selectedPlace;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedPlace.name),
      ),
      body: Stack(
        children: [
          Image.file(
            selectedPlace.image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ],
      ),
    );
  }
}
