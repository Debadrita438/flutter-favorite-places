import 'package:flutter/material.dart';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/place_details_screen.dart';

class PlaceItem extends StatelessWidget {
  const PlaceItem({super.key, required this.placeList});

  final List<Place> placeList;

  void _onNavigationPlace(Place selectedPlace, BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlaceDetailsScreen(selectedPlace: selectedPlace),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (placeList.isEmpty) {
      return Center(
        child: Text(
          'No Places found.',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
      );
    }

    return ListView.builder(
      itemCount: placeList.length,
      itemBuilder: (context, index) => ListTile(
        leading: CircleAvatar(
          backgroundImage: FileImage(placeList[index].image),
        ),
        title: Text(
          placeList[index].name,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
        subtitle: Text(
          placeList[index].location.address,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
        onTap: () => _onNavigationPlace(placeList[index], context),
      ),
    );
  }
}
