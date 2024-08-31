import 'package:contacts_app/l10n/app_localizations.dart';
import 'package:contacts_app/shared/constants/phone_labels.dart';
import 'package:flutter/cupertino.dart';

class PhoneLabelPickerScreen extends StatelessWidget {
  const PhoneLabelPickerScreen({
    super.key,
    required this.initialLabel,
  });

  final String? initialLabel;

  static Future<String?> show(
    BuildContext context, {
    required String? initialLabel,
  }) {
    return Navigator.push(
      context,
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => PhoneLabelPickerScreen(
          initialLabel: initialLabel,
        ),
      ),
    );
  }

  void _onPhoneLabelSelected(BuildContext context, String label) {
    Navigator.pop(context, label);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor:
          CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        middle: Text(AppLocalizations.of(context).phoneLabelPickerTitle),
      ),
      child: ListView(
        children: [
          CupertinoListSection(
            topMargin: 0,
            children: getPredefinedPhoneLabels(context).map(
              (label) {
                final isSelected = label == initialLabel;
                return CupertinoListTile(
                  title: Text(label),
                  trailing:
                      isSelected ? const Icon(CupertinoIcons.checkmark) : null,
                  onTap: () => _onPhoneLabelSelected(context, label),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
}
