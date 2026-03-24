import 'package:hive_ce/hive_ce.dart';
const String kHistoryMetaBox = "apidash-history-meta";
const String kHistoryLazyBox = "apidash-history-lazy";
const String kHistoryBoxIds = "historyIds";

class HiveHandler {
  late Box _metaBox;
  late LazyBox _lazyBox;
  bool _initialized = false;

  Future<void> initWorkspaceStore(String path) async {
    if (_initialized) return;

    Hive.init(path);
    _metaBox = await Hive.openBox(kHistoryMetaBox);
    _lazyBox = await Hive.openLazyBox(kHistoryLazyBox);
    _initialized = true;
  }

  Future<void> close() async {
    if (!_initialized) return;
    await _metaBox.close();
    await _lazyBox.close();
    await Hive.close();
    _initialized = false;
  }

  Future<void> setRequestModel(String id, Map<String, dynamic> json) async {
    await _lazyBox.put(id, json);

    final rawIds = _metaBox.get(kHistoryBoxIds) as List?;
    final List<String> ids = rawIds?.map((e) => e.toString()).toList() ?? [];
    if (!ids.contains(id)) {
      ids.insert(0, id);
      await _metaBox.put(kHistoryBoxIds, ids);
    }
  }

  Future<Map<String,dynamic>?> getRequestModel(String id) async {
    final json = await _lazyBox.get(id);
    if (json == null) return null;
    return Map<String,dynamic>.from(json as Map<dynamic, dynamic>);
  }

  Future<void> delete(String id) async {
    await _lazyBox.delete(id);
    final List<String> ids = (_metaBox.get(kHistoryBoxIds) as List?)?.cast<String>() ?? [];
    ids.remove(id);
    await _metaBox.put(kHistoryBoxIds, ids);
  }

  Future<void> setIds(List<String> ids) async {
    await _metaBox.put(kHistoryBoxIds, ids);
  }

  List<String>? getIds() {
    return (_metaBox.get(kHistoryBoxIds) as List?)?.cast<String>();
  }
}

final hiveHandler = HiveHandler();