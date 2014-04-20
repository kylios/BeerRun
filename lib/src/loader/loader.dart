part of loader;

class Loader {

	String _host;
	List<Future<Resource>> _futures;

	Loader(this._host) : 
		this._futures = new List<Future<Resource>>()
		;
	
	Future<Resource> load(Resource resource) {

		String uri = resource.uri;

		Completer<Resource> c = new Completer<Resource>();

		this._futures.add(c.future);

		window.console.log("started request: $uri");
		HttpRequest.request(
			this._getUrlString(resource.uri),
			method: resource.method,
			responseType: resource.responseType,
			requestHeaders: resource.requestHeaders
		)
		.then((HttpRequest request) {

			window.console.log("finished request: ${uri}");
			resource._receiveServerResponse(request);
			c.complete(resource);
		})
		.catchError((HttpRequest request) {
			window.console.log("caught error in request: ${uri}");
			if (null != resource._receiveServerError) {
				resource._receiveServerError(request);
			}
			c.complete(resource);
		})
		;

		return c.future;
	}

	Future<List<Resource>> wait() {
		return Future.wait(this._futures);
	}

	String _getUrlString(String uri) {
		return "http://${this._host}${uri}";
	}


}