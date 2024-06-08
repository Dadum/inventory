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
Set<int> filteredIds(FilteredIdsRef ref) {
  final search = ref.watch(searchProvider);
  final items = ref.watch(itemDetailsProvider);

  return items.value?.values
          .where(
              (item) => item.name.toLowerCase().contains(search.toLowerCase()))
          .map((item) => item.id)
          .toSet() ??
      {};
}
