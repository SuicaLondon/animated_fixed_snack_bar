import 'package:animated_fixed_snack_bar/src/animation/animation.dart';
import 'package:animated_fixed_snack_bar/src/model/model.dart';
import 'package:flutter/material.dart';

class DrawerSnackBarContainer extends StatefulWidget {
  const DrawerSnackBarContainer({
    super.key,
    required this.child,
    required this.onClose,
    this.stopDuration = const Duration(seconds: 3),
    this.animationDuration = const Duration(milliseconds: 350),
    this.from = SnackBarPosition.top,
  });
  final Widget child;
  final void Function() onClose;
  final Duration animationDuration;
  final Duration? stopDuration;
  final SnackBarPosition from;

  @override
  State<DrawerSnackBarContainer> createState() =>
      _DrawerSnackBarContainerState();
}

class _DrawerSnackBarContainerState extends State<DrawerSnackBarContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
      reverseDuration: widget.animationDuration,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void Function(DragUpdateDetails)? _onPanUpdate() {
    if (widget.from == SnackBarPosition.top) {
      return (details) async {
        if (details.delta.dy < 0) {
          if (mounted) {
            await _controller.reverse();
            widget.onClose();
          }
        }
      };
    } else {
      return (details) async {
        if (details.delta.dy > 0) {
          if (mounted) {
            await _controller.reverse();
            widget.onClose();
          }
        }
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return DrawerAnimation(
      controller: _controller,
      duration: widget.animationDuration,
      stopDuration: widget.stopDuration,
      onDismissed: (controller) {
        widget.onClose();
      },
      child: GestureDetector(
        onPanUpdate: _onPanUpdate(),
        child: widget.child,
      ),
    );
  }
}
