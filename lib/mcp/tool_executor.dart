import 'tool_protocol.dart';
import 'tool_registry.dart';

class ToolCallRequest {
  const ToolCallRequest({
    required this.toolName,
    required this.parameters,
  });

  final String toolName;
  final Map<String, dynamic> parameters;
}

class ToolExecutor {
  ToolExecutor(this._registry);

  final ToolRegistry _registry;
  static const int maxIterations = 3;

  /// Executes a requested tool call. If the tool is `PermissionLevel.read`, it runs immediately.
  /// If it requires `PermissionLevel.writeSchedule`, it returns metadata indicating pre-confirmation is needed.
  Future<McpToolResult> executeRequest(
    ToolCallRequest request, {
    bool userConfirmed = false,
  }) async {
    final tool = _registry.getTool(request.toolName);
    if (tool == null) {
      return McpToolResult(
        success: false,
        resultData: {},
        userDisplayMessage: 'Tool "${request.toolName}" is not registered.',
      );
    }

    if (tool.permissionLevel == PermissionLevel.writeSchedule && !userConfirmed) {
      return McpToolResult(
        success: false,
        resultData: {'needsConfirmation': true, 'toolName': tool.name, 'params': request.parameters},
        userDisplayMessage: 'Pre-confirmation required for "${tool.name}".',
      );
    }

    return await tool.execute(request.parameters);
  }
}
