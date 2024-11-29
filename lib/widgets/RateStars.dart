import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RateStars extends StatefulWidget {
  const RateStars({
    super.key,
  });

  @override
  State<RateStars> createState() => _RateStarsState();
}

class _RateStarsState extends State<RateStars> {

  double currentRating = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: currentRating,
      direction: Axis.horizontal,
      itemSize: 46,
      itemPadding: EdgeInsets.symmetric(horizontal: 3.0),
      unratedColor: Colors.grey,
      itemCount: 5,
      minRating: 1,
      maxRating: 5,
      itemBuilder: (context, index) {
        if (currentRating >= index + 1) {
          return Icon(
            Icons.star_rounded,
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
        setState(() {
          currentRating = rating;
          print(rating);
        });
      },
    );
  }
}
