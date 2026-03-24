import 'package:apidash_cli/services/hive_cli_services.dart';
import '../cli/base_command.dart';

class HistoryCommand extends BaseCommand {
  HistoryCommand() {
    argParser
      ..addOption('workspace', abbr: 'w', help: 'Path to API Dash workspace')
      ..addOption('limit', abbr: 'l', help: 'Limit the number of history items')
      ..addFlag('clear', help: 'Clear all request history', negatable: false)
      ..addOption('delete', help: 'Delete a specific request by ID');
  }

  @override
  String get name => 'history';

  @override
  String get description => 'Manage request history';

  @override
  Future<int> run() async {
    final workspace = argResults!['workspace'] as String? ?? '.apidash';
    final limit = int.tryParse(argResults!['limit'] as String? ?? '');
    final clear = argResults!['clear'] as bool;
    final deleteId = argResults!['delete'] as String?;

    await hiveHandler.initWorkspaceStore(workspace);

    // Clean up duplicate IDs in index if any
    final ids = hiveHandler.getIds() ?? [];
    final uniqueIds = ids.toSet().toList();
    if (ids.length != uniqueIds.length) {
      await hiveHandler.setIds(uniqueIds);
    }

    if (clear) {
      for (var id in uniqueIds) {
        await hiveHandler.delete(id);
      }
      success('History cleared');
      return 0;
    }

    if (deleteId != null) {
      if (uniqueIds.contains(deleteId)) {
        await hiveHandler.delete(deleteId);
        success('Request $deleteId deleted');
      } else {
        error('Request $deleteId not found');
      }
      return 0;
    }

    final displayIds = limit != null ? uniqueIds.take(limit) : uniqueIds;

    if (displayIds.isEmpty) {
      info('No history found');
      return 0;
    }

    info('Recent Requests:');
    for (var id in displayIds) {
      final json = await hiveHandler.getRequestModel(id);
      if (json != null) {
        print('[$id] ${json['method']} ${json['url']}');
      }
    }

    return 0;
  }
}
