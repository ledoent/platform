// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) {
  return _ChatMessage.fromJson(json);
}

/// @nodoc
mixin _$ChatMessage {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: '_class')
  String get className => throw _privateConstructorUsedError;
  String get attachedTo => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  String? get modifiedBy => throw _privateConstructorUsedError;
  int? get createdOn => throw _privateConstructorUsedError;
  int? get modifiedOn => throw _privateConstructorUsedError;

  /// Serializes this ChatMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatMessageCopyWith<ChatMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageCopyWith<$Res> {
  factory $ChatMessageCopyWith(
    ChatMessage value,
    $Res Function(ChatMessage) then,
  ) = _$ChatMessageCopyWithImpl<$Res, ChatMessage>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    @JsonKey(name: '_class') String className,
    String attachedTo,
    String message,
    String? createdBy,
    String? modifiedBy,
    int? createdOn,
    int? modifiedOn,
  });
}

/// @nodoc
class _$ChatMessageCopyWithImpl<$Res, $Val extends ChatMessage>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? className = null,
    Object? attachedTo = null,
    Object? message = null,
    Object? createdBy = freezed,
    Object? modifiedBy = freezed,
    Object? createdOn = freezed,
    Object? modifiedOn = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            className: null == className
                ? _value.className
                : className // ignore: cast_nullable_to_non_nullable
                      as String,
            attachedTo: null == attachedTo
                ? _value.attachedTo
                : attachedTo // ignore: cast_nullable_to_non_nullable
                      as String,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            createdBy: freezed == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            modifiedBy: freezed == modifiedBy
                ? _value.modifiedBy
                : modifiedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdOn: freezed == createdOn
                ? _value.createdOn
                : createdOn // ignore: cast_nullable_to_non_nullable
                      as int?,
            modifiedOn: freezed == modifiedOn
                ? _value.modifiedOn
                : modifiedOn // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChatMessageImplCopyWith<$Res>
    implements $ChatMessageCopyWith<$Res> {
  factory _$$ChatMessageImplCopyWith(
    _$ChatMessageImpl value,
    $Res Function(_$ChatMessageImpl) then,
  ) = __$$ChatMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    @JsonKey(name: '_class') String className,
    String attachedTo,
    String message,
    String? createdBy,
    String? modifiedBy,
    int? createdOn,
    int? modifiedOn,
  });
}

/// @nodoc
class __$$ChatMessageImplCopyWithImpl<$Res>
    extends _$ChatMessageCopyWithImpl<$Res, _$ChatMessageImpl>
    implements _$$ChatMessageImplCopyWith<$Res> {
  __$$ChatMessageImplCopyWithImpl(
    _$ChatMessageImpl _value,
    $Res Function(_$ChatMessageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? className = null,
    Object? attachedTo = null,
    Object? message = null,
    Object? createdBy = freezed,
    Object? modifiedBy = freezed,
    Object? createdOn = freezed,
    Object? modifiedOn = freezed,
  }) {
    return _then(
      _$ChatMessageImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        className: null == className
            ? _value.className
            : className // ignore: cast_nullable_to_non_nullable
                  as String,
        attachedTo: null == attachedTo
            ? _value.attachedTo
            : attachedTo // ignore: cast_nullable_to_non_nullable
                  as String,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        createdBy: freezed == createdBy
            ? _value.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        modifiedBy: freezed == modifiedBy
            ? _value.modifiedBy
            : modifiedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdOn: freezed == createdOn
            ? _value.createdOn
            : createdOn // ignore: cast_nullable_to_non_nullable
                  as int?,
        modifiedOn: freezed == modifiedOn
            ? _value.modifiedOn
            : modifiedOn // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatMessageImpl implements _ChatMessage {
  const _$ChatMessageImpl({
    @JsonKey(name: '_id') required this.id,
    @JsonKey(name: '_class') required this.className,
    required this.attachedTo,
    required this.message,
    this.createdBy,
    this.modifiedBy,
    this.createdOn,
    this.modifiedOn,
  });

  factory _$ChatMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatMessageImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  @JsonKey(name: '_class')
  final String className;
  @override
  final String attachedTo;
  @override
  final String message;
  @override
  final String? createdBy;
  @override
  final String? modifiedBy;
  @override
  final int? createdOn;
  @override
  final int? modifiedOn;

  @override
  String toString() {
    return 'ChatMessage(id: $id, className: $className, attachedTo: $attachedTo, message: $message, createdBy: $createdBy, modifiedBy: $modifiedBy, createdOn: $createdOn, modifiedOn: $modifiedOn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.className, className) ||
                other.className == className) &&
            (identical(other.attachedTo, attachedTo) ||
                other.attachedTo == attachedTo) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.modifiedBy, modifiedBy) ||
                other.modifiedBy == modifiedBy) &&
            (identical(other.createdOn, createdOn) ||
                other.createdOn == createdOn) &&
            (identical(other.modifiedOn, modifiedOn) ||
                other.modifiedOn == modifiedOn));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    className,
    attachedTo,
    message,
    createdBy,
    modifiedBy,
    createdOn,
    modifiedOn,
  );

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      __$$ChatMessageImplCopyWithImpl<_$ChatMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatMessageImplToJson(this);
  }
}

abstract class _ChatMessage implements ChatMessage {
  const factory _ChatMessage({
    @JsonKey(name: '_id') required final String id,
    @JsonKey(name: '_class') required final String className,
    required final String attachedTo,
    required final String message,
    final String? createdBy,
    final String? modifiedBy,
    final int? createdOn,
    final int? modifiedOn,
  }) = _$ChatMessageImpl;

  factory _ChatMessage.fromJson(Map<String, dynamic> json) =
      _$ChatMessageImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  @JsonKey(name: '_class')
  String get className;
  @override
  String get attachedTo;
  @override
  String get message;
  @override
  String? get createdBy;
  @override
  String? get modifiedBy;
  @override
  int? get createdOn;
  @override
  int? get modifiedOn;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
