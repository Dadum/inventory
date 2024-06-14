import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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

    final focus = useFocusNode();

    final expanded = useState(false);

    return SizedBox(
      height: 40,
      child: SearchBar(
        controller: controller,
        focusNode: focus,
        hintText: 'Search',
        leading: const Icon(Icons.search),
        trailing: [
          IconButton(
            onPressed: () {
              controller.clear();
              ref.invalidate(searchProvider);
            },
            icon: const Icon(Icons.clear),
          ),
        ],
        onChanged: (value) => ref.read(searchProvider.notifier).search(value),
        onTapOutside: (event) => expanded.value = false,
      )
          .animate(target: expanded.value ? 0.0 : 1.0)
          .fade(begin: 1.0, end: 0.0, duration: 200.ms)
          .scaleX(
              duration: 100.ms,
              begin: 1.0,
              end: 0.2,
              alignment: Alignment.topRight)
          .swap(
            builder: (context, child) => Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton.filledTonal(
                  onPressed: () {
                    expanded.value = true;
                    focus.requestFocus();
                  },
                  icon: const Icon(Icons.search),
                ).animate().fadeIn(duration: 100.ms),
              ],
            ),
          ),
    );
  }
}
