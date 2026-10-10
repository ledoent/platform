// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IssueImpl _$$IssueImplFromJson(Map<String, dynamic> json) => _$IssueImpl(
  id: json['_id'] as String,
  className: json['_class'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  priority: (json['priority'] as num).toInt(),
  number: (json['number'] as num).toInt(),
  identifier: json['identifier'] as String,
  status: json['status'] as String,
  space: json['space'] as String,
  assignee: json['assignee'] as String?,
  modifiedBy: json['modifiedBy'] as String?,
  modifiedOn: (json['modifiedOn'] as num?)?.toInt(),
  createdOn: (json['createdOn'] as num?)?.toInt(),
);

Map<String, dynamic> _$$IssueImplToJson(_$IssueImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      '_class': instance.className,
      'title': instance.title,
      'description': instance.description,
      'priority': instance.priority,
      'number': instance.number,
      'identifier': instance.identifier,
      'status': instance.status,
      'space': instance.space,
      'assignee': instance.assignee,
      'modifiedBy': instance.modifiedBy,
      'modifiedOn': instance.modifiedOn,
      'createdOn': instance.createdOn,
    };
