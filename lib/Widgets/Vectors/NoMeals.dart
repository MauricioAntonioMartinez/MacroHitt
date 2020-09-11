import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoMeals extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.asset(
        'assets/vectors/404.svg',
        width: 300,
      ),
    );
  }
}
