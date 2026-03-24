import 'dart:io';
import 'dart:convert';

const String kApidashFolderName = '.apidash';
const String kApidashConfigFileName = 'config.json';
const String kApidashConfigVersion = '1.0.0';
const String kApidashCollectionPath = 'collections';
const String kApidashEnvironmentPath = 'environments';
const String kApidashHistoryPath = 'history';
const String kApidashHistoryLazyPath = 'history-lazy';

class InitResult {
  const InitResult({
    required this.configPath,
    required this.created,
    this.overwritten = false, // FIX: added missing field
  });

  final String configPath;
  final bool created;
  final bool overwritten;
}

class ConfigService {
  Future<InitResult> initProject({
    Directory? workingDirectory,
    String? projectName,
    bool force = false,
  }) async {
    final cwd = workingDirectory ?? Directory.current;
    final apidashDirectory = Directory('${cwd.path}/$kApidashFolderName');
    final configFile = File('${apidashDirectory.path}/$kApidashConfigFileName');

    // Use current directory name if project name is null
    projectName ??= cwd.uri.pathSegments.lastWhere((s) => s.isNotEmpty, orElse: () => 'my-project');

    // FIX: check if config already exists and respect the force flag
    final alreadyExists = await configFile.exists();
    if (alreadyExists && !force) {
      return InitResult(
        configPath: configFile.path,
        created: false,        // blocked — nothing written
        overwritten: false,
      );
    }

    // FIX: create the .apidash directory (recursive in case cwd doesn't exist)
    await apidashDirectory.create(recursive: true);

    // FIX: scaffold all subdirectories defined in constants
    final subDirectories = [
      kApidashCollectionPath,
      kApidashEnvironmentPath,
      kApidashHistoryPath,
      kApidashHistoryLazyPath,
    ];

    for (final subDir in subDirectories) {
      final dir = Directory('${apidashDirectory.path}/$subDir');
      await dir.create(recursive: true);
    }

    // FIX: build and write actual config content to config.json
    final configContent = {
      'version': kApidashConfigVersion,
     'projectName': projectName,
      'createdAt': DateTime.now().toIso8601String(),
      'paths': {
        'collections': kApidashCollectionPath,
        'environments': kApidashEnvironmentPath,
        'history': kApidashHistoryPath,
        'historyLazy': kApidashHistoryLazyPath,
      },
    };

    await configFile.writeAsString(
      const JsonEncoder.withIndent('  ').convert(configContent),
    );

    return InitResult(
      configPath: configFile.path,
      created: true,
      overwritten: alreadyExists, // true only if we stomped an existing config
    );
  }
}