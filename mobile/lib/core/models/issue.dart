import 'package:freezed_annotation/freezed_annotation.dart';

part 'issue.freezed.dart';
part 'issue.g.dart';

/// Priority values matching tracker:IssuePriority
class IssuePriority {
  static const int noPriority = 0;
  static const int urgent = 1;
  static const int high = 2;
  static const int medium = 3;
  static const int low = 4;

  static String label(int priority) {
    switch (priority) {
      case urgent:
        return 'Urgent';
      case high:
        return 'High';
      case medium:
        return 'Medium';
      case low:
        return 'Low';
      default:
        return 'No priority';
    }
  }
}

@freezed
class Issue with _$Issue {
  const factory Issue({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: '_class') required String className,
    required String title,
    String? description,
    required int priority,
    required int number,
    required String identifier,
    required String status,
    required String space,
    String? assignee,
    String? modifiedBy,
    int? modifiedOn,
    int? createdOn,
  }) = _Issue;

  factory Issue.fromJson(Map<String, dynamic> json) => _$IssueFromJson(json);
}
