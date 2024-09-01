import 'package:contacts_app/l10n/app_localizations.dart';
import 'package:contacts_app/shared/widgets/divider.dart';
import 'package:contacts_app/shared/widgets/icon_with_background.dart';
import 'package:contacts_app/style/animation_duration.dart';
import 'package:contacts_app/style/spacing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';

/// A form section that contains a list of items that can be added and removed.
class AnimatedListFormSection<T> extends StatefulWidget {
  const AnimatedListFormSection({
    super.key,
    required this.initialItemCount,
    required this.itemBuilder,
    required this.onItemAdded,
    required this.onItemRemoved,
    required this.addItemButtonLabel,
  });

  final int initialItemCount;
  final Widget Function(BuildContext, int index) itemBuilder;
  final VoidCallback onItemAdded;
  final void Function(int index) onItemRemoved;
  final String addItemButtonLabel;

  @override
  State<AnimatedListFormSection> createState() =>
      _AnimatedListFormSectionState();
}

class _AnimatedListFormSectionState extends State<AnimatedListFormSection> {
  static const _insertItemAnimationDuration = AnimationDuration.short;

  late var _itemCount = widget.initialItemCount;
  int? _openActionCellIndex;
  late final _actionCellKeys = List.generate(_itemCount, (_) => GlobalKey());
  late final _focusScopeNodes =
      List.generate(_itemCount, (_) => _buildFocusScopeNode());

  final _animatedListKey = GlobalKey<AnimatedListState>();
  final _swipeActionController = SwipeActionController();

  FocusScopeNode _buildFocusScopeNode() => FocusScopeNode(
        debugLabel: 'form field',
        traversalEdgeBehavior: TraversalEdgeBehavior.parentScope,
      );

  void _addFieldToList() {
    widget.onItemAdded();
    _actionCellKeys.add(GlobalKey());

    final newFocusScopeNode = _buildFocusScopeNode();
    _focusScopeNodes.add(newFocusScopeNode);
    Future.delayed(
      _insertItemAnimationDuration + AnimationDuration.extraShort,
      newFocusScopeNode.nextFocus,
    );

    _animatedListKey.currentState?.insertItem(
      _itemCount,
      duration: _insertItemAnimationDuration,
    );
    _itemCount++;
  }

  Future<void> _removeFieldFromList(
    int index, {
    required Future swipeAnimationCompletion,
  }) async {
    final removedFieldWidget = _fieldBuilder(
      context,
      index,
      onRemovePressed: null,
    ); // build the widget before its item is removed
    widget.onItemRemoved(index);
    await swipeAnimationCompletion;
    _actionCellKeys.removeAt(index);
    _focusScopeNodes.removeAt(index)
      ..parent?.unfocus()
      ..dispose();
    _animatedListKey.currentState?.removeItem(
      index,
      (context, animation) => removedFieldWidget,
      duration: Duration.zero,
    );
    _itemCount--;
  }

  /// Builds the widget for the field at the given index.
  Widget _fieldBuilder(
    BuildContext context,
    int index, {
    required VoidCallback? onRemovePressed,
  }) {
    final removeIconButton = Focus(
      // the button should not be focusable, only the fields
      canRequestFocus: false,
      descendantsAreFocusable: false,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onRemovePressed,
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: Spacing.firstKeyline,
          ),
          child: IconWithBackground(
            CupertinoIcons.minus_circle_fill,
            iconColor: CupertinoColors.systemRed.resolveFrom(context),
            backgroundColor: CupertinoColors.white,
          ),
        ),
      ),
    );

    return CupertinoFormRow(
      padding: EdgeInsetsDirectional.zero,
      prefix: removeIconButton,
      child: widget.itemBuilder(context, index),
    );
  }

  /// Builds the widget for the field at the given index with delete action.
  Widget _removableFieldBuilder(BuildContext context, int index) {
    final deleteSwipeAction = SwipeAction(
      title: AppLocalizations.of(context).delete,
      style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: CupertinoColors.white,
          ),
      onTap: (CompletionHandler handler) async {
        _removeFieldFromList(
          index,
          swipeAnimationCompletion: handler(true),
        );
      },
    );

    final swipeActionCell = SwipeActionCell(
      key: _actionCellKeys[index],
      controller: _swipeActionController,
      index: index,
      isDraggable: false,
      backgroundColor: CupertinoColors.transparent,
      trailingActions: [deleteSwipeAction],
      child: _fieldBuilder(
        context,
        index,
        onRemovePressed: () {
          _swipeActionController.openCellAt(index: index, trailing: true);
          _openActionCellIndex = index;
        },
      ),
    );

    // Close the swipe action when tapped outside
    final tapRegionToCancelSwipeAction = TapRegion(
      onTapOutside: (_) {
        if (index == _openActionCellIndex) {
          _swipeActionController.closeAllOpenCell();
          _openActionCellIndex = null;
        }
      },
      child: swipeActionCell,
    );

    final focusableField = FocusScope(
      node: _focusScopeNodes[index],
      child: tapRegionToCancelSwipeAction,
    );

    return focusableField;
  }

  Widget _addFieldButton(BuildContext context) {
    return Focus(
      // the button should not be focusable, only the fields
      canRequestFocus: false,
      descendantsAreFocusable: false,
      child: CupertinoListTile(
        onTap: _addFieldToList,
        padding: EdgeInsets.zero,
        title: CupertinoFormRow(
          padding: EdgeInsetsDirectional.zero,
          prefix: Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: Spacing.firstKeyline,
            ),
            child: IconWithBackground(
              CupertinoIcons.plus_circle_fill,
              iconColor: CupertinoColors.systemGreen.resolveFrom(context),
              backgroundColor: CupertinoColors.white,
            ),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.addItemButtonLabel,
              style: TextStyle(
                color: CupertinoColors.label.resolveFrom(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _swipeActionController.dispose();
    for (final focusScopeNode in _focusScopeNodes) {
      focusScopeNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final divider = Divider(
      leadingIndent: Spacing.firstKeyline +
          (IconTheme.of(context).size ?? 0) +
          Spacing.firstKeyline,
    );

    return CupertinoFormSection(
      children: [
        AnimatedList.separated(
          key: _animatedListKey,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          // Add one to the item count to account for the add button.
          initialItemCount: widget.initialItemCount + 1,
          itemBuilder: (context, index, animation) {
            if (index == _itemCount) {
              return _addFieldButton(context);
            }

            return SizeTransition(
              sizeFactor: animation,
              child: FadeTransition(
                opacity: animation,
                child: _removableFieldBuilder(context, index),
              ),
            );
          },
          separatorBuilder: (context, index, animation) => divider,
          removedSeparatorBuilder: (context, index, animation) => divider,
        ),
      ],
    );
  }
}
