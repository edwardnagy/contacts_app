import 'dart:async';

import 'package:contacts_app/presentation/l10n/app_localizations.dart';
import 'package:contacts_app/presentation/router/routes.dart';
import 'package:contacts_app/presentation/screen/contact_creation/bloc/contact_creation_bloc.dart';
import 'package:contacts_app/presentation/shared/contact_data_form/contact_data_form.dart';
import 'package:contacts_app/simple_di.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactCreationScreen extends StatelessWidget {
  const ContactCreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SimpleDi.instance.getContactCreationBloc(),
      child: const _ContactCreationForm(),
    );
  }
}

class _ContactCreationForm extends StatelessWidget {
  const _ContactCreationForm();

  void _showExitAndDiscardChangesConfirmationDialog(
    BuildContext context, {
    required void Function(Future dialogClosingFuture) onExitConfirmed,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        message: Text(
          AppLocalizations.of(context).newContactExitConfirmationMessage,
        ),
        actions: <Widget>[
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);

              // Transition duration used in the modal popup.
              // See _kModalPopupTransitionDuration: https://github.com/flutter/flutter/blob/6fe09872b12acb5747d6e01e84987120cabf31df/packages/flutter/lib/src/cupertino/route.dart
              const modalPopupTransitionDuration = Duration(milliseconds: 335);
              // Completer that will be completed when the dialog closing
              // animation is finished.
              final dialogClosingCompleter = Completer();
              Future.delayed(modalPopupTransitionDuration).then((_) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  dialogClosingCompleter.complete();
                });
              });
              onExitConfirmed(dialogClosingCompleter.future);
            },
            child: Text(AppLocalizations.of(context).discardChanges),
          )
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context).keepEditing),
        ),
      ),
    );
  }

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
                context
                    .read<ContactCreationBloc>()
                    .add(const ContactCreationSaveRequested());
              },
            );
          default:
            break;
        }
      },
      builder: (context, state) {
        return PopScope(
          // prevent pop if there are unsaved changes
          canPop: !state.isAnyFieldNotEmpty,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              // pop was prevented, show confirmation dialog
              _showExitAndDiscardChangesConfirmationDialog(
                context,
                onExitConfirmed: (dialogClosingFuture) async {
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
                onPressed: state.isAnyFieldNotEmpty
                    ? () {
                        context
                            .read<ContactCreationBloc>()
                            .add(const ContactCreationSaveRequested());
                      }
                    : null,
                child: Text(AppLocalizations.of(context).done),
              ),
            ),
            child: ContactDataForm(
              autofocus: true,
              firstName: state.firstName,
              onFirstNameChanged: (value) {
                context
                    .read<ContactCreationBloc>()
                    .add(ContactCreationFirstNameChanged(value));
              },
              lastName: state.lastName,
              onLastNameChanged: (value) {
                context
                    .read<ContactCreationBloc>()
                    .add(ContactCreationLastNameChanged(value));
              },
              phoneNumbers: state.phoneNumbers,
              onPhoneNumbersChanged: (value) {
                context
                    .read<ContactCreationBloc>()
                    .add(ContactCreationPhoneNumbersChanged(value));
              },
              addresses: state.addresses,
              onAddressesChanged: (value) {
                context
                    .read<ContactCreationBloc>()
                    .add(ContactCreationAddressesChanged(value));
              },
            ),
          ),
        );
      },
    );
  }
}
