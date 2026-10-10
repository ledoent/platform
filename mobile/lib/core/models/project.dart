import 'package:freezed_annotation/freezed_annotation.dart';

part 'project.freezed.dart';
part 'project.g.dart';

@freezed
class Project with _$Project {
  const factory Project({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: '_class') required String className,
    required String name,
    required String identifier,
    String? description,
    String? defaultIssueStatus,
  }) = _Project;

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);
}
