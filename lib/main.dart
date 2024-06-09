import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inventory/constants.dart';
import 'package:inventory/providers/api.dart';
import 'package:inventory/providers/search.dart';

void main() {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends ConsumerWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Inventory',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const Home(),
    );
  }
}

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characters = ref.watch(charactersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text('Inventory'),
            Spacer(),
            Expanded(
              child: SearchBar(),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              for (final character in characters.value ?? []) {
                ref.invalidate(itemsProvider(character: character));
              }
              ref.invalidate(charactersProvider);
            },
          ),
          IconButton(
            icon: const Icon(Icons.code),
            tooltip: 'Modify API Key',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return const KeyDialog();
                },
              );
            },
          ),
        ],
      ),
      body: switch (characters) {
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
      },
    );
  }
}

class SearchBar extends HookConsumerWidget {
  const SearchBar({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(
      text: ref.read(searchProvider),
    );

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Search',
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            controller.clear();
            ref.read(searchProvider.notifier).clear();
          },
        ),
      ),
      onChanged: (value) => ref.read(searchProvider.notifier).search(value),
    );
  }
}

class KeyDialog extends HookConsumerWidget {
  const KeyDialog({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller =
        useTextEditingController(text: ref.watch(keyProvider).value);
    return AlertDialog(
      title: const Text('API Key'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          hintText: 'API Key',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            ref.read(keyProvider.notifier).set(key: controller.text);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

class CharacterInventory extends ConsumerWidget {
  const CharacterInventory({
    super.key,
    required this.character,
  });

  final String character;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(filteredItemsProvider(character: character));

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
              children: items
                  .map(
                    (e) => Padding(
                      padding:
                          const EdgeInsets.all(LayoutConstants.smallPadding),
                      child: SizedBox.square(
                        dimension: 80,
                        child: ItemWidget(item: e),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemWidget extends ConsumerWidget {
  final Item item;

  const ItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(itemDetailsProvider).value?[item.id];

    if (details == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              details.icon,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: SizedBox.square(
            dimension: 34,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Text(
                  '${item.count}',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
