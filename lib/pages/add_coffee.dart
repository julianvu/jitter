import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:jitter/services/flare_controller.dart';

class AddCoffee extends StatefulWidget {
  @override
  _AddCoffeeState createState() => _AddCoffeeState();
}

class _AddCoffeeState extends State<AddCoffee> {
  double screenWidth = 0.0;
  double screenHeight = 0.0;

  AnimationControls _flareController;

  final FlareControls plusCoffeeControls = FlareControls();
  final FlareControls minusCoffeeControls = FlareControls();

  int currentCoffeeCount = 0;

  int maxCoffeeCount = 0;

  int selectedCups = 8;

  static const int ouncePerCup = 6;

  void _resetDay() {
    setState(() {
      currentCoffeeCount = 0;
      _flareController.resetCoffee();
    });
  }

  void _incrementCoffee() {
    setState(() {
      if (currentCoffeeCount < selectedCups) {
        currentCoffeeCount += 1;
        double diff = currentCoffeeCount / selectedCups;
        _flareController.playAnimation("ripple");
        _flareController.updateCoffeePercent(diff);
      }
    });
  }

  void _decrementCoffee() {
    setState(() {
      if (currentCoffeeCount > 0) {
        currentCoffeeCount -= 1;
        double diff = currentCoffeeCount / selectedCups;
        _flareController.updateCoffeePercent(diff);
        _flareController.playAnimation("ripple");
      } else {
        currentCoffeeCount = 0;
      }
    });
  }

  void calculateMaxOunces() {
    maxCoffeeCount = selectedCups * ouncePerCup;
  }

  void _incrementSelectedCups(StateSetter updateModal, int value) {
    updateModal(() {
      selectedCups = (selectedCups + value).clamp(0, 26).toInt();
      calculateMaxOunces();
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            FlareActor(
              "assets/Coffee.flr",
              controller: _flareController,
              fit: BoxFit.contain,
              artboard: "Artboard",
            ),
            RawMaterialButton(
              onPressed: _incrementCoffee,
              shape: CircleBorder(),
              elevation: 10.0,
              fillColor: Theme.of(context).primaryColor,
              splashColor: Theme.of(context).splashColor,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _flareController = AnimationControls();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

/// Button with a Flare widget that automatically plays
/// a Flare animation when pressed. Specify which animation
/// via [pressAnimation] and the [artboard] it's in.
class FlareCoffeeTrackButton extends StatefulWidget {
  final String pressAnimation;
  final String artboard;
  final VoidCallback onPressed;
  const FlareCoffeeTrackButton(
      {this.artboard, this.pressAnimation, this.onPressed});

  @override
  _FlareCoffeeTrackButtonState createState() => _FlareCoffeeTrackButtonState();
}

class _FlareCoffeeTrackButtonState extends State<FlareCoffeeTrackButton> {
  final _controller = FlareControls();

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: BoxConstraints.tight(const Size(95, 85)),
      onPressed: () {
        _controller.play(widget.pressAnimation);
        widget.onPressed?.call();
      },
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: FlareActor("assets/Coffee.flr",
          controller: _controller,
          fit: BoxFit.contain,
          artboard: widget.artboard),
    );
  }
}
