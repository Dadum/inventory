import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inventory/providers/search.dart';

class SearchBox extends HookConsumerWidget {
  const SearchBox({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(
      text: ref.read(searchProvider),
    );

    return SearchBar(
      controller: controller,
      hintText: 'Search',
      leading: const Icon(Icons.search),
      trailing: [
        IconButton(
          onPressed: () {
            controller.clear();
            ref.read(searchProvider.notifier).clear();
          },
          icon: const Icon(Icons.clear),
        ),
      ],
      onChanged: (value) => ref.read(searchProvider.notifier).search(value),
    );
  }
}
