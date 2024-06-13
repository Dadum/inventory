import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inventory/providers/api.dart';
import 'package:inventory/providers/settings.dart';

class SettingsDrawer extends HookConsumerWidget {
  const SettingsDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller =
        useTextEditingController(text: ref.watch(keyProvider).value);

    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: Text('Settings'),
          ),
          ListTile(
            title: TextField(
              controller: controller,
              decoration: const InputDecoration(
                label: Text('API Key'),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) =>
                  ref.read(keyProvider.notifier).set(key: value),
            ),
          ),
          CheckboxListTile.adaptive(
            title: const Text('Characters'),
            value: ref.watch(
                settingsProvider.select((value) => value.showCharacters)),
            onChanged: (_) =>
                ref.read(settingsProvider.notifier).toggleCharacters(),
          ),
          CheckboxListTile.adaptive(
            title: const Text('Bank'),
            value:
                ref.watch(settingsProvider.select((value) => value.showBank)),
            onChanged: (_) => ref.read(settingsProvider.notifier).toggleBank(),
          ),
          CheckboxListTile.adaptive(
            title: const Text('Materials'),
            value: ref
                .watch(settingsProvider.select((value) => value.showMaterials)),
            onChanged: (_) =>
                ref.read(settingsProvider.notifier).toggleMaterials(),
          ),
        ],
      ),
    );
  }
}
