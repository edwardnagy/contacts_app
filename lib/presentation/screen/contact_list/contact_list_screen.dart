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
    ..add(const ContactListRequested());

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  Widget _navigationBarSliver(BuildContext context) {
    return CupertinoSliverNavigationBar(
      backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
      border: const Border(),
      largeTitle: Text(
        AppLocalizations.of(context).contacts,
      ),
      stretch: true,
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

  SliverPersistentHeader _searchBarSliver(BuildContext context) {
    const estimatedSearchBarHeight = 34.0;
    const dividerHeight = 1.0;
    const dividerSpacing = Spacing.x2;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _SearchBarSliverDelegate(
        height:
            MediaQuery.textScalerOf(context).scale(estimatedSearchBarHeight) +
                dividerSpacing +
                dividerHeight,
        builder: (context, overlapsContent) {
          return ColoredBox(
            color: CupertinoColors.systemBackground.resolveFrom(context),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.firstKeyline,
                  ),
                  child: CupertinoTextField(
                    placeholder: AppLocalizations.of(context).search,
                    placeholderStyle: TextStyle(
                      color:
                          CupertinoColors.secondaryLabel.resolveFrom(context),
                    ),
                    decoration: BoxDecoration(
                      color: CupertinoColors.secondarySystemBackground
                          .resolveFrom(context),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefix: Padding(
                      padding:
                          const EdgeInsetsDirectional.only(start: Spacing.x0_5),
                      child: Icon(
                        CupertinoIcons.search,
                        color:
                            CupertinoColors.secondaryLabel.resolveFrom(context),
                        size: 20,
                      ),
                    ),
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.search,
                    enableSuggestions: false,
                    autocorrect: false, // on iOS, this is tied to suggestions
                    onChanged: (value) {
                      _bloc.add(ContactListRequested(searchQuery: value));
                    },
                  ),
                ),
                const SizedBox(height: dividerSpacing),
                Divider(
                    leadingIndent: overlapsContent ? 0 : Spacing.firstKeyline),
              ],
            ),
          );
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
              _bloc.add(const ContactListRequested());
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

  Widget _emptyViewSliver(BuildContext context, {required String searchQuery}) {
    return SliverFillRemaining(
      child: searchQuery.isEmpty
          ? Center(
              child: Text(
                AppLocalizations.of(context).noContacts,
                style: AppTextStyle.titleMedium(context),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.search,
                  size: 64,
                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                ),
                const SizedBox(height: Spacing.x2),
                Text(
                  AppLocalizations.of(context).noResultsForSearch(searchQuery),
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .navLargeTitleTextStyle
                      .copyWith(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Spacing.x0_2_5),
                Text(
                  AppLocalizations.of(context).noResultsDescription,
                  style: TextStyle(
                    fontSize: 16,
                    color: CupertinoColors.secondaryLabel.resolveFrom(context),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
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
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: <Widget>[
          _navigationBarSliver(context),
          _searchBarSliver(context),
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
                    return _emptyViewSliver(
                      context,
                      searchQuery: state.searchQuery,
                    );
                  }
                  return _contentViewSliver(context, contacts);
              }
            },
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).padding.bottom + Spacing.x4,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBarSliverDelegate extends SliverPersistentHeaderDelegate {
  _SearchBarSliverDelegate({required this.height, required this.builder});

  final double height;
  final Widget Function(BuildContext context, bool overlapsContent) builder;

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(_SearchBarSliverDelegate oldDelegate) {
    return height != oldDelegate.height;
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return builder(context, overlapsContent);
  }
}
