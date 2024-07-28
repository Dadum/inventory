import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inventory/constants.dart';
import 'package:inventory/providers/api.dart';
import 'package:inventory/providers/search.dart';
import 'package:inventory/widgets/item_widget.dart';

class CharacterInventory extends ConsumerWidget {
  const CharacterInventory({
    super.key,
    required this.character,
  });

  final String character;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(filteredInventoryProvider(character));

    return InventoryWidget(
      name: character,
      items: items.value ?? [],
      isLoading: items.isLoading,
    );
  }
}

class BankInventory extends ConsumerWidget {
  const BankInventory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(bankProvider);

    return InventoryWidget(
        name: 'Bank', items: items.value ?? [], isLoading: items.isLoading);
  }
}

class MaterialInventory extends ConsumerWidget {
  const MaterialInventory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(materialsProvider);

    return InventoryWidget(
        name: 'Materials',
        items: items.value ?? [],
        isLoading: items.isLoading);
  }
}

class InventoryWidget extends ConsumerWidget {
  const InventoryWidget(
      {super.key,
      required this.name,
      required this.items,
      this.isLoading = false});

  final String name;
  final Iterable<Item?> items;
  final bool isLoading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final freeSlots = items.whereType<Null>().length;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          if (isLoading)
            const Align(
              alignment: Alignment.topCenter,
              child: LinearProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(LayoutConstants.largePadding),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.all(LayoutConstants.mediumPadding),
                      child: Text(
                        name,
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
        ],
      ),
    );
  }
}
