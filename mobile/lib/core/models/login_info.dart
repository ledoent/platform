import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_info.freezed.dart';
part 'login_info.g.dart';

@freezed
class LoginInfo with _$LoginInfo {
  const factory LoginInfo({
    required String token,
    @JsonKey(name: 'account') required String accountId,
    @Default(false) bool tfaRequired,
  }) = _LoginInfo;

  factory LoginInfo.fromJson(Map<String, dynamic> json) =>
      _$LoginInfoFromJson(json);
}

@freezed
class WorkspaceInfo with _$WorkspaceInfo {
  const factory WorkspaceInfo({
    required String workspaceUrl,
    required String workspaceName,
    String? workspaceId,
  }) = _WorkspaceInfo;

  factory WorkspaceInfo.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceInfoFromJson(json);
}

@freezed
class WorkspaceLoginInfo with _$WorkspaceLoginInfo {
  const factory WorkspaceLoginInfo({
    required String token,
    required String endpoint,
    @JsonKey(name: 'workspace') required String workspaceId,
    String? workspaceUrl,
    String? role,
  }) = _WorkspaceLoginInfo;

  factory WorkspaceLoginInfo.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceLoginInfoFromJson(json);
}

@freezed
class OtpInfo with _$OtpInfo {
  const factory OtpInfo({
    @Default(true) bool sent,
  }) = _OtpInfo;

  factory OtpInfo.fromJson(Map<String, dynamic> json) =>
      _$OtpInfoFromJson(json);
}

@freezed
class ProviderInfo with _$ProviderInfo {
  const factory ProviderInfo({
    required String id,
    String? name,
    String? icon,
  }) = _ProviderInfo;

  factory ProviderInfo.fromJson(Map<String, dynamic> json) =>
      _$ProviderInfoFromJson(json);
}
