import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inventory/providers/api.dart';

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
