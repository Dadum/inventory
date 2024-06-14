import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inventory/constants.dart';
import 'package:inventory/providers/api.dart';
import 'package:inventory/widgets/characters_view.dart';
import 'package:inventory/widgets/search_box.dart';
import 'package:inventory/widgets/settings_drawer.dart';

void main() {
  if (kDebugMode) {
    Animate.restartOnHotReload = true;
  }

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
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Inventory'),
            SizedBox.square(
              dimension: LayoutConstants.mediumPadding,
            ),
            Flexible(
              child: SearchBox(),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(itemsProvider);
              ref.invalidate(charactersProvider);
            },
          ),
          Builder(
            builder: (context) {
              return IconButton(
                  icon: const Icon(Icons.settings),
                  tooltip: 'Open settings',
                  onPressed: () => Scaffold.of(context).openEndDrawer());
            },
          ),
        ],
      ),
      endDrawer: const SettingsDrawer(),
      body: Consumer(
        builder: (context, ref, child) =>
            switch (ref.watch(charactersProvider)) {
          AsyncData() => const CharactersView(),
          AsyncError(:final error) => ApiErrorView(
              error: error,
            ),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}
