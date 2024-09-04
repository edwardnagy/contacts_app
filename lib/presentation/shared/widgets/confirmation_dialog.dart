import 'dart:async';

import 'package:flutter/cupertino.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    required this.message,
    required this.isConfirmationActionDestructive,
    required this.onConfirmation,
    required this.confirmationActionTitle,
    required this.cancelActionTitle,
  });

  final Widget? message;
  final bool isConfirmationActionDestructive;

  /// Callback triggered when the user confirms the action.
  ///
  /// The callback receives a [Future] that completes when the dialog's closing
  /// animation finishes. Waiting for this ensures that any subsequent navigation
  /// animations aren't interrupted by the dialog's closing animation.
  final void Function(Future dialogClosingFuture) onConfirmation;
  final Widget confirmationActionTitle;
  final Widget cancelActionTitle;

  static Future<void> show(
    BuildContext context, {
    Widget? message,
    required bool isConfirmationActionDestructive,
    required void Function(Future dialogClosingFuture) onConfirmation,
    required Widget confirmationActionTitle,
    required Widget cancelActionTitle,
  }) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) => ConfirmationDialog(
        message: message,
        isConfirmationActionDestructive: isConfirmationActionDestructive,
        onConfirmation: onConfirmation,
        confirmationActionTitle: confirmationActionTitle,
        cancelActionTitle: cancelActionTitle,
      ),
    );
  }

  // Transition duration used in the modal popup.
  // See _kModalPopupTransitionDuration: https://github.com/flutter/flutter/blob/6fe09872b12acb5747d6e01e84987120cabf31df/packages/flutter/lib/src/cupertino/route.dart
  static const _modalPopupTransitionDuration = Duration(milliseconds: 335);

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      message: message,
      actions: <Widget>[
        CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () {
            Navigator.pop(context);

            // Completer that will be completed when the dialog closing
            // animation is finished.
            final dialogClosingCompleter = Completer();
            Future.delayed(_modalPopupTransitionDuration).then((_) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                dialogClosingCompleter.complete();
              });
            });
            onConfirmation(dialogClosingCompleter.future);
          },
          child: confirmationActionTitle,
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        isDefaultAction: true,
        onPressed: () => Navigator.pop(context),
        child: cancelActionTitle,
      ),
    );
  }
}
