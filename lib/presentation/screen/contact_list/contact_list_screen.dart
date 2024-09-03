import 'package:contacts_app/core/model/contact_summary.dart';
import 'package:contacts_app/presentation/l10n/app_localizations.dart';
import 'package:contacts_app/presentation/router/routes.dart';
import 'package:contacts_app/presentation/screen/contact_list/bloc/contact_list_bloc.dart';
import 'package:contacts_app/presentation/screen/contact_list/contact_list_item.dart';
import 'package:contacts_app/presentation/shared/widgets/divider.dart';
import 'package:contacts_app/presentation/style/app_text_style.dart';
import 'package:contacts_app/presentation/style/spacing.dart';
import 'package:contacts_app/simple_di.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  final _bloc = SimpleDi.instance.getContactListBloc()
    ..add(const ContactListSubscriptionRequested());

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  Widget _navigationBarSliver(BuildContext context) {
    return CupertinoSliverNavigationBar(
      backgroundColor: CupertinoColors.systemBackground,
      largeTitle: Text(
        AppLocalizations.of(context).contacts,
      ),
      trailing: CupertinoButton(
        padding: EdgeInsets.zero,
        child: Icon(
          CupertinoIcons.add,
          size: IconTheme.of(context).size,
        ),
        onPressed: () {
          ContactCreationRoute().go(context);
        },
      ),
    );
  }

  Widget _loadingViewSliver(BuildContext context) {
    return const SliverFillRemaining(
      child: Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }

  Widget _errorViewSliver(BuildContext context) {
    return SliverFillRemaining(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context).errorLoadingContacts,
            style: AppTextStyle.titleMedium(context),
          ),
          const SizedBox(height: Spacing.x2),
          CupertinoButton(
            onPressed: () {
              _bloc.add(const ContactListSubscriptionRequested());
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

  Widget _emptyViewSliver(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: Text(
          AppLocalizations.of(context).noContacts,
          style: AppTextStyle.titleMedium(context),
        ),
      ),
    );
  }

  Widget _contentViewSliver(
    BuildContext context,
    List<ContactSummary> contacts,
  ) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: contacts.length,
        (context, index) {
          final contact = contacts[index];
          return Column(
            children: [
              ContactListItem(
                contact: contact,
                onTap: () {
                  ContactDetailRoute(
                    contactId: contact.id,
                    firstName: contact.firstName,
                    lastName: contact.lastName,
                  ).go(context);
                },
              ),
              const Divider(),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          _navigationBarSliver(context),
          BlocBuilder<ContactListBloc, ContactListState>(
            bloc: _bloc,
            builder: (context, state) {
              switch (state.loadStatus) {
                case ContactListStatus.idle:
                  return const SliverFillRemaining();
                case ContactListStatus.loading:
                  return _loadingViewSliver(context);
                case ContactListStatus.failure:
                  return _errorViewSliver(context);
                case ContactListStatus.success:
                  final contacts = state.contacts;
                  if (contacts.isEmpty) {
                    return _emptyViewSliver(context);
                  }
                  return _contentViewSliver(context, contacts);
              }
            },
          ),
        ],
      ),
    );
  }
}
