import 'package:flutter/material.dart';

import 'drawer_snack_bar_container.dart';

class SnackBarManager {
  static OverlayEntry? _overlayEntry;
  static String? _currentMessage;

  static showDrawerSnackBar(
    BuildContext context, {
    String? message,
    Widget? content,
    Color? bgColor,
    Color? textColor,
    Duration stopDuration = const Duration(seconds: 3),
    Duration animationDuration = const Duration(milliseconds: 200),
    DrawerSnackBarPosition position = DrawerSnackBarPosition.bottom,
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

  static MainAxisAlignment _getMainAxisAlignment(
      DrawerSnackBarPosition position) {
    return switch (position) {
      DrawerSnackBarPosition.top => MainAxisAlignment.start,
      DrawerSnackBarPosition.bottom => MainAxisAlignment.end,
    };
  }

  static EdgeInsetsGeometry _getContentPadding(
    BuildContext context,
    DrawerSnackBarPosition position,
  ) {
    return switch (position) {
      DrawerSnackBarPosition.top =>
        EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      DrawerSnackBarPosition.bottom =>
        EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
    };
  }

  static void removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
    _currentMessage = null;
  }
}
