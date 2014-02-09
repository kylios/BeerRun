part of loader;

class Loader {

  String _prefix;

  Loader([this._prefix = null]);

  Future<Map> load(String url) {

    Completer<Map> c = new Completer<Map>();

    if (null != this._prefix) {
        url = "${this._prefix}$url";
    }
    window.console.log("Loading $url");
    HttpRequest.requestCrossOrigin(url,
            method: 'GET'/*,
            withCredentials: false,
            responseType: 'application/json'*/)
      .then((String res /*HttpRequest r*/) {
        //String res = r.responseText;
        Map json = JSON.decode(res);
        c.complete(json);
      });

    return c.future;
  }
}