import 'package:contacts_app/presentation/l10n/app_localizations.dart';
import 'package:contacts_app/core/model/address.dart';
import 'package:contacts_app/presentation/shared/constants/address_labels.dart';
import 'package:contacts_app/presentation/shared/contact_data_form/address_form_field.dart';
import 'package:contacts_app/presentation/shared/contact_data_form/animated_list_form_section.dart';
import 'package:flutter/cupertino.dart';

class AddressFormSection extends StatefulWidget {
  const AddressFormSection({
    super.key,
    required this.initialAddresses,
    required this.onAddressesChanged,
  });

  final List<Address>? initialAddresses;
  final ValueChanged<List<Address>> onAddressesChanged;

  @override
  State<AddressFormSection> createState() => _AddressFormSectionState();
}

class _AddressFormSectionState extends State<AddressFormSection> {
  late var _addresses = widget.initialAddresses ?? [];

  void _onNewAddressAdded(BuildContext context) {
    // Determine the label for the new address. If the last address has a label,
    // use the next label in the list. Otherwise, use the first label in the list.
    final addressLabels = getPredefinedAddressLabels(context);
    final lastUsedAddressLabelIndex =
        addressLabels.indexOf(_addresses.lastOrNull?.label ?? '');
    final newAddressLabel =
        addressLabels[(lastUsedAddressLabelIndex + 1) % addressLabels.length];
    final newAddress = Address.empty(label: newAddressLabel);

    final updatedAddresses = [..._addresses, newAddress];
    _addresses = updatedAddresses;
    widget.onAddressesChanged(updatedAddresses);
  }

  void _onAddressChanged(int index, Address address) {
    final updatedAddresses = List<Address>.from(_addresses)..[index] = address;
    _addresses = updatedAddresses;
    widget.onAddressesChanged(updatedAddresses);
  }

  void _onAddressRemoved(int index) {
    final updatedAddresses = List<Address>.from(_addresses)..removeAt(index);
    _addresses = updatedAddresses;
    widget.onAddressesChanged(updatedAddresses);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedListFormSection(
      initialItemCount: _addresses.length,
      itemBuilder: (context, index) => AddressFormField(
        initialAddress: _addresses[index],
        onAddressChanged: (address) => _onAddressChanged(index, address),
      ),
      addItemButtonLabel: AppLocalizations.of(context).addAddress,
      onItemAdded: () => _onNewAddressAdded(context),
      onItemRemoved: _onAddressRemoved,
    );
  }
}
