import 'package:inventory/providers/api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search.g.dart';

@riverpod
class Search extends _$Search {
  @override
  String build() {
    return '';
  }

  void search(String query) {
    state = query;
  }

  void clear() {
    state = '';
  }
}

@riverpod
Set<int> allIds(AllIdsRef ref) {
  final characters = ref.watch(charactersProvider);
  final items = characters.value
          ?.map((e) => ref.watch(inventoryProvider(character: e)).value ?? [])
          .expand((element) => element)
          .toList() ??
      [];
  return items.whereType<Item>().map((e) => e.id).toSet();
}

@riverpod
Future<Iterable<Item?>> filteredInventory(
    FilteredInventoryRef ref, String character) async {
  final search = ref.watch(searchProvider);
  final items =
      (await ref.watch(inventoryProvider(character: character).future))
          .whereType<Item>()
          .toList();

  if (search.isEmpty) {
    return items;
  }

  for (final item in items) {
    final details = await ref.watch(detailsProvider(item.id).future);

    if (!details.name.toLowerCase().contains(search.toLowerCase())) {
      items.remove(item);
    }
  }

  return items;
}

@riverpod
bool searching(SearchingRef ref) {
  return ref.watch(searchProvider).isNotEmpty;
}

@riverpod
Future<List<String>> filteredCharacters(FilteredCharactersRef ref) async {
  final search = ref.watch(searchProvider);
  final characters = await ref.watch(charactersProvider.future);

  if (search.isEmpty) {
    return characters;
  }

  return characters
      .where((element) =>
          ref
              .watch(inventoryProvider(character: element))
              .value
              ?.whereType<Item>()
              .any((item) =>
                  ref
                      .watch(detailsProvider(item.id))
                      .value
                      ?.name
                      .toLowerCase()
                      .contains(search.toLowerCase()) ??
                  false) ??
          false)
      .toList();
}
