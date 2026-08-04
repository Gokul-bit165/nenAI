import 'tool_protocol.dart';

class ToolRegistry {
  final Map<String, McpTool> _tools = {};

  void registerTool(McpTool tool) {
    _tools[tool.name] = tool;
  }

  McpTool? getTool(String name) => _tools[name];

  List<McpTool> getAllTools() => _tools.values.toList();
}
