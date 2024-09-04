import 'package:contacts_app/presentation/l10n/app_localizations.dart';
import 'package:contacts_app/presentation/router/routes.dart';
import 'package:contacts_app/presentation/screen/contact_editing/bloc/contact_editing_bloc.dart';
import 'package:contacts_app/presentation/shared/contact_data_form/contact_data_form.dart';
import 'package:contacts_app/presentation/shared/widgets/confirmation_dialog.dart';
import 'package:contacts_app/presentation/style/app_text_style.dart';
import 'package:contacts_app/presentation/style/spacing.dart';
import 'package:contacts_app/simple_di.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactEditingScreen extends StatefulWidget {
  const ContactEditingScreen({super.key, required this.contactId});

  final String contactId;

  @override
  State<ContactEditingScreen> createState() => _ContactEditingScreenState();
}

class _ContactEditingScreenState extends State<ContactEditingScreen> {
  late final _bloc = SimpleDi.instance
      .getContactEditingBloc(contactId: widget.contactId)
    ..add(const ContactEditingExistingDataRequested());

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
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
            _bloc.add(const ContactEditingExistingDataRequested());
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
        _bloc.add(ContactEditingFirstNameChanged(value));
      },
      lastName: state.lastName,
      onLastNameChanged: (value) {
        _bloc.add(ContactEditingLastNameChanged(value));
      },
      phoneNumbers: state.phoneNumbers,
      onPhoneNumbersChanged: (value) {
        _bloc.add(ContactEditingPhoneNumbersChanged(value));
      },
      addresses: state.addresses,
      onAddressesChanged: (value) {
        _bloc.add(ContactEditingAddressesChanged(value));
      },
      onDeletePressed: () {
        ConfirmationDialog.show(
          context,
          isConfirmationActionDestructive: true,
          confirmationActionTitle:
              Text(AppLocalizations.of(context).deleteContact),
          cancelActionTitle: Text(AppLocalizations.of(context).cancel),
          onConfirmation: (dialogClosingFuture) async {
            await dialogClosingFuture;
            _bloc.add(const ContactEditingDeleteRequested());
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactEditingBloc, ContactEditingState>(
      bloc: _bloc,
      listenWhen: (previous, current) {
        return previous.updateStatus != current.updateStatus ||
            previous.deletionStatus != current.deletionStatus;
      },
      listener: (context, state) {
        switch (state.updateStatus) {
          case ContactUpdateStatus.success:
            ContactDetailRoute(
              contactId: widget.contactId,
              firstName: state.firstName,
              lastName: state.lastName,
            ).go(context);
          case ContactUpdateStatus.failure:
            _showUpdateErrorDialog(
              context,
              onTryAgain: () {
                _bloc.add(const ContactEditingSaveRequested());
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
                _bloc.add(const ContactEditingDeleteRequested());
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
              ConfirmationDialog.show(
                context,
                message: Text(
                  AppLocalizations.of(context)
                      .editContactExitConfirmationMessage,
                ),
                isConfirmationActionDestructive: false,
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
                        _bloc.add(const ContactEditingSaveRequested());
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
