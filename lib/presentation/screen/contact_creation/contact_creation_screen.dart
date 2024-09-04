import 'package:contacts_app/presentation/l10n/app_localizations.dart';
import 'package:contacts_app/presentation/router/routes.dart';
import 'package:contacts_app/presentation/screen/contact_creation/bloc/contact_creation_bloc.dart';
import 'package:contacts_app/presentation/shared/contact_data_form/contact_data_form.dart';
import 'package:contacts_app/presentation/shared/widgets/confirmation_dialog.dart';
import 'package:contacts_app/simple_di.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactCreationScreen extends StatefulWidget {
  const ContactCreationScreen({super.key});

  @override
  State<ContactCreationScreen> createState() => _ContactCreationScreenState();
}

class _ContactCreationScreenState extends State<ContactCreationScreen> {
  final _bloc = SimpleDi.instance.getContactCreationBloc();

  void _showSaveErrorDialog(
    BuildContext context, {
    required VoidCallback onTryAgain,
  }) {
    showCupertinoDialog<void>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(AppLocalizations.of(context).saveContactErrorTitle),
        content: Text(AppLocalizations.of(context).saveContactErrorMessage),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context).cancel),
          ),
          CupertinoDialogAction(
            onPressed: () {
              // Allow the dialog to close before executing the try again action
              onTryAgain();
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context).tryAgain),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactCreationBloc, ContactCreationState>(
      bloc: _bloc,
      listenWhen: (previous, current) {
        return previous.creationStatus != current.creationStatus;
      },
      listener: (context, state) {
        switch (state.creationStatus) {
          case ContactCreationSuccess(:final contactId):
            ContactDetailRoute(
              contactId: contactId,
              firstName: state.firstName,
              lastName: state.lastName,
            ).go(context);
          case ContactCreationFailure():
            _showSaveErrorDialog(
              context,
              onTryAgain: () {
                _bloc.add(const ContactCreationSaveRequested());
              },
            );
          default:
            break;
        }
      },
      builder: (context, state) {
        return PopScope(
          // prevent pop if there are unsaved changes
          canPop: !state.isAnyFieldFilled,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              // pop was prevented, show confirmation dialog
              ConfirmationDialog.show(
                context,
                message: Text(
                  AppLocalizations.of(context)
                      .newContactExitConfirmationMessage,
                ),
                isConfirmationActionDestructive: true,
                confirmationActionTitle:
                    Text(AppLocalizations.of(context).discardChanges),
                cancelActionTitle:
                    Text(AppLocalizations.of(context).keepEditing),
                onConfirmation: (dialogClosingFuture) async {
                  await dialogClosingFuture;
                  if (!context.mounted) return;
                  Navigator.pop(context, result);
                },
              );
            }
          },
          child: CupertinoPageScaffold(
            backgroundColor:
                CupertinoColors.systemGroupedBackground.resolveFrom(context),
            navigationBar: CupertinoNavigationBar(
              middle: Text(AppLocalizations.of(context).newContact),
              leading: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
                child: Text(AppLocalizations.of(context).cancel),
              ),
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: state.isAnyFieldFilled
                    ? () {
                        _bloc.add(const ContactCreationSaveRequested());
                      }
                    : null,
                child: Text(AppLocalizations.of(context).done),
              ),
            ),
            child: ContactDataForm(
              autofocus: true,
              firstName: state.firstName,
              onFirstNameChanged: (value) {
                _bloc.add(ContactCreationFirstNameChanged(value));
              },
              lastName: state.lastName,
              onLastNameChanged: (value) {
                _bloc.add(ContactCreationLastNameChanged(value));
              },
              phoneNumbers: state.phoneNumbers,
              onPhoneNumbersChanged: (value) {
                _bloc.add(ContactCreationPhoneNumbersChanged(value));
              },
              addresses: state.addresses,
              onAddressesChanged: (value) {
                _bloc.add(ContactCreationAddressesChanged(value));
              },
            ),
          ),
        );
      },
    );
  }
}
