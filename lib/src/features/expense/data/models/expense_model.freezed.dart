// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ExpenseModel _$ExpenseModelFromJson(Map<String, dynamic> json) {
  return _ExpenseModel.fromJson(json);
}

/// @nodoc
mixin _$ExpenseModel {
  // Campos do sistema (não visíveis ao usuário)
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get cardId =>
      throw _privateConstructorUsedError; // Campos visíveis ao usuário
  double get amount => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError; // Campos de status
  ExpenseStatus get status => throw _privateConstructorUsedError;
  String? get reviewerNote => throw _privateConstructorUsedError;
  DateTime? get reviewedAt =>
      throw _privateConstructorUsedError; // Campos de controle (sistema)
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ExpenseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpenseModelCopyWith<ExpenseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseModelCopyWith<$Res> {
  factory $ExpenseModelCopyWith(
    ExpenseModel value,
    $Res Function(ExpenseModel) then,
  ) = _$ExpenseModelCopyWithImpl<$Res, ExpenseModel>;
  @useResult
  $Res call({
    String id,
    String userId,
    String cardId,
    double amount,
    DateTime date,
    String description,
    String imageUrl,
    ExpenseStatus status,
    String? reviewerNote,
    DateTime? reviewedAt,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$ExpenseModelCopyWithImpl<$Res, $Val extends ExpenseModel>
    implements $ExpenseModelCopyWith<$Res> {
  _$ExpenseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? cardId = null,
    Object? amount = null,
    Object? date = null,
    Object? description = null,
    Object? imageUrl = null,
    Object? status = null,
    Object? reviewerNote = freezed,
    Object? reviewedAt = freezed,
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
            userId:
                null == userId
                    ? _value.userId
                    : userId // ignore: cast_nullable_to_non_nullable
                        as String,
            cardId:
                null == cardId
                    ? _value.cardId
                    : cardId // ignore: cast_nullable_to_non_nullable
                        as String,
            amount:
                null == amount
                    ? _value.amount
                    : amount // ignore: cast_nullable_to_non_nullable
                        as double,
            date:
                null == date
                    ? _value.date
                    : date // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            description:
                null == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String,
            imageUrl:
                null == imageUrl
                    ? _value.imageUrl
                    : imageUrl // ignore: cast_nullable_to_non_nullable
                        as String,
            status:
                null == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as ExpenseStatus,
            reviewerNote:
                freezed == reviewerNote
                    ? _value.reviewerNote
                    : reviewerNote // ignore: cast_nullable_to_non_nullable
                        as String?,
            reviewedAt:
                freezed == reviewedAt
                    ? _value.reviewedAt
                    : reviewedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
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
abstract class _$$ExpenseModelImplCopyWith<$Res>
    implements $ExpenseModelCopyWith<$Res> {
  factory _$$ExpenseModelImplCopyWith(
    _$ExpenseModelImpl value,
    $Res Function(_$ExpenseModelImpl) then,
  ) = __$$ExpenseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String cardId,
    double amount,
    DateTime date,
    String description,
    String imageUrl,
    ExpenseStatus status,
    String? reviewerNote,
    DateTime? reviewedAt,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$ExpenseModelImplCopyWithImpl<$Res>
    extends _$ExpenseModelCopyWithImpl<$Res, _$ExpenseModelImpl>
    implements _$$ExpenseModelImplCopyWith<$Res> {
  __$$ExpenseModelImplCopyWithImpl(
    _$ExpenseModelImpl _value,
    $Res Function(_$ExpenseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? cardId = null,
    Object? amount = null,
    Object? date = null,
    Object? description = null,
    Object? imageUrl = null,
    Object? status = null,
    Object? reviewerNote = freezed,
    Object? reviewedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$ExpenseModelImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        userId:
            null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                    as String,
        cardId:
            null == cardId
                ? _value.cardId
                : cardId // ignore: cast_nullable_to_non_nullable
                    as String,
        amount:
            null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                    as double,
        date:
            null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        description:
            null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String,
        imageUrl:
            null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                    as String,
        status:
            null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as ExpenseStatus,
        reviewerNote:
            freezed == reviewerNote
                ? _value.reviewerNote
                : reviewerNote // ignore: cast_nullable_to_non_nullable
                    as String?,
        reviewedAt:
            freezed == reviewedAt
                ? _value.reviewedAt
                : reviewedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
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
class _$ExpenseModelImpl extends _ExpenseModel {
  const _$ExpenseModelImpl({
    required this.id,
    required this.userId,
    required this.cardId,
    required this.amount,
    required this.date,
    required this.description,
    required this.imageUrl,
    this.status = ExpenseStatus.pending,
    this.reviewerNote,
    this.reviewedAt,
    required this.createdAt,
    required this.updatedAt,
  }) : super._();

  factory _$ExpenseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpenseModelImplFromJson(json);

  // Campos do sistema (não visíveis ao usuário)
  @override
  final String id;
  @override
  final String userId;
  @override
  final String cardId;
  // Campos visíveis ao usuário
  @override
  final double amount;
  @override
  final DateTime date;
  @override
  final String description;
  @override
  final String imageUrl;
  // Campos de status
  @override
  @JsonKey()
  final ExpenseStatus status;
  @override
  final String? reviewerNote;
  @override
  final DateTime? reviewedAt;
  // Campos de controle (sistema)
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ExpenseModel(id: $id, userId: $userId, cardId: $cardId, amount: $amount, date: $date, description: $description, imageUrl: $imageUrl, status: $status, reviewerNote: $reviewerNote, reviewedAt: $reviewedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.cardId, cardId) || other.cardId == cardId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.reviewerNote, reviewerNote) ||
                other.reviewerNote == reviewerNote) &&
            (identical(other.reviewedAt, reviewedAt) ||
                other.reviewedAt == reviewedAt) &&
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
    userId,
    cardId,
    amount,
    date,
    description,
    imageUrl,
    status,
    reviewerNote,
    reviewedAt,
    createdAt,
    updatedAt,
  );

  /// Create a copy of ExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseModelImplCopyWith<_$ExpenseModelImpl> get copyWith =>
      __$$ExpenseModelImplCopyWithImpl<_$ExpenseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpenseModelImplToJson(this);
  }
}

abstract class _ExpenseModel extends ExpenseModel {
  const factory _ExpenseModel({
    required final String id,
    required final String userId,
    required final String cardId,
    required final double amount,
    required final DateTime date,
    required final String description,
    required final String imageUrl,
    final ExpenseStatus status,
    final String? reviewerNote,
    final DateTime? reviewedAt,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$ExpenseModelImpl;
  const _ExpenseModel._() : super._();

  factory _ExpenseModel.fromJson(Map<String, dynamic> json) =
      _$ExpenseModelImpl.fromJson;

  // Campos do sistema (não visíveis ao usuário)
  @override
  String get id;
  @override
  String get userId;
  @override
  String get cardId; // Campos visíveis ao usuário
  @override
  double get amount;
  @override
  DateTime get date;
  @override
  String get description;
  @override
  String get imageUrl; // Campos de status
  @override
  ExpenseStatus get status;
  @override
  String? get reviewerNote;
  @override
  DateTime? get reviewedAt; // Campos de controle (sistema)
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of ExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpenseModelImplCopyWith<_$ExpenseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
