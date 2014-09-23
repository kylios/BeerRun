part of old_loader;

abstract class Resource<Parsable> {

    Future<Parsable> load();
}
