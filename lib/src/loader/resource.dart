part of loader;

abstract class Resource<Parsable> {

  Future<Parsable> load();
}