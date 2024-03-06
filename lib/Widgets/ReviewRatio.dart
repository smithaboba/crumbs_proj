import 'package:flutter/material.dart';

class ReviewRatioVisualizer extends StatelessWidget {
  final double positiveRatio;

  ReviewRatioVisualizer({required this.positiveRatio});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200, // Adjust the size as needed
      height: 200,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(
            color: Colors.grey,
            width: 20,
          )),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              value: positiveRatio,
              backgroundColor: Colors.red, // Color for negative reviews
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              strokeWidth: 40, // Color for positive reviews
            ),
          ],
        ),
      ),
    );
  }
}
