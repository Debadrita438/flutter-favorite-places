import 'dart:convert';

import 'package:favorite_places/providers/add_location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import 'package:favorite_places/screens/map_screen.dart';
import 'package:favorite_places/models/place.dart';

class LocationInput extends ConsumerStatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  ConsumerState<LocationInput> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends ConsumerState<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  String get locationImage {
    if (_pickedLocation == null) {
      return '';
    }
    final lat = _pickedLocation!.latitude;
    final lng = _pickedLocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=AIzaSyCVIr-Br_F7nKT1LhD0JvBeKmZ1e8x4Rbw';
  }

  void _savePlace(double latitude, double longitude) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=AIzaSyCVIr-Br_F7nKT1LhD0JvBeKmZ1e8x4Rbw');
    final response = await http.get(url);
    final mapResponse = json.decode(response.body);
    final addressObj = mapResponse['results'][0];
    final address = addressObj['formatted_address'];

    setState(() {
      _pickedLocation = PlaceLocation(
        latitude: latitude,
        longitude: longitude,
        address: address,
      );
      _isGettingLocation = false;
    });
    widget.onSelectLocation(_pickedLocation!);
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() => _isGettingLocation = true);
    locationData = await location.getLocation();

    final lat = locationData.latitude;
    final lang = locationData.longitude;

    if (lat == null || lang == null) {
      return;
    }
    _savePlace(lat, lang);
  }

  void _selectOnMap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const MapScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedMapLocation = ref.watch(addLocationProvider);

    if(selectedMapLocation.latitude != 0.0 && selectedMapLocation.longitude != 0.0) {
      _savePlace(selectedMapLocation.latitude, selectedMapLocation.longitude);
    }

    Widget displayContent = Text(
      'No Location Chosen!',
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.onBackground),
    );

    if (_isGettingLocation) {
      displayContent = const CircularProgressIndicator();
    }

    if (_pickedLocation != null) {
      displayContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: displayContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Get Current Location'),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
            ),
          ],
        )
      ],
    );
  }
}
