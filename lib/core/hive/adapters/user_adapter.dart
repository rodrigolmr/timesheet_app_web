import 'package:hive/hive.dart';
import '../../../models/user.dart';

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 4;

  @override
  UserModel read(BinaryReader reader) {
    return UserModel(
      userId: reader.readString(),
      email: reader.readString(),
      firstName: reader.readString(),
      lastName: reader.readString(),
      role: reader.readString(),
      status: reader.readString(),
      createdAt: reader.readDateTime(),
      updatedAt: reader.readDateTime(),
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer.writeString(obj.userId);
    writer.writeString(obj.email);
    writer.writeString(obj.firstName);
    writer.writeString(obj.lastName);
    writer.writeString(obj.role);
    writer.writeString(obj.status);
    writer.writeDateTime(obj.createdAt);
    writer.writeDateTime(obj.updatedAt);
  }
}