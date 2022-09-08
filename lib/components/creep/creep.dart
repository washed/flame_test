// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

// Project imports:
import 'package:flame_test/components/base.dart';
import 'package:flame_test/components/statusbar/health_bar.dart';
import 'package:flame_test/components/tower/bullet.dart';
import 'package:flame_test/main.dart';

class Creep extends PositionComponent
    with HasGameRef<SpaceShooterGame>, CollisionCallbacks {
  final int maxHealth;
  final double moveSpeed;
  final int baseDamage;

  late SpriteComponent creepSprite;
  late RectangleHitbox hitbox;

  late Path path;
  late double startMovingDelay;

  late int _health;
  late Healthbar _healthbar;

  bool _targettable = true;

  bool get targettable => _targettable;

  Creep({
    required this.maxHealth,
    required this.moveSpeed,
    required this.baseDamage,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    width = 30;
    height = 30;
    anchor = Anchor.center;
    _health = maxHealth;

    creepSprite = SpriteComponent()
      ..sprite = await gameRef.loadSprite("player-sprite.png")
      ..width = 10
      ..height = 20
      ..anchor = Anchor.center
      ..position = Vector2(width / 2, height / 2)
      ..angle = pi / 2;

    add(creepSprite);

    hitbox = RectangleHitbox()
      ..width = 10
      ..height = 20
      ..anchor = Anchor.center
      ..position = Vector2(width / 2, height / 2)
      ..angle = pi / 2;

    add(hitbox);

    _healthbar = Healthbar()
      ..size = Vector2(30, 3)
      ..position = Vector2(width / 2, 5)
      ..anchor = Anchor.center;

    add(RectangleHitbox());
    add(_healthbar);
  }

  bool get dead => _health <= 0;

  @override
  double get angle => creepSprite.angle;

  @override
  set angle(double value) {
    creepSprite.angle = value;
    hitbox.angle = value;
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
          oriented: true,
        );
        add(moveEffect);
      }
    }
  }

  void getHit(int damage) {
    _health -= damage;
    _health = _health.clamp(0, double.infinity).toInt();

    _healthbar.value = _health / maxHealth;

    if (_health == 0) {
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
