part of loader;

class Loader {

  Future<Map> load(String url) {

    Completer<Map> c = new Completer<Map>();

    HttpRequest.request(url)
      .then((HttpRequest r) {
        String res = r.responseText;
        Map json = JSON.decode(res);
        c.complete(json);
      });

    return c.future;
  }
}