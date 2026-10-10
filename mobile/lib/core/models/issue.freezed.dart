// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'issue.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Issue _$IssueFromJson(Map<String, dynamic> json) {
  return _Issue.fromJson(json);
}

/// @nodoc
mixin _$Issue {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: '_class')
  String get className => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  int get priority => throw _privateConstructorUsedError;
  int get number => throw _privateConstructorUsedError;
  String get identifier => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get space => throw _privateConstructorUsedError;
  String? get assignee => throw _privateConstructorUsedError;
  String? get modifiedBy => throw _privateConstructorUsedError;
  int? get modifiedOn => throw _privateConstructorUsedError;
  int? get createdOn => throw _privateConstructorUsedError;

  /// Serializes this Issue to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Issue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IssueCopyWith<Issue> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IssueCopyWith<$Res> {
  factory $IssueCopyWith(Issue value, $Res Function(Issue) then) =
      _$IssueCopyWithImpl<$Res, Issue>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    @JsonKey(name: '_class') String className,
    String title,
    String? description,
    int priority,
    int number,
    String identifier,
    String status,
    String space,
    String? assignee,
    String? modifiedBy,
    int? modifiedOn,
    int? createdOn,
  });
}

/// @nodoc
class _$IssueCopyWithImpl<$Res, $Val extends Issue>
    implements $IssueCopyWith<$Res> {
  _$IssueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Issue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? className = null,
    Object? title = null,
    Object? description = freezed,
    Object? priority = null,
    Object? number = null,
    Object? identifier = null,
    Object? status = null,
    Object? space = null,
    Object? assignee = freezed,
    Object? modifiedBy = freezed,
    Object? modifiedOn = freezed,
    Object? createdOn = freezed,
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
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as int,
            number: null == number
                ? _value.number
                : number // ignore: cast_nullable_to_non_nullable
                      as int,
            identifier: null == identifier
                ? _value.identifier
                : identifier // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            space: null == space
                ? _value.space
                : space // ignore: cast_nullable_to_non_nullable
                      as String,
            assignee: freezed == assignee
                ? _value.assignee
                : assignee // ignore: cast_nullable_to_non_nullable
                      as String?,
            modifiedBy: freezed == modifiedBy
                ? _value.modifiedBy
                : modifiedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            modifiedOn: freezed == modifiedOn
                ? _value.modifiedOn
                : modifiedOn // ignore: cast_nullable_to_non_nullable
                      as int?,
            createdOn: freezed == createdOn
                ? _value.createdOn
                : createdOn // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$IssueImplCopyWith<$Res> implements $IssueCopyWith<$Res> {
  factory _$$IssueImplCopyWith(
    _$IssueImpl value,
    $Res Function(_$IssueImpl) then,
  ) = __$$IssueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    @JsonKey(name: '_class') String className,
    String title,
    String? description,
    int priority,
    int number,
    String identifier,
    String status,
    String space,
    String? assignee,
    String? modifiedBy,
    int? modifiedOn,
    int? createdOn,
  });
}

/// @nodoc
class __$$IssueImplCopyWithImpl<$Res>
    extends _$IssueCopyWithImpl<$Res, _$IssueImpl>
    implements _$$IssueImplCopyWith<$Res> {
  __$$IssueImplCopyWithImpl(
    _$IssueImpl _value,
    $Res Function(_$IssueImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Issue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? className = null,
    Object? title = null,
    Object? description = freezed,
    Object? priority = null,
    Object? number = null,
    Object? identifier = null,
    Object? status = null,
    Object? space = null,
    Object? assignee = freezed,
    Object? modifiedBy = freezed,
    Object? modifiedOn = freezed,
    Object? createdOn = freezed,
  }) {
    return _then(
      _$IssueImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        className: null == className
            ? _value.className
            : className // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as int,
        number: null == number
            ? _value.number
            : number // ignore: cast_nullable_to_non_nullable
                  as int,
        identifier: null == identifier
            ? _value.identifier
            : identifier // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        space: null == space
            ? _value.space
            : space // ignore: cast_nullable_to_non_nullable
                  as String,
        assignee: freezed == assignee
            ? _value.assignee
            : assignee // ignore: cast_nullable_to_non_nullable
                  as String?,
        modifiedBy: freezed == modifiedBy
            ? _value.modifiedBy
            : modifiedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        modifiedOn: freezed == modifiedOn
            ? _value.modifiedOn
            : modifiedOn // ignore: cast_nullable_to_non_nullable
                  as int?,
        createdOn: freezed == createdOn
            ? _value.createdOn
            : createdOn // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$IssueImpl implements _Issue {
  const _$IssueImpl({
    @JsonKey(name: '_id') required this.id,
    @JsonKey(name: '_class') required this.className,
    required this.title,
    this.description,
    required this.priority,
    required this.number,
    required this.identifier,
    required this.status,
    required this.space,
    this.assignee,
    this.modifiedBy,
    this.modifiedOn,
    this.createdOn,
  });

  factory _$IssueImpl.fromJson(Map<String, dynamic> json) =>
      _$$IssueImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  @JsonKey(name: '_class')
  final String className;
  @override
  final String title;
  @override
  final String? description;
  @override
  final int priority;
  @override
  final int number;
  @override
  final String identifier;
  @override
  final String status;
  @override
  final String space;
  @override
  final String? assignee;
  @override
  final String? modifiedBy;
  @override
  final int? modifiedOn;
  @override
  final int? createdOn;

  @override
  String toString() {
    return 'Issue(id: $id, className: $className, title: $title, description: $description, priority: $priority, number: $number, identifier: $identifier, status: $status, space: $space, assignee: $assignee, modifiedBy: $modifiedBy, modifiedOn: $modifiedOn, createdOn: $createdOn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IssueImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.className, className) ||
                other.className == className) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.identifier, identifier) ||
                other.identifier == identifier) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.space, space) || other.space == space) &&
            (identical(other.assignee, assignee) ||
                other.assignee == assignee) &&
            (identical(other.modifiedBy, modifiedBy) ||
                other.modifiedBy == modifiedBy) &&
            (identical(other.modifiedOn, modifiedOn) ||
                other.modifiedOn == modifiedOn) &&
            (identical(other.createdOn, createdOn) ||
                other.createdOn == createdOn));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    className,
    title,
    description,
    priority,
    number,
    identifier,
    status,
    space,
    assignee,
    modifiedBy,
    modifiedOn,
    createdOn,
  );

  /// Create a copy of Issue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IssueImplCopyWith<_$IssueImpl> get copyWith =>
      __$$IssueImplCopyWithImpl<_$IssueImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IssueImplToJson(this);
  }
}

abstract class _Issue implements Issue {
  const factory _Issue({
    @JsonKey(name: '_id') required final String id,
    @JsonKey(name: '_class') required final String className,
    required final String title,
    final String? description,
    required final int priority,
    required final int number,
    required final String identifier,
    required final String status,
    required final String space,
    final String? assignee,
    final String? modifiedBy,
    final int? modifiedOn,
    final int? createdOn,
  }) = _$IssueImpl;

  factory _Issue.fromJson(Map<String, dynamic> json) = _$IssueImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  @JsonKey(name: '_class')
  String get className;
  @override
  String get title;
  @override
  String? get description;
  @override
  int get priority;
  @override
  int get number;
  @override
  String get identifier;
  @override
  String get status;
  @override
  String get space;
  @override
  String? get assignee;
  @override
  String? get modifiedBy;
  @override
  int? get modifiedOn;
  @override
  int? get createdOn;

  /// Create a copy of Issue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IssueImplCopyWith<_$IssueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
