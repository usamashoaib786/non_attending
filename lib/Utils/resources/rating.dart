import 'package:flutter/material.dart';
import 'package:non_attending/Utils/resources/app_theme.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final int starCount;
  final double size;
  final Color color;

  const StarRating({
    super.key,
    required this.rating,
    this.starCount = 5,
    this.size = 30,
    this.color = const Color(0xffF6C044),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(starCount, (index) {
        if (index < rating.floor()) {
          // Filled star
          return Icon(
            Icons.star,
            color: color,
            size: size,
          );
        } else if (index == rating.floor() && rating % 1 != 0) {
          // Partially filled star
          return Icon(
            Icons.star_half,
            color: color,
            size: size,
          );
        } else {
          // Empty star
          return Icon(
            Icons.star_border,
            color: color,
            size: size,
          );
        }
      }),
    );
  }
}
