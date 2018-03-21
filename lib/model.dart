import 'dart:async';

abstract class Restorable {
  save(String key);
  Future<Restorable> restore(String key);
  isInitialized();
}