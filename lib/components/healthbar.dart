// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flame/components.dart';

class Healthbar extends PositionComponent {
  double health = 1.0;

  late RectangleComponent healthRect;

  // TODO: make this not affected by turning the parent or similar

  @override
  Future<void> onLoad() async {
    final frameRect = RectangleComponent(
      size: size,
      paint: Paint()
        ..color = Colors.white70
        ..style = PaintingStyle.stroke,
      anchor: Anchor.centerLeft,
    );

    healthRect = RectangleComponent(
      size: Vector2(size.x - 2, size.y - 2),
      position: Vector2(1, 1),
      paint: Paint()
        ..color = Colors.green
        ..style = PaintingStyle.fill,
      anchor: Anchor.centerLeft,
    );

    add(frameRect);
    add(healthRect);
  }

  @override
  void update(double dt) {
    super.update(dt);

    healthRect.scale = Vector2(health, 1.0);
  }
}
