import 'package:freezed_annotation/freezed_annotation.dart';

part 'member.freezed.dart';
part 'member.g.dart';

/// Represents a contact:class:Person from the platform.
@freezed
class Member with _$Member {
  const factory Member({
    @JsonKey(name: '_id') required String id,
    required String name,
    String? avatar,
    String? city,
    String? personUuid,
  }) = _Member;

  factory Member.fromJson(Map<String, dynamic> json) =>
      _$MemberFromJson(json);
}
