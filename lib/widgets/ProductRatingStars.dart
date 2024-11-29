import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductRatingStars extends StatelessWidget {
  final double rating;
  final double size;

  const ProductRatingStars({
    super.key,
    required this.rating,
    required this.size
  });

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: rating,
      direction: Axis.horizontal,
      itemSize: size,
      unratedColor: Colors.grey,
      itemCount: 5,
      itemBuilder: (context, index) {
        if (rating >= index + 1) {
          return Icon(
            Icons.star_rounded,
            color: Colors.amber,
          );
        } else if (rating + 0.5 >= index + 1) {
          return Icon(
            Icons.star_half_rounded,
            color: Colors.amber,
          );
        } else {
          return Icon(
            Icons.star_border_rounded,
            color: Colors.grey,
          );
        }
      },
      onRatingUpdate: (rating) {
        print(rating);
      },
      ignoreGestures: true, // Disable interaction if you just want to display the rating
    );
  }
}
