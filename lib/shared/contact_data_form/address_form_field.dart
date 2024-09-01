import 'package:contacts_app/l10n/app_localizations.dart';
import 'package:contacts_app/model/address.dart';
import 'package:contacts_app/shared/constants/address_labels.dart';
import 'package:contacts_app/shared/contact_data_form/field_label.dart';
import 'package:contacts_app/shared/widgets/divider.dart';
import 'package:contacts_app/shared/widgets/vertical_field_divider.dart';
import 'package:contacts_app/style/spacing.dart';
import 'package:flutter/cupertino.dart';

class AddressFormField extends StatefulWidget {
  const AddressFormField({
    super.key,
    required this.initialAddress,
    required this.onAddressChanged,
  });

  final Address initialAddress;
  final ValueChanged<Address> onAddressChanged;

  @override
  State<AddressFormField> createState() => _AddressFormFieldState();
}

class _AddressFormFieldState extends State<AddressFormField> {
  late final _street1Controller = TextEditingController(
    text: widget.initialAddress.street1,
  );
  late final _street2Controller = TextEditingController(
    text: widget.initialAddress.street2,
  );
  late final _cityController = TextEditingController(
    text: widget.initialAddress.city,
  );
  late final _stateController = TextEditingController(
    text: widget.initialAddress.state,
  );
  late final _zipCodeController = TextEditingController(
    text: widget.initialAddress.zipCode,
  );

  @override
  void dispose() {
    _street1Controller.dispose();
    _street2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  Widget _inputTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String placeholder,
    required ValueChanged<String> onChanged,
    EdgeInsetsDirectional padding =
        const EdgeInsetsDirectional.only(start: Spacing.firstKeyline),
  }) {
    return Row(
      children: [
        const VerticalFieldDivider(),
        Expanded(
          child: CupertinoTextField(
            padding: padding,
            controller: controller,
            placeholder: placeholder,
            placeholderStyle: TextStyle(
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
            decoration: const BoxDecoration(),
            keyboardType: TextInputType.streetAddress,
            textInputAction: TextInputAction.unspecified,
            onEditingComplete: () {
              FocusScope.of(context).nextFocus();
            },
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoFormRow(
      padding: EdgeInsetsDirectional.zero,
      prefix: FieldLabel(
        currentLabel: widget.initialAddress.label,
        labels: getPredefinedAddressLabels(context),
        onLabelChanged: (label) {
          widget.onAddressChanged(
            widget.initialAddress.copyWith(label: label),
          );
        },
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.only(end: Spacing.firstKeyline),
        child: Column(
          children: [
            _inputTextField(
              context,
              controller: _street1Controller,
              placeholder: AppLocalizations.of(context).streetPlaceholder,
              onChanged: (value) {
                widget.onAddressChanged(
                  widget.initialAddress.copyWith(street1: value),
                );
              },
            ),
            const Divider(leadingIndent: 0),
            _inputTextField(
              context,
              controller: _street2Controller,
              placeholder: AppLocalizations.of(context).streetPlaceholder,
              onChanged: (value) {
                widget.onAddressChanged(
                  widget.initialAddress.copyWith(street2: value),
                );
              },
            ),
            const Divider(leadingIndent: 0),
            _inputTextField(
              context,
              controller: _cityController,
              placeholder: AppLocalizations.of(context).cityPlaceholder,
              onChanged: (value) {
                widget.onAddressChanged(
                  widget.initialAddress.copyWith(city: value),
                );
              },
            ),
            const Divider(leadingIndent: 0),
            Row(
              children: [
                Expanded(
                  child: _inputTextField(
                    context,
                    padding: const EdgeInsetsDirectional.only(
                      start: Spacing.firstKeyline,
                      end: Spacing.x1,
                    ),
                    controller: _stateController,
                    placeholder: AppLocalizations.of(context).statePlaceholder,
                    onChanged: (value) {
                      widget.onAddressChanged(
                        widget.initialAddress.copyWith(state: value),
                      );
                    },
                  ),
                ),
                const VerticalFieldDivider(),
                Expanded(
                  child: _inputTextField(
                    context,
                    padding: const EdgeInsetsDirectional.only(
                      start: Spacing.x1,
                    ),
                    controller: _zipCodeController,
                    placeholder:
                        AppLocalizations.of(context).zipCodePlaceholder,
                    onChanged: (value) {
                      widget.onAddressChanged(
                        widget.initialAddress.copyWith(zipCode: value),
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
