import 'package:timesheet_app_web/src/features/pigtail/data/models/pigtail_model.dart';

abstract class PigtailRepository {
  Future<PigtailModel?> getById(String id);
  Future<List<PigtailModel>> getAll();
  Future<List<PigtailModel>> getByUserId(String userId);
  Future<String> create(PigtailModel pigtail);
  Future<void> update(String id, PigtailModel pigtail);
  Future<void> delete(String id);
  Stream<List<PigtailModel>> watchAll();
  Stream<List<PigtailModel>> watchByUserId(String userId);
  Stream<PigtailModel?> watchById(String id);
}