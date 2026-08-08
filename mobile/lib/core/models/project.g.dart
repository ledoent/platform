// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectImpl _$$ProjectImplFromJson(Map<String, dynamic> json) =>
    _$ProjectImpl(
      id: json['_id'] as String,
      className: json['_class'] as String,
      name: json['name'] as String,
      identifier: json['identifier'] as String,
      description: json['description'] as String?,
      defaultIssueStatus: json['defaultIssueStatus'] as String?,
    );

Map<String, dynamic> _$$ProjectImplToJson(_$ProjectImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      '_class': instance.className,
      'name': instance.name,
      'identifier': instance.identifier,
      'description': instance.description,
      'defaultIssueStatus': instance.defaultIssueStatus,
    };
