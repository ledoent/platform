import 'package:freezed_annotation/freezed_annotation.dart';

part 'attachment.freezed.dart';
part 'attachment.g.dart';

/// Represents an attachment:class:Attachment document.
@freezed
class Attachment with _$Attachment {
  const factory Attachment({
    @JsonKey(name: '_id') required String id,
    required String name,
    required String file,
    required int size,
    required String type,
    String? attachedTo,
  }) = _Attachment;

  factory Attachment.fromJson(Map<String, dynamic> json) =>
      _$AttachmentFromJson(json);
}
