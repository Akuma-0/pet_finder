import 'package:flutter/material.dart';

import 'core/routing/app_router.dart';

class PetFinderApp extends StatelessWidget {
  final AppRouter appRouter;
  const PetFinderApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Finder',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRouter.generateRoute,
    );
  }
}
