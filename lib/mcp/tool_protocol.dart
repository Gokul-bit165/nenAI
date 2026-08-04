enum PermissionLevel {
  /// Auto-executes silently without blocking the user
  read,

  /// Requires pre-confirmation chip in UI before execution
  writeSchedule,
}

class McpToolResult {
  const McpToolResult({
    required this.success,
    required this.resultData,
    required this.userDisplayMessage,
  });

  final bool success;
  final Map<String, dynamic> resultData;
  final String userDisplayMessage;
}

abstract class McpTool {
  String get name;
  String get description;
  PermissionLevel get permissionLevel;
  Map<String, String> get parametersSchema;

  Future<McpToolResult> execute(Map<String, dynamic> params);
}
