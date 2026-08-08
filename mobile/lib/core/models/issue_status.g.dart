// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issue_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IssueStatusImpl _$$IssueStatusImplFromJson(Map<String, dynamic> json) =>
    _$IssueStatusImpl(
      id: json['_id'] as String,
      name: json['name'] as String,
      category: json['category'] as String?,
      ofAttribute: json['ofAttribute'] as String?,
      color: (json['color'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$IssueStatusImplToJson(_$IssueStatusImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'ofAttribute': instance.ofAttribute,
      'color': instance.color,
    };
