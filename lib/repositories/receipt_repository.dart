import 'package:hive/hive.dart';
import '../core/hive/sync_metadata.dart';
import '../models/receipt.dart';

class ReceiptRepository {
  final _box = Hive.box<ReceiptModel>('receiptsBox');

  Future<void> syncReceipts(List<Map<String, dynamic>> remoteReceipts) async {
    final lastSync = SyncMetadata.getLastSync('receipts') ?? DateTime.fromMillisecondsSinceEpoch(0);

    final newReceipts = remoteReceipts
        .map((e) => ReceiptModel.fromMap(e))
        .where((r) => r.updatedAt.isAfter(lastSync))
        .toList();

    for (var receipt in newReceipts) {
      final key = '${receipt.userId}-${receipt.timestamp.toIso8601String()}';
      await _box.put(key, receipt);
    }

    if (newReceipts.isNotEmpty) {
      final latest = newReceipts.map((e) => e.updatedAt).reduce((a, b) => a.isAfter(b) ? a : b);
      await SyncMetadata.setLastSync('receipts', latest);
    }
  }

  List<ReceiptModel> getLocalReceipts() {
    return _box.values.toList();
  }

  Future<void> saveReceipt(ReceiptModel receipt) async {
    final key = '${receipt.userId}-${receipt.timestamp.toIso8601String()}';
    await _box.put(key, receipt);
  }

  ReceiptModel? getReceipt(String key) {
    return _box.get(key);
  }

  Future<void> deleteReceipt(String id) async {
    await _box.delete(id);
  }
}