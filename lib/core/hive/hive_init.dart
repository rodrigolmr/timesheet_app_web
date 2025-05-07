import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/card.dart';
import 'adapters/card_adapter.dart';

Future<void> initHive() async {
  await Hive.initFlutter();

  Hive.registerAdapter(CardModelAdapter());

  await Hive.openBox<CardModel>('cardsBox');
  await Hive.openBox<DateTime>('syncMetadataBox');
}
