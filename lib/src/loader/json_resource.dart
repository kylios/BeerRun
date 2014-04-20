part of loader;

class JsonResource extends Resource {

	JsonResource(String uri, {String method: null}) :
		super(uri, method: method, responseType: 'application/json');
	
	_decode(HttpRequest request) {
		return JSON.decode(request.response);
	}
}