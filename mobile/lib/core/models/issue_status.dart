import 'package:freezed_annotation/freezed_annotation.dart';

part 'issue_status.freezed.dart';
part 'issue_status.g.dart';

/// Represents a tracker issue status (core:class:Status).
@freezed
class IssueStatus with _$IssueStatus {
  const factory IssueStatus({
    @JsonKey(name: '_id') required String id,
    required String name,
    String? category,
    @JsonKey(name: 'ofAttribute') String? ofAttribute,
    @Default(0) int color,
  }) = _IssueStatus;

  factory IssueStatus.fromJson(Map<String, dynamic> json) =>
      _$IssueStatusFromJson(json);
}
