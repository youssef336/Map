import 'package:flutter/material.dart';
import 'package:map/features/home/presentation/views/widgets/map_view_body.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});
  static const routeName = '/map';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: MapViewBody());
  }
}
