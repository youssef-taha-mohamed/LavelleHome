import 'package:flutter/material.dart';
import '../../core/style/app_colors.dart';

class JumpingDotsProgressIndicator extends StatefulWidget {
  final int numberOfDots;
  final double fontSize;
  final double dotSpacing;
  final Color color;
  final int milliseconds;
  final double beginTweenValue = 0;
  final double endTweenValue = 8;

  const JumpingDotsProgressIndicator({
    super.key,
    this.numberOfDots = 3,
    this.fontSize = 10,
    this.color = MyColors.black,
    this.dotSpacing = 0,
    this.milliseconds = 250,
  });

  @override
  State<JumpingDotsProgressIndicator> createState() =>
      JumpingDotsProgressIndicatorState();
}

class JumpingDotsProgressIndicatorState
    extends State<JumpingDotsProgressIndicator> with TickerProviderStateMixin {
  late List<AnimationController> controllers;
  late List<Animation<double>> animations;

  @override
  void initState() {
    super.initState();
    controllers = [];
    animations = [];

    for (var i = 0; i < widget.numberOfDots; i++) {
      _addAnimationControllers();
      _buildAnimations(i);
    }

    if (controllers.isNotEmpty) {
      controllers[0].forward();
    }
  }

  void _addAnimationControllers() {
    controllers.add(
      AnimationController(
        duration: Duration(milliseconds: widget.milliseconds),
        vsync: this,
      ),
    );
  }

  void _buildAnimations(int index) {
    animations.add(
      Tween(
        begin: widget.beginTweenValue,
        end: widget.endTweenValue,
      ).animate(controllers[index])
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            controllers[index].reverse();
          }
          if (index == widget.numberOfDots - 1 &&
              status == AnimationStatus.dismissed) {
            controllers[0].forward();
          }
          if (animations[index].value > widget.endTweenValue / 2 &&
              index < widget.numberOfDots - 1) {
            controllers[index + 1].forward();
          }
        }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.numberOfDots, (index) {
          return Padding(
            padding: EdgeInsets.only(right: widget.dotSpacing),
            child: _JumpingDot(
              animation: animations[index],
              fontSize: widget.fontSize,
              color: widget.color,
            ),
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}

class _JumpingDot extends AnimatedWidget {
  final Color color;
  final double fontSize;

  const _JumpingDot({
    required Animation<double> animation,
    required this.color,
    required this.fontSize,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return SizedBox(
      height: animation.value,
      child: Icon(Icons.circle, color: color, size: fontSize),
    );
  }
}
