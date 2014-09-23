part of loader;

class Resource {

    // These members should get set before a request is made
    String _uri;
    String _method = 'GET';
    String _responseType = 'application/json';
    Map<String, String> _requestHeaders = null;

    String get uri => this._uri;
    String get method => this._method.toUpperCase();
    String get responseType => this._responseType;
    Map<String, String> get requestHeaders => this._requestHeaders;

    // These members are set by the Resource class or the Loader class
    int statusCode = 0;
    Map<String, String> responseHeaders = null;
    var response = null;
    var data = null;

    factory Resource.fromType(String type, String uri) {

        if (type == "json") {
            return new JsonResource(uri);
        } else if (type == "binary") {
            return new Resource(uri, method: 'GET', responseType: 'arraybuffer'
                    );
        }
        throw new Exception("Resource: Type '$type' is not supported.");
    }

    Resource(this._uri, {String method: null, String responseType: null}) {

        if (method != null) {
            this._method = method.toUpperCase();
        }
        if (responseType != null) {
            this._responseType = responseType;
        }
    }

    void setHeader(String header, String value) {
        if (this._requestHeaders == null) {
            this._requestHeaders = new Map<String, String>();
        }
        this._requestHeaders[header] = value;
    }

    void _receiveServerResponse(HttpRequest request) {

        this.statusCode = request.status;
        this.responseHeaders = request.responseHeaders;
        this.response = request.response;

        this.data = this._decode(request);

        if (this.data is String) {
            window.console.log("${this._uri} returned a String");
        } else if (this.data is ByteBuffer) {
            window.console.log("${this._uri} returned a ByteBuffer");
        } else if (this.data is Document) {
            window.console.log("${this._uri} returned a Document");
        } else if (this.data is Blob) {
            window.console.log("${this._uri} returned a Blob");
        } else {
            window.console.log("${this._uri} returned an unknown type");
        }
    }

    void _receiveServerError(HttpRequest request) {

        this.statusCode = request.status;
        this.responseHeaders = request.responseHeaders;
        this.response = request.response;

        this.data = this._decode(request);
    }

    _decode(HttpRequest request) {

        return request.response as ByteBuffer;
    }
}
