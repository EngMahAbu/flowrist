import 'package:flowrist/core/constants/app_dimensions.dart';
import 'package:flowrist/gallery_view.dart';
import 'package:flutter/material.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsetsGeometry.directional(
            start: AppDimensions.defaultScreenPadding,
          ),
          child: IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_back_ios_new),
          ),
        ),
        title: Text('Gallery Screen'),
      ),
      body: GalleryView(),
    );
  }
}
