import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inventory/providers/api.dart';

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
        ],
      ),
    );
  }
}
