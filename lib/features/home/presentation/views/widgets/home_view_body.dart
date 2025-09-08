import 'package:flutter/material.dart';
import 'package:map/core/widgets/custom_buttom.dart';
import 'package:map/features/home/presentation/views/map_view.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomButtom(
            text: '>> Map View',
            onPressed: () {
              Navigator.pushNamed(context, MapView.routeName);
            },
          ),
        ],
      ),
    );
  }
}
