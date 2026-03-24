import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Builds a TxUpdateDoc transaction for the Huly REST API.
Map<String, dynamic> buildUpdateIssueTx({
  required String issueId,
  required String space,
  required Map<String, dynamic> operations,
  String? modifiedBy,
}) {
  return {
    '_class': 'core:class:TxUpdateDoc',
    'objectId': issueId,
    'objectClass': 'tracker:class:Issue',
    'objectSpace': space,
    'operations': operations,
    if (modifiedBy != null) 'modifiedBy': modifiedBy,
  };
}

/// Builds a TxCreateDoc transaction for the Huly REST API.
Map<String, dynamic> buildCreateIssueTx({
  required String space,
  required String title,
  required String status,
  required int priority,
  String? description,
  String? assignee,
  String? modifiedBy,
}) {
  final issueId = 'tracker:issue:${_uuid.v4()}';

  return {
    '_class': 'core:class:TxCreateDoc',
    'objectId': issueId,
    'objectClass': 'tracker:class:Issue',
    'objectSpace': space,
    'attributes': {
      'title': title,
      'description': description ?? '<p></p>',
      'status': status,
      'priority': priority,
      'kind': 'tracker:taskType:Issue',
      if (assignee != null) 'assignee': assignee,
    },
    if (modifiedBy != null) 'modifiedBy': modifiedBy,
  };
}
