// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flame/components.dart';
import 'package:flame/input.dart';

class TextButtonComponent extends ButtonComponent {
  static PositionComponent getButtonComponent({
    required String text,
    required Vector2 size,
  }) {
    final TextComponent buttonText = TextComponent(
      text: text,
      position: size / 2,
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(color: Colors.blue),
      ),
    );
    final RectangleComponent buttonComponent = RectangleComponent(
        size: size,
        paint: Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.blue,
        children: [buttonText]);

    return buttonComponent;
  }

  static PositionComponent getButtonDownComponent({
    required String text,
    required Vector2 size,
  }) {
    final TextComponent buttonDownText = TextComponent(
      text: text,
      position: size / 2,
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(color: Colors.white),
      ),
    );
    final RectangleComponent buttonDownComponent = RectangleComponent(
        size: size,
        paint: Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.blue,
        children: [buttonDownText]);

    return buttonDownComponent;
  }

  TextButtonComponent({
    required String text,
    double width = 80,
    double height = 30,
  }) : super(
          button: getButtonComponent(
            size: Vector2(width, height),
            text: text,
          ),
          buttonDown: getButtonDownComponent(
            size: Vector2(width, height),
            text: text,
          ),
        ) {
    anchor = Anchor.topLeft;
  }
}
