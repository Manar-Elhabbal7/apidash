import 'package:apidash_cli/models/request_model.dart';
import 'package:apidash_cli/services/hive_cli_services.dart';
import '../cli/base_command.dart';

class HistoryCommand extends BaseCommand {
  HistoryCommand() {
    argParser
      ..addOption('workspace', abbr: 'w', help: 'Path to API Dash workspace')
      ..addOption('limit', abbr: 'l', help: 'Limit number of history items to show')
      ..addFlag('clear', help: 'Clear all request history', negatable: false)
      ..addOption('delete', help: 'Delete a specific request by ID');
  }

  @override
  String get name => 'history';

  @override
  String get description => 'Manage and view request history';

  @override
  Future<int> run() async {
    final workspace = argResults!['workspace'] as String? ?? '.apidash';
    await hiveHandler.initWorkspaceStore(workspace);

    // Clear history if --clear flag is provided
    if (argResults!['clear'] == true) {
      await hiveHandler.setIds([]);
      success('History cleared');
      return 0;
    }

    // Delete a specific request by ID
    final deleteId = argResults!['delete'] as String?;
    if (deleteId != null) {
      await hiveHandler.delete(deleteId);
      success('Deleted request $deleteId from history');
      return 0;
    }

    // Get IDs from Hive
    final ids = hiveHandler.getIds();
    if (ids == null || ids.isEmpty) {
      info('No history found');
      return 0;
    }

    // Deduplicate by URL + method instead of just ID
    final seen = <String>{}; // Set to track unique requests
    final uniqueIds = <String>[]; // List to store deduplicated IDs

    for (var id in ids) {
      final json = await hiveHandler.getRequestModel(id);
      if (json != null) {
        final key = '${json['method']}-${json['url']}';
        if (!seen.contains(key)) {
          seen.add(key);
          uniqueIds.add(id);
        }
      }
    }

    // Update Hive IDs after removing duplicates
    await hiveHandler.setIds(uniqueIds);

    // Limit number of items to display
    var limitStr = argResults!['limit'] as String?;
    int limit = limitStr != null ? int.tryParse(limitStr) ?? uniqueIds.length : uniqueIds.length;
    final displayIds = uniqueIds.take(limit).toList();

    info('Showing last ${displayIds.length} requests:');
    print('-' * 40);

    // Display request history
    for (var id in displayIds) {
      final json = await hiveHandler.getRequestModel(id);
      if (json != null) {
        final request = RequestModel.fromJson(json);
        print('[${request.method.name.toUpperCase()}] ${request.name}');
        print('URL: ${request.url}');
        print('ID:  ${request.id}');
        if (request.response != null) {
           print('Res: ${request.response!.statusCode}');
        }
        print('-' * 40);
      }
    }

    return 0;
  }
}