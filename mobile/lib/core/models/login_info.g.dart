// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginInfoImpl _$$LoginInfoImplFromJson(Map<String, dynamic> json) =>
    _$LoginInfoImpl(
      token: json['token'] as String,
      accountId: json['account'] as String,
      tfaRequired: json['tfaRequired'] as bool? ?? false,
    );

Map<String, dynamic> _$$LoginInfoImplToJson(_$LoginInfoImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'account': instance.accountId,
      'tfaRequired': instance.tfaRequired,
    };

_$WorkspaceInfoImpl _$$WorkspaceInfoImplFromJson(Map<String, dynamic> json) =>
    _$WorkspaceInfoImpl(
      workspaceUrl: json['workspaceUrl'] as String,
      workspaceName: json['workspaceName'] as String,
      workspaceId: json['workspaceId'] as String?,
    );

Map<String, dynamic> _$$WorkspaceInfoImplToJson(_$WorkspaceInfoImpl instance) =>
    <String, dynamic>{
      'workspaceUrl': instance.workspaceUrl,
      'workspaceName': instance.workspaceName,
      'workspaceId': instance.workspaceId,
    };

_$WorkspaceLoginInfoImpl _$$WorkspaceLoginInfoImplFromJson(
  Map<String, dynamic> json,
) => _$WorkspaceLoginInfoImpl(
  token: json['token'] as String,
  endpoint: json['endpoint'] as String,
  workspaceId: json['workspace'] as String,
  workspaceUrl: json['workspaceUrl'] as String?,
  role: json['role'] as String?,
);

Map<String, dynamic> _$$WorkspaceLoginInfoImplToJson(
  _$WorkspaceLoginInfoImpl instance,
) => <String, dynamic>{
  'token': instance.token,
  'endpoint': instance.endpoint,
  'workspace': instance.workspaceId,
  'workspaceUrl': instance.workspaceUrl,
  'role': instance.role,
};

_$OtpInfoImpl _$$OtpInfoImplFromJson(Map<String, dynamic> json) =>
    _$OtpInfoImpl(sent: json['sent'] as bool? ?? true);

Map<String, dynamic> _$$OtpInfoImplToJson(_$OtpInfoImpl instance) =>
    <String, dynamic>{'sent': instance.sent};

_$ProviderInfoImpl _$$ProviderInfoImplFromJson(Map<String, dynamic> json) =>
    _$ProviderInfoImpl(
      id: json['id'] as String,
      name: json['name'] as String?,
      icon: json['icon'] as String?,
    );

Map<String, dynamic> _$$ProviderInfoImplToJson(_$ProviderInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
    };
