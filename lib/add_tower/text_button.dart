import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class TextButtonComponent extends ButtonComponent
    with HasGameRef, ComponentViewportMargin {
  TextButtonComponent({required text}) {
    final Vector2 size = Vector2(120, 40);

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

    button = buttonComponent;
    buttonDown = buttonDownComponent;
    anchor = Anchor.topLeft;
  }
}
