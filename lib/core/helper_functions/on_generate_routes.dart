import 'package:flutter/material.dart';
import 'package:map/features/home/presentation/views/map_view.dart';

import '../../features/home/presentation/views/home_view.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomeView.routeName:
      return MaterialPageRoute(builder: (_) => const HomeView());
    case MapView.routeName:
      return MaterialPageRoute(builder: (_) => const MapView());

    default:
      return MaterialPageRoute(
        builder: (_) =>
            const Scaffold(body: Center(child: Text('404 Not Found'))),
      );
  }
}
