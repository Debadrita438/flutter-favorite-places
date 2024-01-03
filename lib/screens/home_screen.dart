import 'package:favorite_places/widgets/place_item.dart';
import 'package:flutter/material.dart';

import 'package:favorite_places/screens/add_place_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _onNavigation(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddPlaceScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            onPressed: () => _onNavigation(context),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: PlaceItem(),
      ),
    );
  }
}
