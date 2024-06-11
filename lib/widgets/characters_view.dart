import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inventory/constants.dart';
import 'package:inventory/providers/api.dart';
import 'package:inventory/widgets/character_inventory.dart';

class CharactersView extends ConsumerWidget {
  const CharactersView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characters = ref.watch(filteredCharactersProvider);
    return ListView.separated(
      itemCount: characters.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            if (index == 0)
              Padding(
                padding: const EdgeInsets.all(LayoutConstants.mediumPadding),
                child: SizedBox.square(
                  dimension: Scaffold.of(context).appBarMaxHeight,
                ),
              ),
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: LayoutConstants.contentMaxWidth,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: LayoutConstants.largePadding,
                ),
                child: CharacterInventory(character: characters[index]),
              ),
            ).animate().fadeIn(duration: 500.ms),
          ],
        );
      },
      separatorBuilder: (context, index) => const SizedBox.square(
        dimension: LayoutConstants.largePadding,
      ),
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
