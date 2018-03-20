import 'dart:async';

abstract class Model {
  save(String key);
  Future<Model> restore(String key);
  isInitialized();
}