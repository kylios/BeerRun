part of old_loader;

abstract class Asset<T extends Parsable<T>> {

  bool _loaded = false;
  T _val;

  Future<T> get(Resource r) {
    if (this._loaded) {
      return new Future.delayed(new Duration(), () => this._val);
    } else {
      Completer<T> c = new Completer<T>();
      r.load()
        .then((Parsable p) {
          c.complete(p.parsed);
        });
    }
  }
}