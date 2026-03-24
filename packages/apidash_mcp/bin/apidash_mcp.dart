import 'package:mcp_dart/mcp_dart.dart';

void main(List<String> args) async {
 McpServer server = McpServer(
   Implementation(name: "apidash_mcp", version: "1.0.0"),
   options: ServerOptions(
     capabilities: ServerCapabilities(
       resources: ServerCapabilitiesResources(),
       tools: ServerCapabilitiesTools(),
     ),
   ),
 );


 server.connect(StdioServerTransport());
}