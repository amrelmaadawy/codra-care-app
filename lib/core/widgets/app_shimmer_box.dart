import 'package:flutter/material.dart';
import '../theme/app_radius.dart';

class AppShimmerBox extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final ShapeBorder? shape;

  const AppShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.shape,
  });

  const AppShimmerBox.circle({
    super.key,
    required double size,
  })  : width = size,
        height = size,
        borderRadius = null,
        shape = const CircleBorder();

  @override
  Widget build(BuildContext context) {
    if (shape != null) {
      return Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: shape!,
        ),
      );
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius ?? AppRadius.cardRadius,
      ),
    );
  }
}
