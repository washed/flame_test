// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

// Project imports:
import 'package:flame_test/components/creep/creep.dart';
import 'package:flame_test/components/tower/tower.dart';
import 'package:flame_test/main.dart';

class TargetAcquisition extends PositionComponent
    with HasGameRef<SpaceShooterGame>, ParentIsA<Tower> {
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
      (angleErrorToClosestAcquiredTarget() != null)
          ? angleErrorToClosestAcquiredTarget()!.abs() < angleDeadzone
          : false;

  bool get closestAcquiredTargetHasFiringSolution =>
      closestAcquiredTargetInFiringRange && closestAcquiredTargetInFiringAngle;

  double? angleErrorToClosestAcquiredTarget() {
    if (closestAcquiredTarget != null) {
      final deltaPosition =
          closestAcquiredTarget!.absolutePosition - absolutePosition;

      final myVector = Vector2(
        sin(absoluteAngle),
        -cos(absoluteAngle),
      );

      return deltaPosition.angleToSigned(myVector);
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
