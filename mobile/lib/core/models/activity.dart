import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity.freezed.dart';
part 'activity.g.dart';

/// Represents a chunter:class:ChatMessage attached to a document.
@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: '_class') required String className,
    required String attachedTo,
    required String message,
    String? createdBy,
    String? modifiedBy,
    int? createdOn,
    int? modifiedOn,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}
