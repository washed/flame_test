// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flame/components.dart';

class StatusBar extends PositionComponent {
  double _value = 1.0;
  final Color statusBarColor;

  late RectangleComponent statusRect;

  StatusBar({required this.statusBarColor});

  @override
  Future<void> onLoad() async {
    final frameRect = RectangleComponent(
      size: size,
      paint: Paint()
        ..color = Colors.white70
        ..style = PaintingStyle.stroke,
      anchor: Anchor.centerLeft,
    );

    statusRect = RectangleComponent(
      size: Vector2(size.x - 2, size.y - 2),
      position: Vector2(1, 1),
      paint: Paint()
        ..color = statusBarColor
        ..style = PaintingStyle.fill,
      anchor: Anchor.centerLeft,
    );

    add(frameRect);
    add(statusRect);
  }

  set value(double value) {
    _value = value.clamp(0.0, 1.0);
  }

  double get value => _value;

  @override
  void update(double dt) {
    super.update(dt);

    statusRect.scale = Vector2(value, 1.0);
  }
}
