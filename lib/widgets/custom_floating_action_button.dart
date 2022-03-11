import 'package:flutter/material.dart';

import '../classes/circular_button.dart';

class CustomFloatingActionButton extends StatefulWidget {
  final int duration;
  final IconData icon1, icon2, icon3, mainIcon;

  const CustomFloatingActionButton(
      {Key? key,
      required this.duration,
      required this.icon1,
      required this.icon2,
      required this.icon3,
      required this.mainIcon})
      : super(key: key);

  @override
  _CustomFloatingActionButtonState createState() =>
      _CustomFloatingActionButtonState();
}

class _CustomFloatingActionButtonState extends State<CustomFloatingActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation degOneTranslationAnimation,
      degTwoTranslationAnimation,
      degThreeTranslationAnimation,
      rotationAnimation;

  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  @override
  void initState() {
    animationController = AnimationController(
        // animationBehavior: AnimationBehavior.preserve,
        vsync: this,
        duration: Duration(milliseconds: widget.duration));
    degOneTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.2), weight: 75.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.2, end: 1.0), weight: 25.0),
    ]).animate(animationController);
    degTwoTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.4), weight: 55.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.4, end: 1.0), weight: 45.0),
    ]).animate(animationController);
    degThreeTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.75), weight: 45.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.75, end: 1.0), weight: 55.0),
    ]).animate(animationController);
    // degOneTranslationAnimation =
    //     Tween(begin: 0.0, end: 1.0).animate(animationController);
    rotationAnimation = Tween(begin: 180.0, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOut));
    super.initState();
    animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    void _showToast(BuildContext context) {
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: const Text('Added to favorite'),
          action: SnackBarAction(
              label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
        ),
      );
    }

    return Stack(fit: StackFit.expand, children: [
      Positioned(
        height: MediaQuery.of(context).size.height * .5,
        width: MediaQuery.of(context).size.width,
        right: 30,
        bottom: 30,
        child: Stack(
          alignment: Alignment.bottomRight,
          // fit: StackFit.expand,
          children: [
            Transform.translate(
              offset: Offset.fromDirection(getRadiansFromDegree(270),
                  degOneTranslationAnimation.value * 100),
              child: Transform(
                transform: Matrix4.rotationZ(
                    getRadiansFromDegree(rotationAnimation.value))
                  ..scale(degOneTranslationAnimation.value),
                alignment: Alignment.center,
                child: CircularButton(
                    width: 61,
                    height: 61,
                    color: Colors.deepPurple,
                    icon: Icon(
                      widget.icon1,
                      color: Colors.white,
                    ),
                    onClick: () {}),
              ),
            ),
            Transform.translate(
              offset: Offset.fromDirection(getRadiansFromDegree(225),
                  degTwoTranslationAnimation.value * 100),
              child: Transform(
                transform: Matrix4.rotationZ(
                    getRadiansFromDegree(rotationAnimation.value))
                  ..scale(degTwoTranslationAnimation.value),
                alignment: Alignment.center,
                child: CircularButton(
                    width: 61,
                    height: 61,
                    color: Colors.purple,
                    icon: Icon(
                      widget.icon2,
                      color: Colors.white,
                    ),
                    onClick: () {}),
              ),
            ),
            Transform.translate(
              offset: Offset.fromDirection(getRadiansFromDegree(180),
                  degThreeTranslationAnimation.value * 100),
              child: Transform(
                transform: Matrix4.rotationZ(
                    getRadiansFromDegree(rotationAnimation.value))
                  ..scale(degThreeTranslationAnimation.value),
                alignment: Alignment.center,
                child: CircularButton(
                    width: 61,
                    height: 61,
                    color: Colors.blueGrey,
                    icon: Icon(
                      widget.icon3,
                      color: Colors.white,
                    ),
                    onClick: () {
                      setState(() {
                        if (animationController.isCompleted) {
                          animationController.reverse();
                        } else {
                          animationController.forward();
                        }
                      });
                    }),
              ),
            ),
            Transform(
              transform: Matrix4.rotationZ(
                  getRadiansFromDegree(rotationAnimation.value)),
              alignment: Alignment.center,
              child: CircularButton(
                  width: 71,
                  height: 71,
                  color: Colors.black,
                  icon: Icon(
                    widget.mainIcon,
                    color: Colors.white,
                  ),
                  onClick: () {
                    if (animationController.isCompleted) {
                      animationController.reverse();
                    } else {
                      animationController.forward();
                    }
                  }),
            ),
          ],
        ),
      ),
    ]);
  }
}
