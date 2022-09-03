// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flame/components.dart';

// Project imports:
import 'package:flame_test/components/grid/grid_coord.dart';

class GridNodeComponent extends RectangleComponent {
  GridCoord coords;
  bool buildable = true;

  GridNodeComponent({
    required this.coords,
    required double edgeSize,
  }) : super(
          size: Vector2(edgeSize, edgeSize),
          paint: Paint()
            ..style = PaintingStyle.stroke
            ..color = Colors.grey,
          position: Vector2(
            coords.x * edgeSize,
            coords.y * edgeSize,
          ),
        );
}
