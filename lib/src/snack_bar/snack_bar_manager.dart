import 'package:animated_fixed_snack_bar/src/model/model.dart';
import 'package:flutter/material.dart';

import 'drawer_snack_bar/drawer_snack_bar_container.dart';

class SnackBarManager {
  static OverlayEntry? _overlayEntry;
  static String? _currentMessage;

  /// ## Show the snack bar with [Drawer] animation
  /// ```Dart
  /// SnackBarManager.showDrawerSnackBar(
  ///   context,
  ///   message: 'Hello Suica',
  ///   position: SnackBarPosition.top,
  /// );
  /// ```
  static showDrawerSnackBar(
    BuildContext context, {
    /// The message that you want to show on the snack bar (conflict with content)
    String? message,

    /// The widget that you want to show on the snack bar (conflict with message)
    Widget? content,

    /// The background color of the snack bar (default is primary)
    Color? bgColor,

    /// The foreground color of the snack bar (default is onPrimary)
    Color? textColor,

    /// The stop duration between enter animation and exit animation
    Duration stopDuration = const Duration(seconds: 3),

    /// The animation duration
    /// TODO: seperate the animation to enter and exit
    Duration animationDuration = const Duration(milliseconds: 200),

    /// The position that the snack bar pop up
    /// TODO: support the position on other side
    SnackBarPosition position = SnackBarPosition.bottom,
  }) {
    assert((content == null && message != null) ||
        (content != null && message == null));
    if (_currentMessage != null) {
      removeOverlay();
    }

    assert(_currentMessage == null);

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: _getMainAxisAlignment(position),
          children: [
            DrawerSnackBarContainer(
              animationDuration: animationDuration,
              stopDuration: stopDuration,
              onClose: () {
                removeOverlay();
              },
              from: position,
              child: content ??
                  Container(
                    padding: _getContentPadding(context, position),
                    color: bgColor ?? Theme.of(context).primaryColor,
                    alignment: AlignmentDirectional.topCenter,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              message!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: textColor ??
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            ),
          ],
        );
      },
    );
    _currentMessage = message;
    Overlay.of(context).insert(_overlayEntry!);
  }

  static MainAxisAlignment _getMainAxisAlignment(SnackBarPosition position) {
    return switch (position) {
      SnackBarPosition.top => MainAxisAlignment.start,
      SnackBarPosition.bottom => MainAxisAlignment.end,
    };
  }

  static EdgeInsetsGeometry _getContentPadding(
    BuildContext context,
    SnackBarPosition position,
  ) {
    return switch (position) {
      SnackBarPosition.top =>
        EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      SnackBarPosition.bottom =>
        EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
    };
  }

  static void removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
    _currentMessage = null;
  }

  /// TODO: Add more animation and custom animation controller
}
