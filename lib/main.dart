import 'package:flutter/material.dart';
import 'package:map/core/helper_functions/on_generate_routes.dart';
import 'package:map/features/home/presentation/views/home_view.dart';

void main() {
  runApp(const MapApp());
}

class MapApp extends StatelessWidget {
  const MapApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      onGenerateRoute: onGenerateRoute,
      initialRoute: HomeView.routeName,
      debugShowCheckedModeBanner: false,
    );
  }
}
