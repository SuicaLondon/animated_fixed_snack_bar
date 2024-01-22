import 'dart:async';

import 'package:flutter/material.dart';

class DrawerAnimation extends StatefulWidget {
  const DrawerAnimation({
    super.key,
    required this.child,
    this.controller,
    this.initialValue,
    this.lowValue = 0,
    this.topValue = 1,
    this.duration = const Duration(milliseconds: 350),
    this.curve = Curves.easeIn,
    this.axis = Axis.vertical,
    this.axisAlignment = 0.0,
    this.stopDuration,
    this.onDismissed,
  });
  final AnimationController? controller;
  final Widget child;
  final double? initialValue;
  final double lowValue;
  final double topValue;
  final Curve curve;
  final Axis axis;
  final double axisAlignment;
  final Duration duration;
  final Duration? stopDuration;
  final void Function(AnimationController controller)? onDismissed;

  @override
  State<DrawerAnimation> createState() => _DrawerAnimationState();
}

class _DrawerAnimationState extends State<DrawerAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        AnimationController(
          value: widget.initialValue,
          lowerBound: widget.lowValue,
          upperBound: widget.topValue,
          duration: widget.duration,
          reverseDuration: widget.duration,
          vsync: this,
        );
    _controller.forward();
    _animation = Tween<double>(begin: widget.lowValue, end: widget.topValue)
        .animate(_controller);
    _controller.addStatusListener(_listener);
  }

  @override
  void dispose() {
    _timer?.cancel();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _listener(AnimationStatus status) {
    if (!mounted) return;

    if (status == AnimationStatus.completed) {
      if (widget.stopDuration != null) {
        _timer = Timer(widget.stopDuration!, () {
          _controller.reverse();
        });
      } else {
        _controller.reverse();
      }
    } else if (status == AnimationStatus.dismissed) {
      if (widget.onDismissed != null) {
        widget.onDismissed?.call(_controller);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizeTransition(
        sizeFactor: _animation,
        axis: widget.axis,
        axisAlignment: -1,
        child: widget.child,
      ),
    );
  }
}
