/// Interface for models that support field cleaning
abstract class CleanableModel {
  /// Returns a list of field names that should be cleaned before saving
  List<String> get cleanableFields;
  
  /// Converts the model to JSON
  Map<String, dynamic> toJson();
}

/// Interface genérica para repositórios de acesso a dados
abstract class BaseRepository<T> {
  /// Obtém um documento por ID
  Future<T?> getById(String id);
  
  /// Obtém todos os documentos
  Future<List<T>> getAll();
  
  /// Cria um novo documento
  Future<String> create(T entity);
  
  /// Atualiza um documento existente
  Future<void> update(String id, T entity);
  
  /// Exclui um documento
  Future<void> delete(String id);
  
  /// Stream de documentos para atualizações em tempo real
  Stream<List<T>> watchAll();
  
  /// Stream de um documento para atualizações em tempo real
  Stream<T?> watchById(String id);
}