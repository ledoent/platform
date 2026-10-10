// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMessageImpl _$$ChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageImpl(
      id: json['_id'] as String,
      className: json['_class'] as String,
      attachedTo: json['attachedTo'] as String,
      message: json['message'] as String,
      createdBy: json['createdBy'] as String?,
      modifiedBy: json['modifiedBy'] as String?,
      createdOn: (json['createdOn'] as num?)?.toInt(),
      modifiedOn: (json['modifiedOn'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ChatMessageImplToJson(_$ChatMessageImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      '_class': instance.className,
      'attachedTo': instance.attachedTo,
      'message': instance.message,
      'createdBy': instance.createdBy,
      'modifiedBy': instance.modifiedBy,
      'createdOn': instance.createdOn,
      'modifiedOn': instance.modifiedOn,
    };
