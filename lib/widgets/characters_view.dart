import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inventory/constants.dart';
import 'package:inventory/providers/api.dart';
import 'package:inventory/providers/search.dart';
import 'package:inventory/providers/settings.dart';
import 'package:inventory/widgets/character_inventory.dart';

class CharactersView extends ConsumerWidget {
  const CharactersView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characters = ref.watch(charactersProvider);
    if (ref.watch(searchingProvider)) {
      characters.value?.removeWhere(
        (element) =>
            !(ref.watch(filteredCharactersProvider).value?.contains(element) ??
                true),
      );
    }

    final listItems = [
      if (ref.watch(settingsProvider.select((v) => v.showCharacters)))
        ...(characters.value?.map(
                (e) => (key: e, child: CharacterInventory(character: e))) ??
            []),
      if (ref.watch(settingsProvider.select((v) => v.showBank)))
        (key: 'bank', child: const BankInventory()),
      if (ref.watch(settingsProvider.select((v) => v.showMaterials)))
        (key: 'materials', child: const MaterialInventory()),
    ];

    return ListView.separated(
      itemCount: listItems.length,
      itemBuilder: (context, index) {
        return _ListEntry(
          key: ValueKey(listItems[index].key),
          child: listItems[index].child,
        );
      },
      separatorBuilder: (context, index) => const SizedBox.square(
        dimension: LayoutConstants.largePadding,
      ),
    );
  }
}

class _ListEntry extends StatelessWidget {
  const _ListEntry({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: LayoutConstants.contentMaxWidth,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: LayoutConstants.largePadding,
            ),
            child: child,
          ).animate().fadeIn(duration: 500.ms),
        ),
      ],
    );
  }
}

class ApiErrorView extends ConsumerWidget {
  const ApiErrorView({super.key, required this.error});

  final Object error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
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
            onPressed: () => Scaffold.of(context).openEndDrawer(),
            child: const Text('Set API Key'),
          ),
          Text(
            'An api key with at least "account", "characters", and "inventories" permissions is required.',
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
