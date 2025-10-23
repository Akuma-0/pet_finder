import 'package:flutter/material.dart';
import '../../data/models/breeds_response_model.dart';
import 'breed_tile.dart';

class BreedsListView extends StatelessWidget {
  const BreedsListView({super.key, required this.breeds});
  final List<Breed> breeds;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: breeds.length,
      itemBuilder: (context, index) => BreedTile(breed: breeds[index]),
    );
  }
}
