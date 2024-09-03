import 'dart:async';

import 'package:contacts_app/presentation/l10n/app_localizations.dart';
import 'package:contacts_app/presentation/router/routes.dart';
import 'package:contacts_app/presentation/screen/contact_editing/bloc/contact_editing_bloc.dart';
import 'package:contacts_app/presentation/shared/contact_data_form/contact_data_form.dart';
import 'package:contacts_app/presentation/style/app_text_style.dart';
import 'package:contacts_app/presentation/style/spacing.dart';
import 'package:contacts_app/simple_di.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactEditingScreen extends StatelessWidget {
  const ContactEditingScreen({super.key, required this.contactId});

  final String contactId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SimpleDi.instance.getContactEditingBloc(contactId: contactId)
            ..add(const ContactEditingExistingDataRequested()),
      child: _ContactEditingView(contactId: contactId),
    );
  }
}

class _ContactEditingView extends StatelessWidget {
  const _ContactEditingView({required this.contactId});

  final String contactId;

  void _showExitAndDiscardChangesConfirmationDialog(
    BuildContext context, {
    required void Function(Future dialogClosingFuture) onExitConfirmed,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        message: Text(
          AppLocalizations.of(context).editContactExitConfirmationMessage,
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

  void _showDeletionConfirmationDialog(
    BuildContext context, {
    required VoidCallback onDeletionConfirmed,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              onDeletionConfirmed();
            },
            child: Text(AppLocalizations.of(context).deleteContact),
          )
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context).cancel),
        ),
      ),
    );
  }

  void _showUpdateErrorDialog(
    BuildContext context, {
    required VoidCallback onTryAgain,
  }) {
    showCupertinoDialog<void>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(AppLocalizations.of(context).editContactErrorTitle),
        content: Text(AppLocalizations.of(context).editContactErrorMessage),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context).cancel),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
              onTryAgain();
            },
            child: Text(AppLocalizations.of(context).tryAgain),
          ),
        ],
      ),
    );
  }

  void _showDeletionErrorDialog(
    BuildContext context, {
    required VoidCallback onTryAgain,
  }) {
    showCupertinoDialog<void>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(AppLocalizations.of(context).deleteContactErrorTitle),
        content: Text(AppLocalizations.of(context).deleteContactErrorMessage),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context).cancel),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
              onTryAgain();
            },
            child: Text(AppLocalizations.of(context).tryAgain),
          ),
        ],
      ),
    );
  }

  Widget _loadingView(BuildContext context) {
    return const Center(
      child: CupertinoActivityIndicator(),
    );
  }

  Widget _errorView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context).errorLoadingContact,
          style: AppTextStyle.titleMedium(context),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: Spacing.x2),
        CupertinoButton(
          onPressed: () {
            context
                .read<ContactEditingBloc>()
                .add(const ContactEditingExistingDataRequested());
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
    );
  }

  Widget _contentView(BuildContext context, ContactEditingState state) {
    return ContactDataForm(
      firstName: state.firstName,
      onFirstNameChanged: (value) {
        context
            .read<ContactEditingBloc>()
            .add(ContactEditingFirstNameChanged(value));
      },
      lastName: state.lastName,
      onLastNameChanged: (value) {
        context
            .read<ContactEditingBloc>()
            .add(ContactEditingLastNameChanged(value));
      },
      phoneNumbers: state.phoneNumbers,
      onPhoneNumbersChanged: (value) {
        context
            .read<ContactEditingBloc>()
            .add(ContactEditingPhoneNumbersChanged(value));
      },
      addresses: state.addresses,
      onAddressesChanged: (value) {
        context
            .read<ContactEditingBloc>()
            .add(ContactEditingAddressesChanged(value));
      },
      onDeletePressed: () {
        _showDeletionConfirmationDialog(
          context,
          onDeletionConfirmed: () {
            context
                .read<ContactEditingBloc>()
                .add(const ContactEditingDeleteRequested());
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactEditingBloc, ContactEditingState>(
      listenWhen: (previous, current) {
        return previous.updateStatus != current.updateStatus ||
            previous.deletionStatus != current.deletionStatus;
      },
      listener: (context, state) {
        switch (state.updateStatus) {
          case ContactUpdateStatus.success:
            ContactDetailRoute(
              contactId: contactId,
              firstName: state.firstName,
              lastName: state.lastName,
            ).go(context);
          case ContactUpdateStatus.failure:
            _showUpdateErrorDialog(
              context,
              onTryAgain: () {
                context
                    .read<ContactEditingBloc>()
                    .add(const ContactEditingSaveRequested());
              },
            );
          default:
            break;
        }
        switch (state.deletionStatus) {
          case ContactDeletionStatus.success:
            ContactListRoute().go(context);
          case ContactDeletionStatus.failure:
            _showDeletionErrorDialog(
              context,
              onTryAgain: () {
                context
                    .read<ContactEditingBloc>()
                    .add(const ContactEditingDeleteRequested());
              },
            );
          default:
            break;
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: !state.isSavingEnabled,
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
              leading: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
                child: Text(AppLocalizations.of(context).cancel),
              ),
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: state.isSavingEnabled
                    ? () {
                        context
                            .read<ContactEditingBloc>()
                            .add(const ContactEditingSaveRequested());
                      }
                    : null,
                child: Text(AppLocalizations.of(context).done),
              ),
            ),
            child: switch (state.loadStatus) {
              ContactLoadStatus.initial => const SizedBox(),
              ContactLoadStatus.inProgress => _loadingView(context),
              ContactLoadStatus.failure => _errorView(context),
              ContactLoadStatus.success => _contentView(context, state),
            },
          ),
        );
      },
    );
  }
}
