part of loader;

class Loader {

	String _host;

	Loader(this._host);
	
	Future<Resource> load(String uri, 
			loaderCallback callback, [loaderCallback errorCallback = null]) {

		Resource resource = new Resource(uri);

		Completer<Resource> c = new Completer<Resource>();

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
			callback(resource);

			c.complete(resource);
		})
		.catchError((HttpRequest request) {
			window.console.log("caught error in request: ${uri}");
			if (null != resource._receiveServerError) {
				resource._receiveServerError(request);
			}
			callback(resource);

			c.complete(resource);
		})
		;

		return c.future;
	}

	String _getUrlString(String uri) {
		return "http://${this._host}${uri}";
	}


}