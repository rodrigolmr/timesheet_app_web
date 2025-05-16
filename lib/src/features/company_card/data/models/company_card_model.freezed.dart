// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'company_card_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CompanyCardModel _$CompanyCardModelFromJson(Map<String, dynamic> json) {
  return _CompanyCardModel.fromJson(json);
}

/// @nodoc
mixin _$CompanyCardModel {
  // Campos do sistema (não visíveis ao usuário final)
  String get id =>
      throw _privateConstructorUsedError; // Campos visíveis ao usuário
  String get holderName => throw _privateConstructorUsedError;
  String get lastFourDigits => throw _privateConstructorUsedError;
  bool get isActive =>
      throw _privateConstructorUsedError; // Campos de controle (sistema)
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this CompanyCardModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CompanyCardModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompanyCardModelCopyWith<CompanyCardModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompanyCardModelCopyWith<$Res> {
  factory $CompanyCardModelCopyWith(
    CompanyCardModel value,
    $Res Function(CompanyCardModel) then,
  ) = _$CompanyCardModelCopyWithImpl<$Res, CompanyCardModel>;
  @useResult
  $Res call({
    String id,
    String holderName,
    String lastFourDigits,
    bool isActive,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$CompanyCardModelCopyWithImpl<$Res, $Val extends CompanyCardModel>
    implements $CompanyCardModelCopyWith<$Res> {
  _$CompanyCardModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompanyCardModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? holderName = null,
    Object? lastFourDigits = null,
    Object? isActive = null,
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
            holderName:
                null == holderName
                    ? _value.holderName
                    : holderName // ignore: cast_nullable_to_non_nullable
                        as String,
            lastFourDigits:
                null == lastFourDigits
                    ? _value.lastFourDigits
                    : lastFourDigits // ignore: cast_nullable_to_non_nullable
                        as String,
            isActive:
                null == isActive
                    ? _value.isActive
                    : isActive // ignore: cast_nullable_to_non_nullable
                        as bool,
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
abstract class _$$CompanyCardModelImplCopyWith<$Res>
    implements $CompanyCardModelCopyWith<$Res> {
  factory _$$CompanyCardModelImplCopyWith(
    _$CompanyCardModelImpl value,
    $Res Function(_$CompanyCardModelImpl) then,
  ) = __$$CompanyCardModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String holderName,
    String lastFourDigits,
    bool isActive,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$CompanyCardModelImplCopyWithImpl<$Res>
    extends _$CompanyCardModelCopyWithImpl<$Res, _$CompanyCardModelImpl>
    implements _$$CompanyCardModelImplCopyWith<$Res> {
  __$$CompanyCardModelImplCopyWithImpl(
    _$CompanyCardModelImpl _value,
    $Res Function(_$CompanyCardModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CompanyCardModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? holderName = null,
    Object? lastFourDigits = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$CompanyCardModelImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        holderName:
            null == holderName
                ? _value.holderName
                : holderName // ignore: cast_nullable_to_non_nullable
                    as String,
        lastFourDigits:
            null == lastFourDigits
                ? _value.lastFourDigits
                : lastFourDigits // ignore: cast_nullable_to_non_nullable
                    as String,
        isActive:
            null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                    as bool,
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
class _$CompanyCardModelImpl extends _CompanyCardModel {
  const _$CompanyCardModelImpl({
    required this.id,
    required this.holderName,
    required this.lastFourDigits,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  }) : super._();

  factory _$CompanyCardModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompanyCardModelImplFromJson(json);

  // Campos do sistema (não visíveis ao usuário final)
  @override
  final String id;
  // Campos visíveis ao usuário
  @override
  final String holderName;
  @override
  final String lastFourDigits;
  @override
  final bool isActive;
  // Campos de controle (sistema)
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'CompanyCardModel(id: $id, holderName: $holderName, lastFourDigits: $lastFourDigits, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompanyCardModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.holderName, holderName) ||
                other.holderName == holderName) &&
            (identical(other.lastFourDigits, lastFourDigits) ||
                other.lastFourDigits == lastFourDigits) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
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
    holderName,
    lastFourDigits,
    isActive,
    createdAt,
    updatedAt,
  );

  /// Create a copy of CompanyCardModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompanyCardModelImplCopyWith<_$CompanyCardModelImpl> get copyWith =>
      __$$CompanyCardModelImplCopyWithImpl<_$CompanyCardModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CompanyCardModelImplToJson(this);
  }
}

abstract class _CompanyCardModel extends CompanyCardModel {
  const factory _CompanyCardModel({
    required final String id,
    required final String holderName,
    required final String lastFourDigits,
    required final bool isActive,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$CompanyCardModelImpl;
  const _CompanyCardModel._() : super._();

  factory _CompanyCardModel.fromJson(Map<String, dynamic> json) =
      _$CompanyCardModelImpl.fromJson;

  // Campos do sistema (não visíveis ao usuário final)
  @override
  String get id; // Campos visíveis ao usuário
  @override
  String get holderName;
  @override
  String get lastFourDigits;
  @override
  bool get isActive; // Campos de controle (sistema)
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of CompanyCardModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompanyCardModelImplCopyWith<_$CompanyCardModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
