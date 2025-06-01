// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pigtail_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PigtailItem _$PigtailItemFromJson(Map<String, dynamic> json) {
  return _PigtailItem.fromJson(json);
}

/// @nodoc
mixin _$PigtailItem {
  String get type => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;

  /// Serializes this PigtailItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PigtailItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PigtailItemCopyWith<PigtailItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PigtailItemCopyWith<$Res> {
  factory $PigtailItemCopyWith(
    PigtailItem value,
    $Res Function(PigtailItem) then,
  ) = _$PigtailItemCopyWithImpl<$Res, PigtailItem>;
  @useResult
  $Res call({String type, int quantity});
}

/// @nodoc
class _$PigtailItemCopyWithImpl<$Res, $Val extends PigtailItem>
    implements $PigtailItemCopyWith<$Res> {
  _$PigtailItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PigtailItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? type = null, Object? quantity = null}) {
    return _then(
      _value.copyWith(
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as String,
            quantity:
                null == quantity
                    ? _value.quantity
                    : quantity // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PigtailItemImplCopyWith<$Res>
    implements $PigtailItemCopyWith<$Res> {
  factory _$$PigtailItemImplCopyWith(
    _$PigtailItemImpl value,
    $Res Function(_$PigtailItemImpl) then,
  ) = __$$PigtailItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, int quantity});
}

/// @nodoc
class __$$PigtailItemImplCopyWithImpl<$Res>
    extends _$PigtailItemCopyWithImpl<$Res, _$PigtailItemImpl>
    implements _$$PigtailItemImplCopyWith<$Res> {
  __$$PigtailItemImplCopyWithImpl(
    _$PigtailItemImpl _value,
    $Res Function(_$PigtailItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PigtailItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? type = null, Object? quantity = null}) {
    return _then(
      _$PigtailItemImpl(
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as String,
        quantity:
            null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PigtailItemImpl implements _PigtailItem {
  const _$PigtailItemImpl({required this.type, required this.quantity});

  factory _$PigtailItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$PigtailItemImplFromJson(json);

  @override
  final String type;
  @override
  final int quantity;

  @override
  String toString() {
    return 'PigtailItem(type: $type, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PigtailItemImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, quantity);

  /// Create a copy of PigtailItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PigtailItemImplCopyWith<_$PigtailItemImpl> get copyWith =>
      __$$PigtailItemImplCopyWithImpl<_$PigtailItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PigtailItemImplToJson(this);
  }
}

abstract class _PigtailItem implements PigtailItem {
  const factory _PigtailItem({
    required final String type,
    required final int quantity,
  }) = _$PigtailItemImpl;

  factory _PigtailItem.fromJson(Map<String, dynamic> json) =
      _$PigtailItemImpl.fromJson;

  @override
  String get type;
  @override
  int get quantity;

  /// Create a copy of PigtailItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PigtailItemImplCopyWith<_$PigtailItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PigtailModel _$PigtailModelFromJson(Map<String, dynamic> json) {
  return _PigtailModel.fromJson(json);
}

/// @nodoc
mixin _$PigtailModel {
  String get id => throw _privateConstructorUsedError;
  String get jobName => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  List<PigtailItem> get pigtailItems => throw _privateConstructorUsedError;
  String get installedBy => throw _privateConstructorUsedError;
  DateTime get installedDate => throw _privateConstructorUsedError;
  bool get isRemoved => throw _privateConstructorUsedError;
  DateTime? get removedDate => throw _privateConstructorUsedError;
  String? get removedBy => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this PigtailModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PigtailModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PigtailModelCopyWith<PigtailModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PigtailModelCopyWith<$Res> {
  factory $PigtailModelCopyWith(
    PigtailModel value,
    $Res Function(PigtailModel) then,
  ) = _$PigtailModelCopyWithImpl<$Res, PigtailModel>;
  @useResult
  $Res call({
    String id,
    String jobName,
    String address,
    List<PigtailItem> pigtailItems,
    String installedBy,
    DateTime installedDate,
    bool isRemoved,
    DateTime? removedDate,
    String? removedBy,
    String? notes,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$PigtailModelCopyWithImpl<$Res, $Val extends PigtailModel>
    implements $PigtailModelCopyWith<$Res> {
  _$PigtailModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PigtailModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? jobName = null,
    Object? address = null,
    Object? pigtailItems = null,
    Object? installedBy = null,
    Object? installedDate = null,
    Object? isRemoved = null,
    Object? removedDate = freezed,
    Object? removedBy = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            jobName:
                null == jobName
                    ? _value.jobName
                    : jobName // ignore: cast_nullable_to_non_nullable
                        as String,
            address:
                null == address
                    ? _value.address
                    : address // ignore: cast_nullable_to_non_nullable
                        as String,
            pigtailItems:
                null == pigtailItems
                    ? _value.pigtailItems
                    : pigtailItems // ignore: cast_nullable_to_non_nullable
                        as List<PigtailItem>,
            installedBy:
                null == installedBy
                    ? _value.installedBy
                    : installedBy // ignore: cast_nullable_to_non_nullable
                        as String,
            installedDate:
                null == installedDate
                    ? _value.installedDate
                    : installedDate // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            isRemoved:
                null == isRemoved
                    ? _value.isRemoved
                    : isRemoved // ignore: cast_nullable_to_non_nullable
                        as bool,
            removedDate:
                freezed == removedDate
                    ? _value.removedDate
                    : removedDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            removedBy:
                freezed == removedBy
                    ? _value.removedBy
                    : removedBy // ignore: cast_nullable_to_non_nullable
                        as String?,
            notes:
                freezed == notes
                    ? _value.notes
                    : notes // ignore: cast_nullable_to_non_nullable
                        as String?,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            updatedAt:
                null == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PigtailModelImplCopyWith<$Res>
    implements $PigtailModelCopyWith<$Res> {
  factory _$$PigtailModelImplCopyWith(
    _$PigtailModelImpl value,
    $Res Function(_$PigtailModelImpl) then,
  ) = __$$PigtailModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String jobName,
    String address,
    List<PigtailItem> pigtailItems,
    String installedBy,
    DateTime installedDate,
    bool isRemoved,
    DateTime? removedDate,
    String? removedBy,
    String? notes,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$PigtailModelImplCopyWithImpl<$Res>
    extends _$PigtailModelCopyWithImpl<$Res, _$PigtailModelImpl>
    implements _$$PigtailModelImplCopyWith<$Res> {
  __$$PigtailModelImplCopyWithImpl(
    _$PigtailModelImpl _value,
    $Res Function(_$PigtailModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PigtailModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? jobName = null,
    Object? address = null,
    Object? pigtailItems = null,
    Object? installedBy = null,
    Object? installedDate = null,
    Object? isRemoved = null,
    Object? removedDate = freezed,
    Object? removedBy = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$PigtailModelImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        jobName:
            null == jobName
                ? _value.jobName
                : jobName // ignore: cast_nullable_to_non_nullable
                    as String,
        address:
            null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                    as String,
        pigtailItems:
            null == pigtailItems
                ? _value._pigtailItems
                : pigtailItems // ignore: cast_nullable_to_non_nullable
                    as List<PigtailItem>,
        installedBy:
            null == installedBy
                ? _value.installedBy
                : installedBy // ignore: cast_nullable_to_non_nullable
                    as String,
        installedDate:
            null == installedDate
                ? _value.installedDate
                : installedDate // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        isRemoved:
            null == isRemoved
                ? _value.isRemoved
                : isRemoved // ignore: cast_nullable_to_non_nullable
                    as bool,
        removedDate:
            freezed == removedDate
                ? _value.removedDate
                : removedDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        removedBy:
            freezed == removedBy
                ? _value.removedBy
                : removedBy // ignore: cast_nullable_to_non_nullable
                    as String?,
        notes:
            freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                    as String?,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        updatedAt:
            null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PigtailModelImpl extends _PigtailModel {
  const _$PigtailModelImpl({
    required this.id,
    required this.jobName,
    required this.address,
    required final List<PigtailItem> pigtailItems,
    required this.installedBy,
    required this.installedDate,
    required this.isRemoved,
    this.removedDate,
    this.removedBy,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  }) : _pigtailItems = pigtailItems,
       super._();

  factory _$PigtailModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PigtailModelImplFromJson(json);

  @override
  final String id;
  @override
  final String jobName;
  @override
  final String address;
  final List<PigtailItem> _pigtailItems;
  @override
  List<PigtailItem> get pigtailItems {
    if (_pigtailItems is EqualUnmodifiableListView) return _pigtailItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pigtailItems);
  }

  @override
  final String installedBy;
  @override
  final DateTime installedDate;
  @override
  final bool isRemoved;
  @override
  final DateTime? removedDate;
  @override
  final String? removedBy;
  @override
  final String? notes;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'PigtailModel(id: $id, jobName: $jobName, address: $address, pigtailItems: $pigtailItems, installedBy: $installedBy, installedDate: $installedDate, isRemoved: $isRemoved, removedDate: $removedDate, removedBy: $removedBy, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PigtailModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.jobName, jobName) || other.jobName == jobName) &&
            (identical(other.address, address) || other.address == address) &&
            const DeepCollectionEquality().equals(
              other._pigtailItems,
              _pigtailItems,
            ) &&
            (identical(other.installedBy, installedBy) ||
                other.installedBy == installedBy) &&
            (identical(other.installedDate, installedDate) ||
                other.installedDate == installedDate) &&
            (identical(other.isRemoved, isRemoved) ||
                other.isRemoved == isRemoved) &&
            (identical(other.removedDate, removedDate) ||
                other.removedDate == removedDate) &&
            (identical(other.removedBy, removedBy) ||
                other.removedBy == removedBy) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    jobName,
    address,
    const DeepCollectionEquality().hash(_pigtailItems),
    installedBy,
    installedDate,
    isRemoved,
    removedDate,
    removedBy,
    notes,
    createdAt,
    updatedAt,
  );

  /// Create a copy of PigtailModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PigtailModelImplCopyWith<_$PigtailModelImpl> get copyWith =>
      __$$PigtailModelImplCopyWithImpl<_$PigtailModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PigtailModelImplToJson(this);
  }
}

abstract class _PigtailModel extends PigtailModel {
  const factory _PigtailModel({
    required final String id,
    required final String jobName,
    required final String address,
    required final List<PigtailItem> pigtailItems,
    required final String installedBy,
    required final DateTime installedDate,
    required final bool isRemoved,
    final DateTime? removedDate,
    final String? removedBy,
    final String? notes,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$PigtailModelImpl;
  const _PigtailModel._() : super._();

  factory _PigtailModel.fromJson(Map<String, dynamic> json) =
      _$PigtailModelImpl.fromJson;

  @override
  String get id;
  @override
  String get jobName;
  @override
  String get address;
  @override
  List<PigtailItem> get pigtailItems;
  @override
  String get installedBy;
  @override
  DateTime get installedDate;
  @override
  bool get isRemoved;
  @override
  DateTime? get removedDate;
  @override
  String? get removedBy;
  @override
  String? get notes;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of PigtailModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PigtailModelImplCopyWith<_$PigtailModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
