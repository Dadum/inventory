// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ItemImpl _$$ItemImplFromJson(Map<String, dynamic> json) => _$ItemImpl(
      id: (json['id'] as num).toInt(),
      count: (json['count'] as num).toInt(),
      details: json['details'] == null
          ? null
          : ItemDetails.fromJson(json['details'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ItemImplToJson(_$ItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'count': instance.count,
      'details': instance.details,
    };

_$ItemDetailsImpl _$$ItemDetailsImplFromJson(Map<String, dynamic> json) =>
    _$ItemDetailsImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      icon: json['icon'] as String,
    );

Map<String, dynamic> _$$ItemDetailsImplToJson(_$ItemDetailsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
    };

_$BagImpl _$$BagImplFromJson(Map<String, dynamic> json) => _$BagImpl(
      id: (json['id'] as num).toInt(),
      inventory: (json['inventory'] as List<dynamic>)
          .map((e) =>
              e == null ? null : Item.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$BagImplToJson(_$BagImpl instance) => <String, dynamic>{
      'id': instance.id,
      'inventory': instance.inventory,
    };

_$InventoryImpl _$$InventoryImplFromJson(Map<String, dynamic> json) =>
    _$InventoryImpl(
      bags: (json['bags'] as List<dynamic>)
          .map((e) => Bag.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$InventoryImplToJson(_$InventoryImpl instance) =>
    <String, dynamic>{
      'bags': instance.bags,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$charactersHash() => r'48819c17e8ba749eda84dcac9719e6489a13071e';

/// See also [characters].
@ProviderFor(characters)
final charactersProvider = AutoDisposeFutureProvider<List<String>>.internal(
  characters,
  name: r'charactersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$charactersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CharactersRef = AutoDisposeFutureProviderRef<List<String>>;
String _$itemsHash() => r'8e67ee4cb6a798c6c378a7aa46a6ba709de0c1e9';

/// See also [items].
@ProviderFor(items)
final itemsProvider =
    AutoDisposeStreamProvider<Map<String, List<Item>>>.internal(
  items,
  name: r'itemsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$itemsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ItemsRef = AutoDisposeStreamProviderRef<Map<String, List<Item>>>;
String _$itemDetailsHash() => r'38d4137ef8197d376a7987f0ce03807f1a715df7';

/// See also [itemDetails].
@ProviderFor(itemDetails)
final itemDetailsProvider =
    AutoDisposeStreamProvider<Map<int, ItemDetails>>.internal(
  itemDetails,
  name: r'itemDetailsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$itemDetailsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ItemDetailsRef = AutoDisposeStreamProviderRef<Map<int, ItemDetails>>;
String _$tokenHash() => r'ee8bd178c12f67f2c99326c83ddf22eb26d7f217';

/// See also [Token].
@ProviderFor(Token)
final tokenProvider = AutoDisposeAsyncNotifierProvider<Token, String>.internal(
  Token.new,
  name: r'tokenProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$tokenHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Token = AutoDisposeAsyncNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
