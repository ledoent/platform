// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AttachmentImpl _$$AttachmentImplFromJson(Map<String, dynamic> json) =>
    _$AttachmentImpl(
      id: json['_id'] as String,
      name: json['name'] as String,
      file: json['file'] as String,
      size: (json['size'] as num).toInt(),
      type: json['type'] as String,
      attachedTo: json['attachedTo'] as String?,
    );

Map<String, dynamic> _$$AttachmentImplToJson(_$AttachmentImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'file': instance.file,
      'size': instance.size,
      'type': instance.type,
      'attachedTo': instance.attachedTo,
    };
