abstract class CRUD<T> {
  Future<T> addItem(T item);
  Future<void> deleteItem(String item);
  Future<T> updateItem(T item);
  Future<List<T>> findItems();
  Future<T> findItem(String id);
}
