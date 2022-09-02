// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

// Project imports:
import 'package:flame_test/main.dart';
import 'package:flame_test/tower.dart';

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

class Creep extends SpriteComponent
    with HasGameRef<SpaceShooterGame>, CollisionCallbacks {
  static const int maxHealth = 1000;
  int health = maxHealth;
  late Healthbar healthbar;
  late Path path;
  late double startMovingDelay;

  bool _targettable = true;

  bool get targettable => _targettable;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite("player-sprite.png");

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

    if (startMovingDelay > 0.0) {
      startMovingDelay -= dt;
      if (startMovingDelay <= 0.0) {
        startMovingDelay = 0.0;
        final moveEffect = MoveAlongPathEffect(
          path,
          EffectController(speed: 100),
          absolute: false,
        );
        add(moveEffect);
      }
    }
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
}
