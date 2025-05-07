import 'package:hive/hive.dart';
import '../../../models/card.dart';

class CardModelAdapter extends TypeAdapter<CardModel> {
  @override
  final int typeId = 0;

  @override
  CardModel read(BinaryReader reader) {
    return CardModel(
      uniqueId: reader.readString(),
      cardholderName: reader.readString(),
      last4Digits: reader.readString(),
      status: reader.readString(),
      createdAt: reader.readDateTime(),
      updatedAt: reader.readDateTime(),
    );
  }

  @override
  void write(BinaryWriter writer, CardModel obj) {
    writer.writeString(obj.uniqueId);
    writer.writeString(obj.cardholderName);
    writer.writeString(obj.last4Digits);
    writer.writeString(obj.status);
    writer.writeDateTime(obj.createdAt);
    writer.writeDateTime(obj.updatedAt);
  }
}
