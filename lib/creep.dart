// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

// Project imports:
import 'package:flame_test/base.dart';
import 'package:flame_test/healthbar.dart';
import 'package:flame_test/main.dart';
import 'package:flame_test/tower.dart';

class Creep extends SpriteComponent
    with HasGameRef<SpaceShooterGame>, CollisionCallbacks {
  static const int maxHealth = 1000;
  static const double moveSpeed = 250;

  final int baseDamage = 100;
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

    width = 25;
    height = 50;
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

    if (isMounted && startMovingDelay > 0.0) {
      startMovingDelay -= dt;
      if (startMovingDelay <= 0.0) {
        startMovingDelay = 0.0;
        final moveEffect = MoveAlongPathEffect(
          path,
          EffectController(speed: moveSpeed),
          absolute: false,
        );
        add(moveEffect);
      }
    }
  }

  void getHit(int damage) {
    health -= damage;
    health = health.clamp(0, double.infinity).toInt();

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

    if (other is Base) {
      debugPrint("I hit the base");
      add(RemoveEffect());
    }
  }
}
