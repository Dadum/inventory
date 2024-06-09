import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inventory/constants.dart';
import 'package:inventory/providers/api.dart';
import 'package:inventory/widgets/characters_view.dart';
import 'package:inventory/widgets/key_dialog.dart';
import 'package:inventory/widgets/search_box.dart';

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
        typography: Typography.material2021(),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(itemsProvider);
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
      body: Stack(
        children: [
          Expanded(
            child: Consumer(
                builder: (context, ref, child) =>
                    switch (ref.watch(charactersProvider)) {
                      AsyncData() => const CharactersView(),
                      AsyncError(:final error) => ApiErrorView(
                          error: error,
                        ),
                      _ => const Center(child: CircularProgressIndicator()),
                    }),
          ),
          const Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.all(LayoutConstants.mediumPadding),
              child: SearchBox(),
            ),
          ),
        ],
      ),
    );
  }
}
