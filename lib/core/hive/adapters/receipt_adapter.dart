import 'package:hive/hive.dart';
import '../../../models/receipt.dart';

class ReceiptModelAdapter extends TypeAdapter<ReceiptModel> {
  @override
  final int typeId = 1;

  @override
  ReceiptModel read(BinaryReader reader) {
    return ReceiptModel(
      userId: reader.readString(),
      cardLast4: reader.readString(),
      amount: reader.readString(),
      date: reader.readDateTime(),
      description: reader.readString(),
      imageUrl: reader.readString(),
      timestamp: reader.readDateTime(),
      updatedAt: reader.readDateTime(),
    );
  }

  @override
  void write(BinaryWriter writer, ReceiptModel obj) {
    writer.writeString(obj.userId);
    writer.writeString(obj.cardLast4);
    writer.writeString(obj.amount);
    writer.writeDateTime(obj.date);
    writer.writeString(obj.description);
    writer.writeString(obj.imageUrl);
    writer.writeDateTime(obj.timestamp);
    writer.writeDateTime(obj.updatedAt);
  }
}