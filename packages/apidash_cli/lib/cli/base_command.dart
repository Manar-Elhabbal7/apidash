import 'package:args/command_runner.dart';

const String kInfoColor = '\x1B[34m';
const String kErrorColor = '\x1B[31m';
const String kSuccessColor = '\x1B[32m';
const String kResetColor = '\x1B[0m';

abstract class BaseCommand extends Command<int> {
  void info(String message) => print('$kInfoColor$message$kResetColor');
  void success(String message) => print('$kSuccessColor$message$kResetColor');
  void error(String message) => print('$kErrorColor$message$kResetColor');

  Never fail(String message) => throw Exception(message);
}
