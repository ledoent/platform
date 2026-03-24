// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'issue_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

IssueStatus _$IssueStatusFromJson(Map<String, dynamic> json) {
  return _IssueStatus.fromJson(json);
}

/// @nodoc
mixin _$IssueStatus {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  @JsonKey(name: 'ofAttribute')
  String? get ofAttribute => throw _privateConstructorUsedError;
  int get color => throw _privateConstructorUsedError;

  /// Serializes this IssueStatus to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IssueStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IssueStatusCopyWith<IssueStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IssueStatusCopyWith<$Res> {
  factory $IssueStatusCopyWith(
    IssueStatus value,
    $Res Function(IssueStatus) then,
  ) = _$IssueStatusCopyWithImpl<$Res, IssueStatus>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String name,
    String? category,
    @JsonKey(name: 'ofAttribute') String? ofAttribute,
    int color,
  });
}

/// @nodoc
class _$IssueStatusCopyWithImpl<$Res, $Val extends IssueStatus>
    implements $IssueStatusCopyWith<$Res> {
  _$IssueStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IssueStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = freezed,
    Object? ofAttribute = freezed,
    Object? color = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
            ofAttribute: freezed == ofAttribute
                ? _value.ofAttribute
                : ofAttribute // ignore: cast_nullable_to_non_nullable
                      as String?,
            color: null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$IssueStatusImplCopyWith<$Res>
    implements $IssueStatusCopyWith<$Res> {
  factory _$$IssueStatusImplCopyWith(
    _$IssueStatusImpl value,
    $Res Function(_$IssueStatusImpl) then,
  ) = __$$IssueStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String name,
    String? category,
    @JsonKey(name: 'ofAttribute') String? ofAttribute,
    int color,
  });
}

/// @nodoc
class __$$IssueStatusImplCopyWithImpl<$Res>
    extends _$IssueStatusCopyWithImpl<$Res, _$IssueStatusImpl>
    implements _$$IssueStatusImplCopyWith<$Res> {
  __$$IssueStatusImplCopyWithImpl(
    _$IssueStatusImpl _value,
    $Res Function(_$IssueStatusImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of IssueStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = freezed,
    Object? ofAttribute = freezed,
    Object? color = null,
  }) {
    return _then(
      _$IssueStatusImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
        ofAttribute: freezed == ofAttribute
            ? _value.ofAttribute
            : ofAttribute // ignore: cast_nullable_to_non_nullable
                  as String?,
        color: null == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$IssueStatusImpl implements _IssueStatus {
  const _$IssueStatusImpl({
    @JsonKey(name: '_id') required this.id,
    required this.name,
    this.category,
    @JsonKey(name: 'ofAttribute') this.ofAttribute,
    this.color = 0,
  });

  factory _$IssueStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$IssueStatusImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String name;
  @override
  final String? category;
  @override
  @JsonKey(name: 'ofAttribute')
  final String? ofAttribute;
  @override
  @JsonKey()
  final int color;

  @override
  String toString() {
    return 'IssueStatus(id: $id, name: $name, category: $category, ofAttribute: $ofAttribute, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IssueStatusImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.ofAttribute, ofAttribute) ||
                other.ofAttribute == ofAttribute) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, category, ofAttribute, color);

  /// Create a copy of IssueStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IssueStatusImplCopyWith<_$IssueStatusImpl> get copyWith =>
      __$$IssueStatusImplCopyWithImpl<_$IssueStatusImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IssueStatusImplToJson(this);
  }
}

abstract class _IssueStatus implements IssueStatus {
  const factory _IssueStatus({
    @JsonKey(name: '_id') required final String id,
    required final String name,
    final String? category,
    @JsonKey(name: 'ofAttribute') final String? ofAttribute,
    final int color,
  }) = _$IssueStatusImpl;

  factory _IssueStatus.fromJson(Map<String, dynamic> json) =
      _$IssueStatusImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get name;
  @override
  String? get category;
  @override
  @JsonKey(name: 'ofAttribute')
  String? get ofAttribute;
  @override
  int get color;

  /// Create a copy of IssueStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IssueStatusImplCopyWith<_$IssueStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
