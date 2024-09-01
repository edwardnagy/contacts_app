import 'package:contacts_app/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

/// A screen that allows the user to pick a label for a field (e.g., address).
class LabelPickerScreen extends StatelessWidget {
  const LabelPickerScreen({
    super.key,
    required this.initialLabel,
    required this.labels,
  });

  final String? initialLabel;
  final List<String> labels;

  /// Shows the label picker screen.
  ///
  /// Returns the selected label or `null` if the user cancels the operation.
  static Future<String?> show(
    BuildContext context, {
    required String? initialLabel,
    required List<String> labels,
  }) {
    return Navigator.push(
      context,
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => LabelPickerScreen(
          initialLabel: initialLabel,
          labels: labels,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor:
          CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        middle: Text(AppLocalizations.of(context).labelPickerTitle),
      ),
      child: ListView(
        children: [
          CupertinoListSection(
            topMargin: 0,
            hasLeading: false,
            children: labels.map(
              (label) {
                final isSelected = label == initialLabel;
                return CupertinoListTile(
                  title: Text(label),
                  trailing:
                      isSelected ? const Icon(CupertinoIcons.checkmark) : null,
                  onTap: () => Navigator.pop(context, label),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
}
