import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inventory/constants.dart';
import 'package:inventory/providers/api.dart';
import 'package:inventory/widgets/item_widget.dart';

class CharacterInventory extends ConsumerWidget {
  const CharacterInventory({
    super.key,
    required this.character,
  });

  final String character;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(filteredItemsProvider(character: character));
    final freeSlots = items.whereType<Null>().length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(LayoutConstants.largePadding),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(LayoutConstants.mediumPadding),
                  child: Text(
                    character,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ],
            ),
            Wrap(
              children: [
                ...items.whereType<Item>().map(
                      (e) => SizedBox.square(
                        dimension: 80,
                        child: ItemWidget(item: e),
                      ),
                    ),
                if (freeSlots > 0)
                  SizedBox.square(
                    dimension: 80,
                    child: EmptySlots(freeSlots: freeSlots),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
