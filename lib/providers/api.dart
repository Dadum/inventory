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
class Token extends _$Token {
  @override
  Future<String> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  Future<void> set({required String token}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    state = AsyncValue.data(token);
  }
}

@riverpod
Future<List<String>> characters(CharactersRef ref) async {
  final token = ref.watch(tokenProvider);
  final response = await http.get(
    Api.characters,
    headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.value}',
    },
  );

  if (response.statusCode != HttpStatus.ok) {
    return [];
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
    ItemDetails? details,
  }) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}

@freezed
class ItemDetails with _$ItemDetails {
  const factory ItemDetails({
    required int id,
    required String name,
    required String icon,
  }) = _ItemDetails;

  factory ItemDetails.fromJson(Map<String, dynamic> json) =>
      _$ItemDetailsFromJson(json);
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
Stream<Map<String, List<Item>>> items(ItemsRef ref) async* {
  final token = ref.watch(tokenProvider);
  final characters = ref.watch(charactersProvider);
  final items = <String, List<Item>>{};

  for (final character in characters.value ?? []) {
    final response = await http.get(
      Api.inventory(character),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${token.value}',
      },
    );

    if (response.statusCode == HttpStatus.ok) {
      final inventory = Inventory.fromJson(jsonDecode(response.body));
      items[character] = inventory.bags.expand((e) => e.items).toList();

      yield items;
    }
  }
}

@riverpod
Stream<Map<int, ItemDetails>> itemDetails(ItemDetailsRef ref) async* {
  final items = ref.watch(itemsProvider);
  final details = <int, ItemDetails>{};

  final ids =
      items.value?.values.expand((e) => e).map((e) => e.id).toSet() ?? {};

  final response = await http.get(Api.items(ids.toList()));
  if (response.statusCode == HttpStatus.ok) {
    final data = jsonDecode(response.body) as List<dynamic>;
    final items =
        data.map((e) => ItemDetails.fromJson(e)).map((e) => MapEntry(e.id, e));

    yield Map.fromEntries(items);
  }
}
