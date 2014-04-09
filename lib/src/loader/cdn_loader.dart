part of loader;

class CdnLoader extends Loader {
	
	List<String> _cdnHosts;
	String _assetsPath = '/';
	int _version;

	CdnLoader(this._cdnHosts, this._assetsPath, this._version);

	Future<Resource> load(String uri,
			loaderCallback callback, [loaderCallback errorCallback = null]) {

		String url = this._getAssetUrl(this._cdnHosts);

		return super.load(url, callback, errorCallback);
	}

	String _getAssetUrl(List<String> cdnHosts) {

		String url = '';
		if (cdnHosts.length > 0) {
			Random r = new Random();
			String cdnHost = cdnHosts[r.nextInt(cdnHosts.length)];
			url = "http://${cdnHost}${assetsPath}${version}/";
		}

		return url;
	}
}