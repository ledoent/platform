// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LoginInfo _$LoginInfoFromJson(Map<String, dynamic> json) {
  return _LoginInfo.fromJson(json);
}

/// @nodoc
mixin _$LoginInfo {
  String get token => throw _privateConstructorUsedError;
  @JsonKey(name: 'account')
  String get accountId => throw _privateConstructorUsedError;
  bool get tfaRequired => throw _privateConstructorUsedError;

  /// Serializes this LoginInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoginInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginInfoCopyWith<LoginInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginInfoCopyWith<$Res> {
  factory $LoginInfoCopyWith(LoginInfo value, $Res Function(LoginInfo) then) =
      _$LoginInfoCopyWithImpl<$Res, LoginInfo>;
  @useResult
  $Res call({
    String token,
    @JsonKey(name: 'account') String accountId,
    bool tfaRequired,
  });
}

/// @nodoc
class _$LoginInfoCopyWithImpl<$Res, $Val extends LoginInfo>
    implements $LoginInfoCopyWith<$Res> {
  _$LoginInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? accountId = null,
    Object? tfaRequired = null,
  }) {
    return _then(
      _value.copyWith(
            token: null == token
                ? _value.token
                : token // ignore: cast_nullable_to_non_nullable
                      as String,
            accountId: null == accountId
                ? _value.accountId
                : accountId // ignore: cast_nullable_to_non_nullable
                      as String,
            tfaRequired: null == tfaRequired
                ? _value.tfaRequired
                : tfaRequired // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LoginInfoImplCopyWith<$Res>
    implements $LoginInfoCopyWith<$Res> {
  factory _$$LoginInfoImplCopyWith(
    _$LoginInfoImpl value,
    $Res Function(_$LoginInfoImpl) then,
  ) = __$$LoginInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String token,
    @JsonKey(name: 'account') String accountId,
    bool tfaRequired,
  });
}

/// @nodoc
class __$$LoginInfoImplCopyWithImpl<$Res>
    extends _$LoginInfoCopyWithImpl<$Res, _$LoginInfoImpl>
    implements _$$LoginInfoImplCopyWith<$Res> {
  __$$LoginInfoImplCopyWithImpl(
    _$LoginInfoImpl _value,
    $Res Function(_$LoginInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? accountId = null,
    Object? tfaRequired = null,
  }) {
    return _then(
      _$LoginInfoImpl(
        token: null == token
            ? _value.token
            : token // ignore: cast_nullable_to_non_nullable
                  as String,
        accountId: null == accountId
            ? _value.accountId
            : accountId // ignore: cast_nullable_to_non_nullable
                  as String,
        tfaRequired: null == tfaRequired
            ? _value.tfaRequired
            : tfaRequired // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginInfoImpl implements _LoginInfo {
  const _$LoginInfoImpl({
    required this.token,
    @JsonKey(name: 'account') required this.accountId,
    this.tfaRequired = false,
  });

  factory _$LoginInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginInfoImplFromJson(json);

  @override
  final String token;
  @override
  @JsonKey(name: 'account')
  final String accountId;
  @override
  @JsonKey()
  final bool tfaRequired;

  @override
  String toString() {
    return 'LoginInfo(token: $token, accountId: $accountId, tfaRequired: $tfaRequired)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginInfoImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.tfaRequired, tfaRequired) ||
                other.tfaRequired == tfaRequired));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, token, accountId, tfaRequired);

  /// Create a copy of LoginInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginInfoImplCopyWith<_$LoginInfoImpl> get copyWith =>
      __$$LoginInfoImplCopyWithImpl<_$LoginInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginInfoImplToJson(this);
  }
}

abstract class _LoginInfo implements LoginInfo {
  const factory _LoginInfo({
    required final String token,
    @JsonKey(name: 'account') required final String accountId,
    final bool tfaRequired,
  }) = _$LoginInfoImpl;

  factory _LoginInfo.fromJson(Map<String, dynamic> json) =
      _$LoginInfoImpl.fromJson;

  @override
  String get token;
  @override
  @JsonKey(name: 'account')
  String get accountId;
  @override
  bool get tfaRequired;

  /// Create a copy of LoginInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginInfoImplCopyWith<_$LoginInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkspaceInfo _$WorkspaceInfoFromJson(Map<String, dynamic> json) {
  return _WorkspaceInfo.fromJson(json);
}

/// @nodoc
mixin _$WorkspaceInfo {
  String get workspaceUrl => throw _privateConstructorUsedError;
  String get workspaceName => throw _privateConstructorUsedError;
  String? get workspaceId => throw _privateConstructorUsedError;

  /// Serializes this WorkspaceInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkspaceInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkspaceInfoCopyWith<WorkspaceInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkspaceInfoCopyWith<$Res> {
  factory $WorkspaceInfoCopyWith(
    WorkspaceInfo value,
    $Res Function(WorkspaceInfo) then,
  ) = _$WorkspaceInfoCopyWithImpl<$Res, WorkspaceInfo>;
  @useResult
  $Res call({String workspaceUrl, String workspaceName, String? workspaceId});
}

/// @nodoc
class _$WorkspaceInfoCopyWithImpl<$Res, $Val extends WorkspaceInfo>
    implements $WorkspaceInfoCopyWith<$Res> {
  _$WorkspaceInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkspaceInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workspaceUrl = null,
    Object? workspaceName = null,
    Object? workspaceId = freezed,
  }) {
    return _then(
      _value.copyWith(
            workspaceUrl: null == workspaceUrl
                ? _value.workspaceUrl
                : workspaceUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            workspaceName: null == workspaceName
                ? _value.workspaceName
                : workspaceName // ignore: cast_nullable_to_non_nullable
                      as String,
            workspaceId: freezed == workspaceId
                ? _value.workspaceId
                : workspaceId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WorkspaceInfoImplCopyWith<$Res>
    implements $WorkspaceInfoCopyWith<$Res> {
  factory _$$WorkspaceInfoImplCopyWith(
    _$WorkspaceInfoImpl value,
    $Res Function(_$WorkspaceInfoImpl) then,
  ) = __$$WorkspaceInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String workspaceUrl, String workspaceName, String? workspaceId});
}

/// @nodoc
class __$$WorkspaceInfoImplCopyWithImpl<$Res>
    extends _$WorkspaceInfoCopyWithImpl<$Res, _$WorkspaceInfoImpl>
    implements _$$WorkspaceInfoImplCopyWith<$Res> {
  __$$WorkspaceInfoImplCopyWithImpl(
    _$WorkspaceInfoImpl _value,
    $Res Function(_$WorkspaceInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WorkspaceInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workspaceUrl = null,
    Object? workspaceName = null,
    Object? workspaceId = freezed,
  }) {
    return _then(
      _$WorkspaceInfoImpl(
        workspaceUrl: null == workspaceUrl
            ? _value.workspaceUrl
            : workspaceUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        workspaceName: null == workspaceName
            ? _value.workspaceName
            : workspaceName // ignore: cast_nullable_to_non_nullable
                  as String,
        workspaceId: freezed == workspaceId
            ? _value.workspaceId
            : workspaceId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkspaceInfoImpl implements _WorkspaceInfo {
  const _$WorkspaceInfoImpl({
    required this.workspaceUrl,
    required this.workspaceName,
    this.workspaceId,
  });

  factory _$WorkspaceInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkspaceInfoImplFromJson(json);

  @override
  final String workspaceUrl;
  @override
  final String workspaceName;
  @override
  final String? workspaceId;

  @override
  String toString() {
    return 'WorkspaceInfo(workspaceUrl: $workspaceUrl, workspaceName: $workspaceName, workspaceId: $workspaceId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkspaceInfoImpl &&
            (identical(other.workspaceUrl, workspaceUrl) ||
                other.workspaceUrl == workspaceUrl) &&
            (identical(other.workspaceName, workspaceName) ||
                other.workspaceName == workspaceName) &&
            (identical(other.workspaceId, workspaceId) ||
                other.workspaceId == workspaceId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, workspaceUrl, workspaceName, workspaceId);

  /// Create a copy of WorkspaceInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkspaceInfoImplCopyWith<_$WorkspaceInfoImpl> get copyWith =>
      __$$WorkspaceInfoImplCopyWithImpl<_$WorkspaceInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkspaceInfoImplToJson(this);
  }
}

abstract class _WorkspaceInfo implements WorkspaceInfo {
  const factory _WorkspaceInfo({
    required final String workspaceUrl,
    required final String workspaceName,
    final String? workspaceId,
  }) = _$WorkspaceInfoImpl;

  factory _WorkspaceInfo.fromJson(Map<String, dynamic> json) =
      _$WorkspaceInfoImpl.fromJson;

  @override
  String get workspaceUrl;
  @override
  String get workspaceName;
  @override
  String? get workspaceId;

  /// Create a copy of WorkspaceInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkspaceInfoImplCopyWith<_$WorkspaceInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkspaceLoginInfo _$WorkspaceLoginInfoFromJson(Map<String, dynamic> json) {
  return _WorkspaceLoginInfo.fromJson(json);
}

/// @nodoc
mixin _$WorkspaceLoginInfo {
  String get token => throw _privateConstructorUsedError;
  String get endpoint => throw _privateConstructorUsedError;
  @JsonKey(name: 'workspace')
  String get workspaceId => throw _privateConstructorUsedError;
  String? get workspaceUrl => throw _privateConstructorUsedError;
  String? get role => throw _privateConstructorUsedError;

  /// Serializes this WorkspaceLoginInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkspaceLoginInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkspaceLoginInfoCopyWith<WorkspaceLoginInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkspaceLoginInfoCopyWith<$Res> {
  factory $WorkspaceLoginInfoCopyWith(
    WorkspaceLoginInfo value,
    $Res Function(WorkspaceLoginInfo) then,
  ) = _$WorkspaceLoginInfoCopyWithImpl<$Res, WorkspaceLoginInfo>;
  @useResult
  $Res call({
    String token,
    String endpoint,
    @JsonKey(name: 'workspace') String workspaceId,
    String? workspaceUrl,
    String? role,
  });
}

/// @nodoc
class _$WorkspaceLoginInfoCopyWithImpl<$Res, $Val extends WorkspaceLoginInfo>
    implements $WorkspaceLoginInfoCopyWith<$Res> {
  _$WorkspaceLoginInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkspaceLoginInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? endpoint = null,
    Object? workspaceId = null,
    Object? workspaceUrl = freezed,
    Object? role = freezed,
  }) {
    return _then(
      _value.copyWith(
            token: null == token
                ? _value.token
                : token // ignore: cast_nullable_to_non_nullable
                      as String,
            endpoint: null == endpoint
                ? _value.endpoint
                : endpoint // ignore: cast_nullable_to_non_nullable
                      as String,
            workspaceId: null == workspaceId
                ? _value.workspaceId
                : workspaceId // ignore: cast_nullable_to_non_nullable
                      as String,
            workspaceUrl: freezed == workspaceUrl
                ? _value.workspaceUrl
                : workspaceUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            role: freezed == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WorkspaceLoginInfoImplCopyWith<$Res>
    implements $WorkspaceLoginInfoCopyWith<$Res> {
  factory _$$WorkspaceLoginInfoImplCopyWith(
    _$WorkspaceLoginInfoImpl value,
    $Res Function(_$WorkspaceLoginInfoImpl) then,
  ) = __$$WorkspaceLoginInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String token,
    String endpoint,
    @JsonKey(name: 'workspace') String workspaceId,
    String? workspaceUrl,
    String? role,
  });
}

/// @nodoc
class __$$WorkspaceLoginInfoImplCopyWithImpl<$Res>
    extends _$WorkspaceLoginInfoCopyWithImpl<$Res, _$WorkspaceLoginInfoImpl>
    implements _$$WorkspaceLoginInfoImplCopyWith<$Res> {
  __$$WorkspaceLoginInfoImplCopyWithImpl(
    _$WorkspaceLoginInfoImpl _value,
    $Res Function(_$WorkspaceLoginInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WorkspaceLoginInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? endpoint = null,
    Object? workspaceId = null,
    Object? workspaceUrl = freezed,
    Object? role = freezed,
  }) {
    return _then(
      _$WorkspaceLoginInfoImpl(
        token: null == token
            ? _value.token
            : token // ignore: cast_nullable_to_non_nullable
                  as String,
        endpoint: null == endpoint
            ? _value.endpoint
            : endpoint // ignore: cast_nullable_to_non_nullable
                  as String,
        workspaceId: null == workspaceId
            ? _value.workspaceId
            : workspaceId // ignore: cast_nullable_to_non_nullable
                  as String,
        workspaceUrl: freezed == workspaceUrl
            ? _value.workspaceUrl
            : workspaceUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        role: freezed == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkspaceLoginInfoImpl implements _WorkspaceLoginInfo {
  const _$WorkspaceLoginInfoImpl({
    required this.token,
    required this.endpoint,
    @JsonKey(name: 'workspace') required this.workspaceId,
    this.workspaceUrl,
    this.role,
  });

  factory _$WorkspaceLoginInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkspaceLoginInfoImplFromJson(json);

  @override
  final String token;
  @override
  final String endpoint;
  @override
  @JsonKey(name: 'workspace')
  final String workspaceId;
  @override
  final String? workspaceUrl;
  @override
  final String? role;

  @override
  String toString() {
    return 'WorkspaceLoginInfo(token: $token, endpoint: $endpoint, workspaceId: $workspaceId, workspaceUrl: $workspaceUrl, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkspaceLoginInfoImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.endpoint, endpoint) ||
                other.endpoint == endpoint) &&
            (identical(other.workspaceId, workspaceId) ||
                other.workspaceId == workspaceId) &&
            (identical(other.workspaceUrl, workspaceUrl) ||
                other.workspaceUrl == workspaceUrl) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    token,
    endpoint,
    workspaceId,
    workspaceUrl,
    role,
  );

  /// Create a copy of WorkspaceLoginInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkspaceLoginInfoImplCopyWith<_$WorkspaceLoginInfoImpl> get copyWith =>
      __$$WorkspaceLoginInfoImplCopyWithImpl<_$WorkspaceLoginInfoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkspaceLoginInfoImplToJson(this);
  }
}

abstract class _WorkspaceLoginInfo implements WorkspaceLoginInfo {
  const factory _WorkspaceLoginInfo({
    required final String token,
    required final String endpoint,
    @JsonKey(name: 'workspace') required final String workspaceId,
    final String? workspaceUrl,
    final String? role,
  }) = _$WorkspaceLoginInfoImpl;

  factory _WorkspaceLoginInfo.fromJson(Map<String, dynamic> json) =
      _$WorkspaceLoginInfoImpl.fromJson;

  @override
  String get token;
  @override
  String get endpoint;
  @override
  @JsonKey(name: 'workspace')
  String get workspaceId;
  @override
  String? get workspaceUrl;
  @override
  String? get role;

  /// Create a copy of WorkspaceLoginInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkspaceLoginInfoImplCopyWith<_$WorkspaceLoginInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OtpInfo _$OtpInfoFromJson(Map<String, dynamic> json) {
  return _OtpInfo.fromJson(json);
}

/// @nodoc
mixin _$OtpInfo {
  bool get sent => throw _privateConstructorUsedError;

  /// Serializes this OtpInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OtpInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OtpInfoCopyWith<OtpInfo> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OtpInfoCopyWith<$Res> {
  factory $OtpInfoCopyWith(OtpInfo value, $Res Function(OtpInfo) then) =
      _$OtpInfoCopyWithImpl<$Res, OtpInfo>;
  @useResult
  $Res call({bool sent});
}

/// @nodoc
class _$OtpInfoCopyWithImpl<$Res, $Val extends OtpInfo>
    implements $OtpInfoCopyWith<$Res> {
  _$OtpInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OtpInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? sent = null}) {
    return _then(
      _value.copyWith(
            sent: null == sent
                ? _value.sent
                : sent // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OtpInfoImplCopyWith<$Res> implements $OtpInfoCopyWith<$Res> {
  factory _$$OtpInfoImplCopyWith(
    _$OtpInfoImpl value,
    $Res Function(_$OtpInfoImpl) then,
  ) = __$$OtpInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool sent});
}

/// @nodoc
class __$$OtpInfoImplCopyWithImpl<$Res>
    extends _$OtpInfoCopyWithImpl<$Res, _$OtpInfoImpl>
    implements _$$OtpInfoImplCopyWith<$Res> {
  __$$OtpInfoImplCopyWithImpl(
    _$OtpInfoImpl _value,
    $Res Function(_$OtpInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OtpInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? sent = null}) {
    return _then(
      _$OtpInfoImpl(
        sent: null == sent
            ? _value.sent
            : sent // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OtpInfoImpl implements _OtpInfo {
  const _$OtpInfoImpl({this.sent = true});

  factory _$OtpInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OtpInfoImplFromJson(json);

  @override
  @JsonKey()
  final bool sent;

  @override
  String toString() {
    return 'OtpInfo(sent: $sent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OtpInfoImpl &&
            (identical(other.sent, sent) || other.sent == sent));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sent);

  /// Create a copy of OtpInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OtpInfoImplCopyWith<_$OtpInfoImpl> get copyWith =>
      __$$OtpInfoImplCopyWithImpl<_$OtpInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OtpInfoImplToJson(this);
  }
}

abstract class _OtpInfo implements OtpInfo {
  const factory _OtpInfo({final bool sent}) = _$OtpInfoImpl;

  factory _OtpInfo.fromJson(Map<String, dynamic> json) = _$OtpInfoImpl.fromJson;

  @override
  bool get sent;

  /// Create a copy of OtpInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OtpInfoImplCopyWith<_$OtpInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProviderInfo _$ProviderInfoFromJson(Map<String, dynamic> json) {
  return _ProviderInfo.fromJson(json);
}

/// @nodoc
mixin _$ProviderInfo {
  String get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;

  /// Serializes this ProviderInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProviderInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProviderInfoCopyWith<ProviderInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProviderInfoCopyWith<$Res> {
  factory $ProviderInfoCopyWith(
    ProviderInfo value,
    $Res Function(ProviderInfo) then,
  ) = _$ProviderInfoCopyWithImpl<$Res, ProviderInfo>;
  @useResult
  $Res call({String id, String? name, String? icon});
}

/// @nodoc
class _$ProviderInfoCopyWithImpl<$Res, $Val extends ProviderInfo>
    implements $ProviderInfoCopyWith<$Res> {
  _$ProviderInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProviderInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? icon = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            icon: freezed == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProviderInfoImplCopyWith<$Res>
    implements $ProviderInfoCopyWith<$Res> {
  factory _$$ProviderInfoImplCopyWith(
    _$ProviderInfoImpl value,
    $Res Function(_$ProviderInfoImpl) then,
  ) = __$$ProviderInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String? name, String? icon});
}

/// @nodoc
class __$$ProviderInfoImplCopyWithImpl<$Res>
    extends _$ProviderInfoCopyWithImpl<$Res, _$ProviderInfoImpl>
    implements _$$ProviderInfoImplCopyWith<$Res> {
  __$$ProviderInfoImplCopyWithImpl(
    _$ProviderInfoImpl _value,
    $Res Function(_$ProviderInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProviderInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? icon = freezed,
  }) {
    return _then(
      _$ProviderInfoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        icon: freezed == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProviderInfoImpl implements _ProviderInfo {
  const _$ProviderInfoImpl({required this.id, this.name, this.icon});

  factory _$ProviderInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProviderInfoImplFromJson(json);

  @override
  final String id;
  @override
  final String? name;
  @override
  final String? icon;

  @override
  String toString() {
    return 'ProviderInfo(id: $id, name: $name, icon: $icon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProviderInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.icon, icon) || other.icon == icon));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, icon);

  /// Create a copy of ProviderInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProviderInfoImplCopyWith<_$ProviderInfoImpl> get copyWith =>
      __$$ProviderInfoImplCopyWithImpl<_$ProviderInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProviderInfoImplToJson(this);
  }
}

abstract class _ProviderInfo implements ProviderInfo {
  const factory _ProviderInfo({
    required final String id,
    final String? name,
    final String? icon,
  }) = _$ProviderInfoImpl;

  factory _ProviderInfo.fromJson(Map<String, dynamic> json) =
      _$ProviderInfoImpl.fromJson;

  @override
  String get id;
  @override
  String? get name;
  @override
  String? get icon;

  /// Create a copy of ProviderInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProviderInfoImplCopyWith<_$ProviderInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
