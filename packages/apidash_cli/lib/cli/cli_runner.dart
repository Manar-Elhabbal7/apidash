import 'package:apidash_cli/commands/history_command.dart';
import 'package:apidash_cli/commands/init_command.dart';
import 'package:apidash_cli/commands/request_command.dart';
import 'package:args/command_runner.dart';

class CliRunner extends CommandRunner {
  CliRunner()
      : super(
          'apidash',
          'API Dash CLI - AI-Powered API Client',
        ) {
    addCommand(InitCommand());
    addCommand(RequestCommand());
    addCommand(HistoryCommand());
  }
}
