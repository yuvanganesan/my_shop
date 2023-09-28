import 'package:flutter/material.dart';

class Shimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10),
      itemBuilder: (cxt, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: GridTile(
              child: Container(
            color: Colors.black.withOpacity(0.06),
          )),
        );
      },
      itemCount: 10,
    );
  }
}
