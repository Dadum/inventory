// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Item _$ItemFromJson(Map<String, dynamic> json) {
  return _Item.fromJson(json);
}

/// @nodoc
mixin _$Item {
  int get id => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  ItemDetails? get details => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ItemCopyWith<Item> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItemCopyWith<$Res> {
  factory $ItemCopyWith(Item value, $Res Function(Item) then) =
      _$ItemCopyWithImpl<$Res, Item>;
  @useResult
  $Res call({int id, int count, ItemDetails? details});

  $ItemDetailsCopyWith<$Res>? get details;
}

/// @nodoc
class _$ItemCopyWithImpl<$Res, $Val extends Item>
    implements $ItemCopyWith<$Res> {
  _$ItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? count = null,
    Object? details = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      details: freezed == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as ItemDetails?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ItemDetailsCopyWith<$Res>? get details {
    if (_value.details == null) {
      return null;
    }

    return $ItemDetailsCopyWith<$Res>(_value.details!, (value) {
      return _then(_value.copyWith(details: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ItemImplCopyWith<$Res> implements $ItemCopyWith<$Res> {
  factory _$$ItemImplCopyWith(
          _$ItemImpl value, $Res Function(_$ItemImpl) then) =
      __$$ItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, int count, ItemDetails? details});

  @override
  $ItemDetailsCopyWith<$Res>? get details;
}

/// @nodoc
class __$$ItemImplCopyWithImpl<$Res>
    extends _$ItemCopyWithImpl<$Res, _$ItemImpl>
    implements _$$ItemImplCopyWith<$Res> {
  __$$ItemImplCopyWithImpl(_$ItemImpl _value, $Res Function(_$ItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? count = null,
    Object? details = freezed,
  }) {
    return _then(_$ItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      details: freezed == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as ItemDetails?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ItemImpl implements _Item {
  const _$ItemImpl({required this.id, required this.count, this.details});

  factory _$ItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ItemImplFromJson(json);

  @override
  final int id;
  @override
  final int count;
  @override
  final ItemDetails? details;

  @override
  String toString() {
    return 'Item(id: $id, count: $count, details: $details)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.details, details) || other.details == details));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, count, details);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ItemImplCopyWith<_$ItemImpl> get copyWith =>
      __$$ItemImplCopyWithImpl<_$ItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ItemImplToJson(
      this,
    );
  }
}

abstract class _Item implements Item {
  const factory _Item(
      {required final int id,
      required final int count,
      final ItemDetails? details}) = _$ItemImpl;

  factory _Item.fromJson(Map<String, dynamic> json) = _$ItemImpl.fromJson;

  @override
  int get id;
  @override
  int get count;
  @override
  ItemDetails? get details;
  @override
  @JsonKey(ignore: true)
  _$$ItemImplCopyWith<_$ItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ItemDetails _$ItemDetailsFromJson(Map<String, dynamic> json) {
  return _ItemDetails.fromJson(json);
}

/// @nodoc
mixin _$ItemDetails {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ItemDetailsCopyWith<ItemDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItemDetailsCopyWith<$Res> {
  factory $ItemDetailsCopyWith(
          ItemDetails value, $Res Function(ItemDetails) then) =
      _$ItemDetailsCopyWithImpl<$Res, ItemDetails>;
  @useResult
  $Res call({int id, String name, String icon});
}

/// @nodoc
class _$ItemDetailsCopyWithImpl<$Res, $Val extends ItemDetails>
    implements $ItemDetailsCopyWith<$Res> {
  _$ItemDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? icon = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ItemDetailsImplCopyWith<$Res>
    implements $ItemDetailsCopyWith<$Res> {
  factory _$$ItemDetailsImplCopyWith(
          _$ItemDetailsImpl value, $Res Function(_$ItemDetailsImpl) then) =
      __$$ItemDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, String icon});
}

/// @nodoc
class __$$ItemDetailsImplCopyWithImpl<$Res>
    extends _$ItemDetailsCopyWithImpl<$Res, _$ItemDetailsImpl>
    implements _$$ItemDetailsImplCopyWith<$Res> {
  __$$ItemDetailsImplCopyWithImpl(
      _$ItemDetailsImpl _value, $Res Function(_$ItemDetailsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? icon = null,
  }) {
    return _then(_$ItemDetailsImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ItemDetailsImpl implements _ItemDetails {
  const _$ItemDetailsImpl(
      {required this.id, required this.name, required this.icon});

  factory _$ItemDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ItemDetailsImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String icon;

  @override
  String toString() {
    return 'ItemDetails(id: $id, name: $name, icon: $icon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItemDetailsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.icon, icon) || other.icon == icon));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, icon);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ItemDetailsImplCopyWith<_$ItemDetailsImpl> get copyWith =>
      __$$ItemDetailsImplCopyWithImpl<_$ItemDetailsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ItemDetailsImplToJson(
      this,
    );
  }
}

abstract class _ItemDetails implements ItemDetails {
  const factory _ItemDetails(
      {required final int id,
      required final String name,
      required final String icon}) = _$ItemDetailsImpl;

  factory _ItemDetails.fromJson(Map<String, dynamic> json) =
      _$ItemDetailsImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get icon;
  @override
  @JsonKey(ignore: true)
  _$$ItemDetailsImplCopyWith<_$ItemDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Bag _$BagFromJson(Map<String, dynamic> json) {
  return _Bag.fromJson(json);
}

/// @nodoc
mixin _$Bag {
  int get id => throw _privateConstructorUsedError;
  List<Item?> get inventory => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BagCopyWith<Bag> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BagCopyWith<$Res> {
  factory $BagCopyWith(Bag value, $Res Function(Bag) then) =
      _$BagCopyWithImpl<$Res, Bag>;
  @useResult
  $Res call({int id, List<Item?> inventory});
}

/// @nodoc
class _$BagCopyWithImpl<$Res, $Val extends Bag> implements $BagCopyWith<$Res> {
  _$BagCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? inventory = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      inventory: null == inventory
          ? _value.inventory
          : inventory // ignore: cast_nullable_to_non_nullable
              as List<Item?>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BagImplCopyWith<$Res> implements $BagCopyWith<$Res> {
  factory _$$BagImplCopyWith(_$BagImpl value, $Res Function(_$BagImpl) then) =
      __$$BagImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, List<Item?> inventory});
}

/// @nodoc
class __$$BagImplCopyWithImpl<$Res> extends _$BagCopyWithImpl<$Res, _$BagImpl>
    implements _$$BagImplCopyWith<$Res> {
  __$$BagImplCopyWithImpl(_$BagImpl _value, $Res Function(_$BagImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? inventory = null,
  }) {
    return _then(_$BagImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      inventory: null == inventory
          ? _value._inventory
          : inventory // ignore: cast_nullable_to_non_nullable
              as List<Item?>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BagImpl extends _Bag {
  const _$BagImpl({required this.id, required final List<Item?> inventory})
      : _inventory = inventory,
        super._();

  factory _$BagImpl.fromJson(Map<String, dynamic> json) =>
      _$$BagImplFromJson(json);

  @override
  final int id;
  final List<Item?> _inventory;
  @override
  List<Item?> get inventory {
    if (_inventory is EqualUnmodifiableListView) return _inventory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_inventory);
  }

  @override
  String toString() {
    return 'Bag(id: $id, inventory: $inventory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BagImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality()
                .equals(other._inventory, _inventory));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, const DeepCollectionEquality().hash(_inventory));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BagImplCopyWith<_$BagImpl> get copyWith =>
      __$$BagImplCopyWithImpl<_$BagImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BagImplToJson(
      this,
    );
  }
}

abstract class _Bag extends Bag {
  const factory _Bag(
      {required final int id,
      required final List<Item?> inventory}) = _$BagImpl;
  const _Bag._() : super._();

  factory _Bag.fromJson(Map<String, dynamic> json) = _$BagImpl.fromJson;

  @override
  int get id;
  @override
  List<Item?> get inventory;
  @override
  @JsonKey(ignore: true)
  _$$BagImplCopyWith<_$BagImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Inventory _$InventoryFromJson(Map<String, dynamic> json) {
  return _Inventory.fromJson(json);
}

/// @nodoc
mixin _$Inventory {
  List<Bag> get bags => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InventoryCopyWith<Inventory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryCopyWith<$Res> {
  factory $InventoryCopyWith(Inventory value, $Res Function(Inventory) then) =
      _$InventoryCopyWithImpl<$Res, Inventory>;
  @useResult
  $Res call({List<Bag> bags});
}

/// @nodoc
class _$InventoryCopyWithImpl<$Res, $Val extends Inventory>
    implements $InventoryCopyWith<$Res> {
  _$InventoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bags = null,
  }) {
    return _then(_value.copyWith(
      bags: null == bags
          ? _value.bags
          : bags // ignore: cast_nullable_to_non_nullable
              as List<Bag>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InventoryImplCopyWith<$Res>
    implements $InventoryCopyWith<$Res> {
  factory _$$InventoryImplCopyWith(
          _$InventoryImpl value, $Res Function(_$InventoryImpl) then) =
      __$$InventoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Bag> bags});
}

/// @nodoc
class __$$InventoryImplCopyWithImpl<$Res>
    extends _$InventoryCopyWithImpl<$Res, _$InventoryImpl>
    implements _$$InventoryImplCopyWith<$Res> {
  __$$InventoryImplCopyWithImpl(
      _$InventoryImpl _value, $Res Function(_$InventoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bags = null,
  }) {
    return _then(_$InventoryImpl(
      bags: null == bags
          ? _value._bags
          : bags // ignore: cast_nullable_to_non_nullable
              as List<Bag>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InventoryImpl implements _Inventory {
  const _$InventoryImpl({required final List<Bag> bags}) : _bags = bags;

  factory _$InventoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$InventoryImplFromJson(json);

  final List<Bag> _bags;
  @override
  List<Bag> get bags {
    if (_bags is EqualUnmodifiableListView) return _bags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bags);
  }

  @override
  String toString() {
    return 'Inventory(bags: $bags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryImpl &&
            const DeepCollectionEquality().equals(other._bags, _bags));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_bags));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryImplCopyWith<_$InventoryImpl> get copyWith =>
      __$$InventoryImplCopyWithImpl<_$InventoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InventoryImplToJson(
      this,
    );
  }
}

abstract class _Inventory implements Inventory {
  const factory _Inventory({required final List<Bag> bags}) = _$InventoryImpl;

  factory _Inventory.fromJson(Map<String, dynamic> json) =
      _$InventoryImpl.fromJson;

  @override
  List<Bag> get bags;
  @override
  @JsonKey(ignore: true)
  _$$InventoryImplCopyWith<_$InventoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
