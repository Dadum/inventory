import 'dart:convert';
import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'api.freezed.dart';
part 'api.g.dart';

class Api {
  static const url = 'api.guildwars2.com';

  static Uri get characters => Uri.https(url, '/v2/characters');
  static Uri inventory(String character) =>
      Uri.https(url, '${characters.path}/$character/inventory');
  static Uri item(int id) => Uri.https(url, '/v2/items/$id');
  static Uri items(List<int> ids) =>
      Uri.https(url, '/v2/items', {'ids': ids.join(',')});
}

@riverpod
class Key extends _$Key {
  static const _settingsKey = 'api-key';

  @override
  Future<String> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_settingsKey) ?? '';
  }

  Future<void> set({required String key}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, key);
    state = AsyncValue.data(key);
    ref.invalidateSelf();
  }
}

@riverpod
Future<List<String>> characters(CharactersRef ref) async {
  final key = ref.watch(keyProvider);
  final response = await http.get(
    Api.characters,
    headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${key.value}',
    },
  );

  if (response.statusCode == HttpStatus.unauthorized) {
    throw const HttpException('Invalid API key');
  }

  return (jsonDecode(response.body) as List<dynamic>)
      .map((e) => e as String)
      .toList();
}

@freezed
class Item with _$Item {
  const factory Item({
    required int id,
    required int count,
    Details? details,
  }) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}

@freezed
class Details with _$Details {
  const factory Details({
    required int id,
    required String name,
    required String icon,
  }) = _Details;

  factory Details.fromJson(Map<String, dynamic> json) =>
      _$DetailsFromJson(json);
}

@freezed
class Bag with _$Bag {
  const Bag._();

  const factory Bag({
    required int id,
    required List<Item?> inventory,
  }) = _Bag;

  factory Bag.fromJson(Map<String, dynamic> json) => _$BagFromJson(json);

  List<Item> get items => inventory.whereType<Item>().toList();
}

@freezed
class Inventory with _$Inventory {
  const factory Inventory({
    required List<Bag> bags,
  }) = _Inventory;

  factory Inventory.fromJson(Map<String, dynamic> json) =>
      _$InventoryFromJson(json);
}

@riverpod
class Items extends _$Items {
  @override
  Future<List<Item>> build({required String character}) async {
    final key = ref.watch(keyProvider);

    final response = await http.get(
      Api.inventory(character),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${key.value}',
      },
    );

    final inventory = Inventory.fromJson(jsonDecode(response.body));
    return inventory.bags.expand((e) => e.items).toList();
  }
}

// @riverpod
// Stream<Map<String, List<Item>>> items(ItemsRef ref) async* {
//   final token = ref.watch(keyProvider);
//   final characters = ref.watch(charactersProvider);
//   final items = <String, List<Item>>{};

//   for (final character in characters.value ?? []) {
//     final response = await http.get(
//       Api.inventory(character),
//       headers: {
//         HttpHeaders.authorizationHeader: 'Bearer ${token.value}',
//       },
//     );

//     if (response.statusCode == HttpStatus.ok) {
//       final inventory = Inventory.fromJson(jsonDecode(response.body));
//       items[character] = inventory.bags.expand((e) => e.items).toList();

//       yield items;
//     }
//   }
// }

@riverpod
Set<int> itemIds(ItemIdsRef ref) {
  final characters = ref.watch(charactersProvider);
  return characters.value
          ?.map((e) => ref.watch(itemsProvider(character: e)))
          .expand((e) => e.value ?? <Item>[])
          .map((e) => e.id)
          .toSet() ??
      {};
}

// @riverpod
// Future<Map<int, ItemDetails>> itemDetails(ItemDetailsRef ref) async {
//   final client = http.Client();
//   ref.onDispose(() => client.close());

//   final ids = ref.watch(itemIdsProvider);

//   final response = await client.get(Api.items(ids.toList()));

//   final data = jsonDecode(response.body) as List<dynamic>;

//   return Map.fromEntries(
//     data.map((e) => ItemDetails.fromJson(e)).map((e) => MapEntry(e.id, e)),
//   );
// }

@riverpod
class ItemDetails extends _$ItemDetails {
  @override
  Map<int, Details> build() {
    ref.listen(
      itemIdsProvider,
      (previous, next) => insert(next),
    );

    // final newIds = ids.difference(state.keys.toSet());
    // // final ids = ref.watch(itemIdsProvider);

    // final response = await http.get(Api.items(ids.toList()));

    // final data = jsonDecode(response.body) as List<dynamic>;

    // state.addAll(Map.fromEntries(
    //   data.map((e) => Details.fromJson(e)).map((e) => MapEntry(e.id, e)),
    // ));
    return {};
  }

  Future<void> insert(Set<int> ids) async {
    final newIds = ids.difference(state.keys.toSet());
    final response = await http.get(Api.items(newIds.toList()));

    if (response.statusCode != HttpStatus.ok) {
      return;
    }

    final data = jsonDecode(response.body) as List<dynamic>;

    state.addAll(Map.fromEntries(
      data.map((e) => Details.fromJson(e)).map((e) => MapEntry(e.id, e)),
    ));
  }
}
