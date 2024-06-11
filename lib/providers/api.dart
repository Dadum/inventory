import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:inventory/providers/search.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'api.freezed.dart';
part 'api.g.dart';

class Api {
  static const url = 'api.guildwars2.com';

  static Uri autheticated(String endpoint, String key) =>
      Uri.https(url, '/v2/$endpoint', {'access_token': key});

  static Uri characters(String key) => autheticated('characters', key);

  static Uri inventory(String character, String key) {
    final base = characters(key);
    return Uri.https(
        url, '${base.path}/$character/inventory', base.queryParameters);
  }

  static const String bank = 'bank';

  static const String materials = 'materials';

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
    Api.characters(key.value ?? ''),
  );

  if (response.statusCode == HttpStatus.unauthorized) {
    throw const HttpException('Invalid API key');
  }

  return [
    ...(jsonDecode(response.body) as List<dynamic>).map((e) => e as String),
    Api.bank,
    Api.materials,
  ];
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

enum Rarity {
  @JsonValue('Junk')
  junk(Color(0xFFA8A8A8)),
  @JsonValue('Basic')
  basic(Color(0xFFFFFFFF)),
  @JsonValue('Fine')
  fine(Color(0xFF0075FF)),
  @JsonValue('Masterwork')
  masterwork(Color(0xFF1A9306)),
  @JsonValue('Rare')
  rare(Color(0xFFFFBC05)),
  @JsonValue('Exotic')
  exotic(Color(0xFFDD5D00)),
  @JsonValue('Ascended')
  ascended(Color(0xFFDF35EE)),
  @JsonValue('Legendary')
  legendary(Color(0xFF4C139D));

  const Rarity(this.color);

  final Color color;
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

    if (character == Api.bank || character == Api.materials) {
      final response = await http.get(
        Api.autheticated('account/$character', key.value ?? ''),
      );

      return (jsonDecode(response.body) as List<dynamic>)
          .where((e) => e != null && e != '')
          .map((e) => Item.fromJson(e))
          .toList();
    }

    final response = await http.get(
      Api.inventory(character, key.value ?? ''),
    );

    return Inventory.fromJson(jsonDecode(response.body))
        .bags
        .expand((e) => e.items)
        .toList();
  }
}

@riverpod
class FilteredItems extends _$FilteredItems {
  @override
  List<Item> build({required String character}) {
    final items = ref.watch(itemsProvider(character: character)).value ?? [];
    final filter = ref.watch(filteredIdsProvider);

    return items.where((e) => filter.contains(e.id)).toList();
  }
}

@riverpod
List<String> filteredCharacters(FilteredCharactersRef ref) {
  final characters = ref.watch(charactersProvider);

  return characters.value
          ?.where(
              (e) => ref.watch(filteredItemsProvider(character: e)).isNotEmpty)
          .toList() ??
      [];
}

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

@freezed
class Details with _$Details {
  const factory Details({
    required int id,
    required String chatLink,
    required String name,
    required String icon,
    String? description,
    required String type,
    required Rarity rarity,
    required int level,
    required int vendorValue,
    required List<String> flags,
    required List<String> restrictions,
    DetailsDetails? details,
  }) = _Details;

  factory Details.fromJson(Map<String, dynamic> json) =>
      _$DetailsFromJson(json);
}

@freezed
class DetailsDetails with _$DetailsDetails {
  const factory DetailsDetails({
    String? type,
    String? description,
    int? minPower,
    int? maxPower,
    int? defense,
  }) = _DetailsDetails;

  factory DetailsDetails.fromJson(Map<String, dynamic> json) =>
      _$DetailsDetailsFromJson(json);
}

@riverpod
class ItemDetails extends _$ItemDetails {
  @override
  Future<Map<int, Details>> build() async {
    final ids = ref.watch(itemIdsProvider);

    final newIds = ids.difference(state.value?.keys.toSet() ?? {});
    final current = state.value ?? {};

    if (newIds.isNotEmpty) {
      final response = await http.get(Api.items(newIds.toList()));

      final data = jsonDecode(response.body) as List<dynamic>;

      current.addAll(Map.fromEntries(
        data.map((e) => Details.fromJson(e)).map((e) => MapEntry(e.id, e)),
      ));
    }

    return current;
  }
}
