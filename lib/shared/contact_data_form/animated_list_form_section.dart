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
  late var _itemCount = widget.initialItemCount;
  int? _openActionCellIndex;
  late final _actionCellKeys = List.generate(_itemCount, (_) => GlobalKey());

  final _animatedListKey = GlobalKey<AnimatedListState>();
  final _swipeActionController = SwipeActionController();

  @override
  void dispose() {
    _swipeActionController.dispose();
    super.dispose();
  }

  void _addFieldToList() {
    widget.onItemAdded();
    _actionCellKeys.add(GlobalKey());
    _animatedListKey.currentState?.insertItem(
      _itemCount,
      duration: AnimationDuration.short,
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
    final removeIconButton = CupertinoButton(
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

    return tapRegionToCancelSwipeAction;
  }

  Widget _addFieldButton(BuildContext context) {
    return CupertinoButton(
      onPressed: _addFieldToList,
      padding: EdgeInsets.zero,
      child: CupertinoFormRow(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final divider = Divider(
      leadingIndent: Spacing.firstKeyline +
          (IconTheme.of(context).size ?? 0) +
          Spacing.firstKeyline,
    );

    return CupertinoListSection(
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
