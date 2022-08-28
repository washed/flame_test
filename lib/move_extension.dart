// Package imports:
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

class MoveInDirectionEffect extends MoveEffect {
  MoveInDirectionEffect(
    Vector2 direction,
    EffectController controller, {
    PositionProvider? target,
    void Function()? onComplete,
  })  : _direction = direction.clone(),
        super(controller, target, onComplete: onComplete);

  final Vector2 _direction;

  @override
  void apply(double progress) {
    target.position += _direction * progress;
  }

  @override
  double measure() => _direction.length;
}
