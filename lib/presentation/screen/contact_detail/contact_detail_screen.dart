import 'package:collection/collection.dart';
import 'package:contacts_app/core/model/address.dart';
import 'package:contacts_app/core/model/phone_number.dart';
import 'package:contacts_app/presentation/l10n/app_localizations.dart';
import 'package:contacts_app/presentation/router/routes.dart';
import 'package:contacts_app/presentation/screen/contact_detail/bloc/contact_detail_bloc.dart';
import 'package:contacts_app/presentation/style/app_text_style.dart';
import 'package:contacts_app/presentation/style/spacing.dart';
import 'package:contacts_app/simple_di.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactDetailScreen extends StatelessWidget {
  const ContactDetailScreen({
    super.key,
    required this.contactId,
    required this.firstName,
    required this.lastName,
  });

  final String contactId;

  /// The first name of the contact, required for the animation of the
  /// navigation bar title.
  final String? firstName;

  /// The last name of the contact, required for the animation of the navigation
  /// bar title.
  final String? lastName;

  CupertinoListTile _phoneNumberTile(
    BuildContext context,
    PhoneNumber phoneNumber,
  ) {
    return CupertinoListTile.notched(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.x_2_5,
        vertical: Spacing.x1_5,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            phoneNumber.label,
            style: AppTextStyle.label(context),
          ),
          const SizedBox(height: Spacing.x0_5),
          Text(
            phoneNumber.number,
            style: CupertinoTheme.of(context).textTheme.actionTextStyle,
          ),
        ],
      ),
    );
  }

  CupertinoListTile _addressTile(
    BuildContext context,
    Address address,
  ) {
    final addressText = [
      address.street1,
      address.street2,
      [
        [address.city, address.state].whereNotEmpty().join(', '),
        address.zipCode,
      ].whereNotEmpty().join(' '),
    ].whereNotEmpty().join('\n');
    return CupertinoListTile.notched(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.x_2_5,
        vertical: Spacing.x1_5,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            address.label,
            style: AppTextStyle.label(context),
          ),
          const SizedBox(height: Spacing.x0_5),
          ConstrainedBox(
            constraints: BoxConstraints(
                minHeight:
                    3 * (DefaultTextStyle.of(context).style.fontSize ?? 18)),
            child: Text(
              addressText,
              maxLines: 5,
            ),
          ),
          const SizedBox(height: Spacing.x1),
        ],
      ),
    );
  }

  Widget _errorView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context).errorLoadingContact,
            style: AppTextStyle.titleMedium(context),
          ),
          const SizedBox(height: Spacing.x2),
          CupertinoButton(
            onPressed: () {
              context
                  .read<ContactDetailBloc>()
                  .add(const ContactDetailRequested());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.x2,
                vertical: Spacing.x1,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                AppLocalizations.of(context).retry,
                style: TextStyle(
                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contentView(BuildContext context, ContactDetailLoadSuccess state) {
    return ListView(
      children: [
        if (state.contact.phoneNumbers.isNotEmpty)
          CupertinoListSection.insetGrouped(
            margin: const EdgeInsets.symmetric(
              horizontal: Spacing.x1,
            ).copyWith(
              top: Spacing.x2,
            ),
            additionalDividerMargin: 0,
            children: state.contact.phoneNumbers
                .map((phoneNumber) => _phoneNumberTile(context, phoneNumber))
                .toList(),
          ),
        if (state.contact.addresses.isNotEmpty)
          CupertinoListSection.insetGrouped(
            margin: const EdgeInsets.symmetric(
              horizontal: Spacing.x1,
            ).copyWith(
              top: Spacing.x2,
            ),
            additionalDividerMargin: 0,
            children: state.contact.addresses
                .map((address) => _addressTile(context, address))
                .toList(),
          ),
        const SizedBox(height: Spacing.x4),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SimpleDi.instance.getContactDetailBloc(contactId: contactId)
            ..add(const ContactDetailRequested()),
      child: BlocBuilder<ContactDetailBloc, ContactDetailState>(
        builder: (context, state) {
          final firstName = state is ContactDetailLoadSuccess
              ? state.contact.firstName
              : this.firstName;
          final lastName = state is ContactDetailLoadSuccess
              ? state.contact.lastName
              : this.lastName;
          return CupertinoPageScaffold(
            backgroundColor:
                CupertinoColors.systemGroupedBackground.resolveFrom(context),
            navigationBar: CupertinoNavigationBar(
              middle: Text(
                [firstName, lastName].whereNotNull().whereNotEmpty().join(' '),
              ),
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                child: Text(AppLocalizations.of(context).edit),
                onPressed: () {
                  ContactEditingRoute(contactId: contactId).go(context);
                },
              ),
            ),
            child: switch (state) {
              ContactDetailInitial() => const SizedBox(),
              ContactDetailLoadInProgress() => const Center(
                  child: CupertinoActivityIndicator(),
                ),
              ContactDetailLoadFailure() => _errorView(context),
              ContactDetailLoadSuccess() => _contentView(context, state),
            },
          );
        },
      ),
    );
  }
}

extension on Iterable<String> {
  Iterable<String> whereNotEmpty() => where((element) => element.isNotEmpty);
}
