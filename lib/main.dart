import 'package:flutter/material.dart';
import 'package:pet_finder/core/routing/app_router.dart';
import 'package:pet_finder/pet_finder_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(PetFinderApp(appRouter: AppRouter()));
}