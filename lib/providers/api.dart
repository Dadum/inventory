import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart' as http;
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

  static Uri bank(String key) => autheticated('account/bank', key);
  static Uri materials(String key) => autheticated('account/materials', key);

  static Uri item(int id) => Uri.https(url, '/v2/items/$id');

  static Uri items(Iterable<int> ids) =>
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

  return (jsonDecode(response.body) as List<dynamic>)
      .map((e) => e as String)
      .toList();
}

@freezed
class Item with _$Item {
  const factory Item({
    required int id,
    required int count,
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
    required List<Item?> inventory,
  }) = _Bag;

  factory Bag.fromJson(Map<String, dynamic> json) => _$BagFromJson(json);

  List<Item?> get items => inventory;
}

@freezed
class InventoryResponse with _$InventoryResponse {
  const factory InventoryResponse({
    required List<Bag> bags,
  }) = _InventoryResponse;

  factory InventoryResponse.fromJson(Map<String, dynamic> json) =>
      _$InventoryResponseFromJson(json);
}

@riverpod
class Inventory extends _$Inventory {
  @override
  Future<Iterable<Item?>> build({required String character}) async {
    final key = ref.watch(keyProvider);

    final response = await http.get(
      Api.inventory(character, key.value ?? ''),
    );

    final inventory = InventoryResponse.fromJson(jsonDecode(response.body))
        .bags
        .expand((e) => e.items)
        .where(
          (e) => e == null || e.count > 0,
        );

    ref.keepAlive();

    return inventory;
  }
}

@riverpod
Future<Iterable<Item?>> bank(BankRef ref) async {
  final key = ref.watch(keyProvider);

  final response = await http.get(
    Api.bank(key.value ?? ''),
  );

  return (jsonDecode(response.body) as List<dynamic>)
      .map((e) => e == null ? null : Item.fromJson(e as Map<String, dynamic>));
}

@riverpod
Future<Iterable<Item?>> materials(MaterialsRef ref) async {
  final key = ref.watch(keyProvider);

  final response = await http.get(
    Api.materials(key.value ?? ''),
  );

  return (jsonDecode(response.body) as List<dynamic>)
      .map((e) => Item.fromJson(e as Map<String, dynamic>))
      .where((e) => e.count > 0);
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
    VeryDetails? details,
  }) = _Details;

  factory Details.fromJson(Map<String, dynamic> json) =>
      _$DetailsFromJson(json);
}

@freezed
class VeryDetails with _$VeryDetails {
  const factory VeryDetails({
    String? type,
    String? description,
    int? minPower,
    int? maxPower,
    int? defense,
  }) = _DetailsDetails;

  factory VeryDetails.fromJson(Map<String, dynamic> json) =>
      _$VeryDetailsFromJson(json);
}

@riverpod
Future<Details> details(DetailsRef ref, int id) async {
  var didDispose = false;
  ref.onDispose(() => didDispose = true);

  await Future<void>.delayed(const Duration(milliseconds: 500));

  if (didDispose) {
    throw Exception('Cancelled');
  }

  final client = http.Client();
  ref.onDispose(client.close);

  final response = await client.get(Api.item(id));

  final json = jsonDecode(response.body) as Map<String, dynamic>;

  ref.keepAlive();

  return Details.fromJson(json);
}
