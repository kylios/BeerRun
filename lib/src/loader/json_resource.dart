part of loader;

class JsonResource extends Resource {

	JsonResource(String uri, {String method: null}) :
		super(uri, method: method, responseType: 'application/json');
	
	void _decode(HttpRequest request) {
		this.response = JSON.decode(request.response);
	}
}