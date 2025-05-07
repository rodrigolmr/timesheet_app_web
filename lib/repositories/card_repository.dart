import 'package:hive/hive.dart';
import '../core/hive/sync_metadata.dart';
import '../models/card.dart';

class CardRepository {
  final _box = Hive.box<CardModel>('cardsBox');

  Future<void> syncCards(List<Map<String, dynamic>> remoteCards) async {
    final lastSync =
        SyncMetadata.getLastSync('cards') ??
        DateTime.fromMillisecondsSinceEpoch(0);

    final newCards =
        remoteCards
            .map((e) => CardModel.fromMap(e))
            .where((card) => card.updatedAt.isAfter(lastSync))
            .toList();

    for (var card in newCards) {
      _box.put(card.uniqueId, card);
    }

    if (newCards.isNotEmpty) {
      final latest = newCards
          .map((e) => e.updatedAt)
          .reduce((a, b) => a.isAfter(b) ? a : b);
      await SyncMetadata.setLastSync('cards', latest);
    }
  }

  List<CardModel> getLocalCards() {
    return _box.values.toList();
  }

  Future<void> saveCard(CardModel card) async {
    await _box.put(card.uniqueId, card);
  }

  CardModel? getCard(String id) {
    return _box.get(id);
  }
}
