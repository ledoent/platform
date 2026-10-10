import 'package:freezed_annotation/freezed_annotation.dart';

part 'channel.freezed.dart';
part 'channel.g.dart';

/// Represents a chunter:class:Channel or chunter:class:DirectMessage.
@freezed
class Channel with _$Channel {
  const factory Channel({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: '_class') required String className,
    required String name,
    String? description,
    String? topic,
    @Default([]) List<String> members,
    int? modifiedOn,
  }) = _Channel;

  factory Channel.fromJson(Map<String, dynamic> json) =>
      _$ChannelFromJson(json);
}
