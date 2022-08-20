import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/input.dart';
import 'package:flame_test/main.dart';
import 'package:flame_test/tower.dart';
import 'package:flutter/material.dart' hide Draggable;

class Healthbar extends PositionComponent {
  double health = 1.0;

  late RectangleComponent healthRect;

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

class Creep extends SpriteComponent
    with HasGameRef<SpaceShooterGame>, CollisionCallbacks, Draggable {
  static const int maxHealth = 1000;
  int health = maxHealth;
  late Healthbar healthbar;

  bool _targettable = true;

  bool get targettable => _targettable;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite("player-sprite.png");

    position = gameRef.size / 2;
    width = 50;
    height = 100;
    anchor = Anchor.center;

    healthbar = Healthbar()
      ..size = Vector2(40, 6)
      ..position = Vector2(width / 2, 0)
      ..anchor = Anchor.center;

    add(RectangleHitbox());
    add(healthbar);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  void move(Vector2 delta) {
    position.add(delta);
  }

  void getHit(int damage) {
    health -= damage;
    health.clamp(0, double.infinity);

    healthbar.health = health / maxHealth;

    if (health == 0) {
      debugPrint("I'm dead!");
      _targettable = false;
      add(RemoveEffect());
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Bullet) {
      debugPrint("Got hit by a bullet!");
      getHit(Bullet.damage);
    }
  }

  Vector2? dragDeltaPosition;
  bool get isDragging => dragDeltaPosition != null;

  @override
  bool onDragStart(DragStartInfo info) {
    dragDeltaPosition = info.eventPosition.game - position;
    return false;
  }

  @override
  bool onDragUpdate(DragUpdateInfo info) {
    if (isDragging) {
      final localCoords = info.eventPosition.game;
      position = localCoords - dragDeltaPosition!;
    }
    return false;
  }

  @override
  bool onDragEnd(DragEndInfo info) {
    dragDeltaPosition = null;
    return false;
  }

  @override
  bool onDragCancel() {
    dragDeltaPosition = null;
    return false;
  }
}
