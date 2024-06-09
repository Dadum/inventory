import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inventory/constants.dart';
import 'package:inventory/providers/api.dart';
import 'package:inventory/widgets/character_inventory.dart';
import 'package:inventory/widgets/key_dialog.dart';

class CharactersView extends ConsumerWidget {
  const CharactersView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characters = ref.watch(charactersProvider);
    return switch (characters) {
      AsyncData(:final value) => ListView.builder(
          itemCount: value.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: LayoutConstants.largePadding,
                vertical: LayoutConstants.mediumPadding,
              ),
              child: CharacterInventory(character: value[index]),
            );
          },
        ),
      AsyncError(:final error) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'There was an error loading the data',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text('$error'),
              TextButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => const KeyDialog(),
                ),
                child: const Text('Set API Key'),
              ),
              Text(
                'An apy key with at least "account", "characters", and "inventories" permissions is required.',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        ),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}
