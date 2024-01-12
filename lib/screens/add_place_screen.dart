import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/add_place_provider.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/location_input.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() {
    return _AddPlaceScreenState();
  }
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredPlaceName = '';
  File? _selectedImage;
  PlaceLocation? _selectedLocation;

  void pickeImageHandler(File image) {
    _selectedImage = image;
  }

  void selectLocationHandler(PlaceLocation location) {
    _selectedLocation = location;
  }

  String? _titleValidator(String? text) {
    if (text == null || text.isEmpty) {
      return 'Please enter the name of the place';
    }
    return null;
  }

  void _saveTitleHandler(String? title) {
    _enteredPlaceName = title!;
  }

  void _onSubmitForm() {
    if (_selectedImage == null || _selectedLocation == null) {
      return;
    } else {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        ref.read(addPlaceProvider.notifier).addNewPlace(
              _enteredPlaceName,
              _selectedImage!,
              _selectedLocation!,
            );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new place'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Title'),
                ),
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground),
                validator: _titleValidator,
                onSaved: _saveTitleHandler,
              ),
              const SizedBox(height: 12),
              ImageInput(onPickImage: pickeImageHandler),
              const SizedBox(height: 12),
              LocationInput(onSelectLocation: selectLocationHandler),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                onPressed: _onSubmitForm,
                label: const Text('Add Place'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
