part of school_api;

@immutable
abstract class Model<T> {
  const Model();

  @protected
  const Model.fromMap(Map<String, dynamic> data);

  @protected
  Map<String, dynamic> toMap();
}
