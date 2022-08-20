import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_test/main.dart';
import 'package:flame/effects.dart';
import 'package:flame_test/move_extension.dart';
import 'package:flame_test/creep.dart';
import 'package:flutter/material.dart';
import 'package:flame/collisions.dart';

class TargetAcquisition extends PositionComponent
    with HasGameRef<SpaceShooterGame> {
  final double acquisitionRange;
  final double firingRange;
  final double angleDeadzone;

  late CircleComponent acquisitionRangeCircle;
  late CircleComponent firingRangeCircle;

  List<Creep> orderedAcquiredTargets = [];
  bool _renderRanges = false;

  TargetAcquisition({
    required this.acquisitionRange,
    required this.firingRange,
    required this.angleDeadzone,
  }) : assert(acquisitionRange >= firingRange);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    anchor = Anchor.center;

    acquisitionRangeCircle = CircleComponent(
      radius: acquisitionRange,
      anchor: Anchor.center,
      paint: Paint()
        ..color = Colors.cyan
        ..style = PaintingStyle.stroke,
    );

    firingRangeCircle = CircleComponent(
      radius: firingRange,
      anchor: Anchor.center,
      paint: Paint()
        ..color = Colors.red
        ..style = PaintingStyle.stroke,
    );

    renderRanges = true;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // The toList() call also effectively creates a copy of the object
    // so we don't modify the component cache later on and screw up our game state.
    final acquiredTargets = gameRef.children.query<Creep>().toList();

    acquiredTargets.retainWhere((element) =>
        (element.absolutePosition - absolutePosition).length <=
        acquisitionRange);

    acquiredTargets.sort((a, b) => (a.absolutePosition - absolutePosition)
        .length
        .compareTo((b.absolutePosition - absolutePosition).length));

    orderedAcquiredTargets = acquiredTargets;
  }

  PositionComponent? get closestAcquiredTarget =>
      orderedAcquiredTargets.isNotEmpty ? orderedAcquiredTargets.first : null;

  bool get closestAcquiredTargetInFiringRange => (closestAcquiredTarget != null)
      ? (closestAcquiredTarget!.absolutePosition - absolutePosition).length <
          firingRange
      : false;

  bool get closestAcquiredTargetInFiringAngle =>
      (angleErrorToClosestAcquiredTarget != null)
          ? angleErrorToClosestAcquiredTarget!.abs() < angleDeadzone
          : false;

  bool get closestAcquiredTargetHasFiringSolution =>
      closestAcquiredTargetInFiringRange && closestAcquiredTargetInFiringAngle;

  double? get angleErrorToClosestAcquiredTarget {
    if (closestAcquiredTarget != null) {
      return (closestAcquiredTarget!.absolutePosition - absolutePosition)
              .angleToSigned(Vector2(
            cos(absoluteAngle),
            sin(absoluteAngle),
          )) -
          pi / 2;
    }
    return null;
  }

  bool get renderRanges => _renderRanges;

  set renderRanges(bool renderRanges) {
    if (!renderRanges) {
      if (acquisitionRangeCircle.isMounted) {
        acquisitionRangeCircle.add(RemoveEffect());
      }
      if (acquisitionRangeCircle.isMounted) {
        firingRangeCircle.add(RemoveEffect());
      }
    } else {
      if (!acquisitionRangeCircle.isMounted) {
        add(acquisitionRangeCircle);
      }
      if (!acquisitionRangeCircle.isMounted) {
        add(firingRangeCircle);
      }
    }

    _renderRanges = renderRanges;
  }
}

class Tower extends SpriteComponent with HasGameRef<SpaceShooterGame> {
  final double firingRange;
  final double acquisitionRange;

  final double turnRate = 1; // rad/s

  PositionComponent? target;

  late TargetAcquisition targetAcquisition;

  Tower({
    required this.firingRange,
    required this.acquisitionRange,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    debugMode = true;

    sprite = await gameRef.loadSprite("player-sprite.png");

    position = Vector2(1000, 1000);
    anchor = Anchor.center;
    width = 25;
    height = 50;

    targetAcquisition = TargetAcquisition(
      acquisitionRange: acquisitionRange,
      firingRange: firingRange,
      angleDeadzone: 0.025,
    )
      ..anchor = Anchor.center
      ..position = Vector2(width / 2, height / 2);
    add(targetAcquisition);
  }

  void turnToTarget(double dt) {
    // TODO: we should probably refactor this into an effect or similar

    final angleError = targetAcquisition.angleErrorToClosestAcquiredTarget;
    final solution = targetAcquisition.closestAcquiredTargetInFiringAngle;

    if (angleError != null) {
      final angleDelta = turnRate * dt;

      if (!solution) {
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

    turnToTarget(dt);
    maybeShoot(dt);

    target = targetAcquisition.closestAcquiredTarget;
  }

  double lastShotDt = 0.0;

  void maybeShoot(double dt) {
    if (lastShotDt > 0) {
      lastShotDt -= dt;
    } else if (targetAcquisition.closestAcquiredTargetHasFiringSolution) {
      parent?.add(Bullet(
        target: target!,
      )
        ..position = position
        ..angle = angle);
      lastShotDt = 1.0;
    }
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
