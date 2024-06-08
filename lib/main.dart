import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inventory/constants.dart';
import 'package:inventory/providers/api.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
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
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                ref.refresh(charactersProvider);
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit),
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
                return CharacterInventory(character: value[index]);
              },
            ),
          AsyncError(:final error) => Center(child: Text(error.toString())),
          _ => const Center(child: CircularProgressIndicator()),
        });
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
    final items = ref.watch(itemsProvider(character: character)).value ?? [];
    return Column(
      children: [
        Text(character),
        Wrap(
          children: items
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.all(LayoutConstants.smallPadding),
                  child: SizedBox.square(
                    dimension: 80,
                    child: ItemWidget(item: e),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class ItemWidget extends ConsumerWidget {
  final Item item;

  const ItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(itemDetailsProvider)[item.id];

    if (details == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        Positioned.fill(
          child: Image.network(
            details.icon,
            fit: BoxFit.contain,
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: SizedBox.square(
            dimension: 32,
            child: Card(
              child: Center(
                child: Text(
                  '${item.count}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
