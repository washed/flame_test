import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_test/main.dart';
import 'package:flame/effects.dart';
import 'package:flame_test/move_extension.dart';
import 'package:flame_test/creep.dart';
import 'package:flutter/material.dart';
import 'package:flame/collisions.dart';

class Tower extends SpriteComponent with HasGameRef<SpaceShooterGame> {
  final PositionComponent target;
  final double fireRange;
  final double acquisitionRange;
  final bool renderRanges;

  final double turnRate = 1; // rad/s
  double rangeToTarget = double.infinity;
  double angleDeadzone = 0.025;
  double angleError = 0.0;

  Tower({
    required this.target,
    required this.fireRange,
    required this.acquisitionRange,
    this.renderRanges = false,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite("player-sprite.png");

    position = gameRef.size / 1.5;
    width = 25;
    height = 50;
    anchor = Anchor.center;

    if (renderRanges == true) {
      add(CircleComponent(
        radius: fireRange,
        anchor: Anchor.center,
        position: Vector2(width / 2, height / 2),
        paint: Paint()
          ..color = Colors.red
          ..style = PaintingStyle.stroke,
      ));

      add(CircleComponent(
        radius: acquisitionRange,
        anchor: Anchor.center,
        position: Vector2(width / 2, height / 2),
        paint: Paint()
          ..color = Colors.cyan
          ..style = PaintingStyle.stroke,
      ));
    }
  }

  void updateRange() {
    final targetVector = target.position - position;
    rangeToTarget = targetVector.length;
  }

  void updateAngle(double dt) {
    // TODO: we should probably refactor this into an effect or similar
    final allRotateEffectComponents = children.query<RotateEffect>();
    removeAll(allRotateEffectComponents);

    final targetVector = target.position - position;
    if (targetVector.length <= acquisitionRange) {
      angleError = targetVector.angleToSigned(Vector2(sin(angle), -cos(angle)));
      final angleDelta = turnRate * dt;

      if (angleError.abs() > angleDeadzone) {
        if (angleError > 0) {
          angle -= angleDelta;
        } else {
          angle += angleDelta;
        }
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    updateRange();
    updateAngle(dt);
    maybeShoot(dt);
  }

  double lastShotDt = 0.0;

  void maybeShoot(double dt) {
    if (lastShotDt > 0) {
      lastShotDt -= dt;
    } else if (rangeToTarget <= fireRange && angleError.abs() < angleDeadzone) {
      shootAt();
      lastShotDt = 1.0;
    }
  }

  void shootAt() {
    debugPrint("shootAt called");
    parent?.add(Bullet(
      target: target,
    )
      ..position = position
      ..angle = angle);
  }
}

class Bullet extends SpriteComponent
    with HasGameRef<SpaceShooterGame>, CollisionCallbacks {
  final PositionComponent target;
  final double velocity;
  static const int damage = 50;

  Bullet({
    required this.target,
    this.velocity = 50.0,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite("player-sprite.png");

    width = 10;
    height = 15;
    anchor = Anchor.center;

    final moveVector = target.position - position;

    final hitbox = RectangleHitbox();

    add(hitbox);

    final moveEffect = MoveInDirectionEffect(
      moveVector,
      EffectController(
        speed: velocity,
        infinite: true,
      ),
    );
    add(moveEffect);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is ScreenHitbox) {
      add(RemoveEffect());
    } else if (other is Creep) {
      debugPrint("Hit creep!");
      add(RemoveEffect());
    }
  }
}
