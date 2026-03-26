# ApiDash MCP Server

The **Model Context Protocol (MCP)** server for [ApiDash](https://github.com/foss42/apidash), allowing AI assistants like Claude, ChatGPT, and Gemini to interact with your API collections and history.

## Features

- **`init_workspace`**: Initialize or create a new ApiDash workspace.
- **`list_history`**: List API requests from the workspace history.
- **`send_request`**: Execute an API request (GET, POST, etc.) and save it to history.
- **`get_request`**: Retrieve full details of a specific request from history.
- **`delete_request`**: Remove a request from history.

## Installation

### Globally (Recommended)

You can install `apidash_mcp` globally to use it as a standalone command:

```bash
dart pub global activate --source path packages/apidash_mcp
```

### Locally

```bash
dart pub get
```

## Setup for AI Agents

To use this server with your favorite AI agent, add the following to your MCP configuration:

### VS Code (Cline / Roo Code)

```json
"apidash": {
  "command": "apidash_mcp"
}
```

### Claude Desktop

Add this to your `claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "apidash": {
      "command": "apidash_mcp"
    }
  }
}
```

## Usage

If installed globally, you can run:
```bash
apidash_mcp
```
The server uses **Standard I/O (stdio)** for communication.

## Development

To run the server in development mode:
```bash
dart run bin/mcp.dart
```

---
Built with ❤️ for the ApiDash community.
