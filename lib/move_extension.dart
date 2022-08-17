import 'package:flame/src/effects/controllers/effect_controller.dart';
import 'package:flame/src/effects/move_effect.dart';
import 'package:flame/src/effects/provider_interfaces.dart';
import 'package:vector_math/vector_math_64.dart';

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
