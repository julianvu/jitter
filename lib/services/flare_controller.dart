import 'dart:math';

import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';

class AnimationControls extends FlareController {
  // Reference to this artboard anywhere
  FlutterActorArtboard _artboard;

  // Fill animation
  ActorAnimation _fillAnimation;

  // Used for mixing animations
  final List<FlareAnimationLayer> _baseAnimations = [];

  // Overall fill
  double _coffeeFill = 0.00;

  // Current amount of coffee consumed in ounces
  double _currentCoffeeFill = 0;

  // Time used to smooth fill line movement
  double _smoothTime = 5;

  void initialize(FlutterActorArtboard artboard) {
    this._artboard = artboard;
    this._fillAnimation = artboard.getAnimation("water up");
  }

  void setViewTransform(Mat2D viewTransform) {}

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    // Separate from generic mixing animations b/c animation duration needed
    // in this calculation
    if (artboard.name.compareTo("Artboard") == 0) {
      _currentCoffeeFill +=
          (_coffeeFill - _currentCoffeeFill) * min(1, elapsed * _smoothTime);
      _fillAnimation.apply(
          _currentCoffeeFill * _fillAnimation.duration, artboard, 1);
    }

    int length = _baseAnimations.length - 1;
    for (int i = length; i >= 0; i--) {
      FlareAnimationLayer layer = _baseAnimations[i];
      layer.time += elapsed;
      layer.mix = min(1.0, layer.time / 0.01);
      layer.apply(_artboard);

      if (layer.isDone) {
        _baseAnimations.removeAt(i);
      }
    }
    return true;
  }

  void playAnimation(String animationName) {
    ActorAnimation animation = _artboard.getAnimation(animationName);

    if (animation != null) {
      _baseAnimations.add(FlareAnimationLayer()
        ..name = animationName
        ..animation = animation);
    }
  }

  void updateCoffeePercent(double amount) {
    _coffeeFill = amount;
  }

  void resetCoffee() {
    _coffeeFill = 0;
  }
}
