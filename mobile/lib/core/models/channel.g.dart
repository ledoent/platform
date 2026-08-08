// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChannelImpl _$$ChannelImplFromJson(Map<String, dynamic> json) =>
    _$ChannelImpl(
      id: json['_id'] as String,
      className: json['_class'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      topic: json['topic'] as String?,
      members:
          (json['members'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      modifiedOn: (json['modifiedOn'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ChannelImplToJson(_$ChannelImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      '_class': instance.className,
      'name': instance.name,
      'description': instance.description,
      'topic': instance.topic,
      'members': instance.members,
      'modifiedOn': instance.modifiedOn,
    };
