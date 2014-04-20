part of loader;

class CdnLoader {

	List<String> _cdnHosts;
	String _assetsPath = '/';
	int _version;

	List<Loader> _cdnLoaders;
	Map<String, dynamic> _assets;

	String _manifestFileName = 'manifest.json';

	CdnLoader(this._cdnHosts, this._version) {

	    this._assets = new Map<String, dynamic>();

		this._initCdnLoaders();
	}

	void _initCdnLoaders() {

		this._cdnLoaders = new List<Loader>();

		for (String host in this._cdnHosts) {
			this._cdnLoaders.add(new Loader(host));
		}
	}

	Loader _getCdnLoader() {

		Random r = new Random();
		return this._cdnLoaders[r.nextInt(this._cdnLoaders.length)];
	}

	Future loadManifest() {

		Loader l = this._getCdnLoader();

		JsonResource manifestResource = new JsonResource("/assets/${this._manifestFileName}");
		return l.load(manifestResource)
			.then(this._loadManifestAssets);
	}

	Future _loadManifestAssets(JsonResource manifestResource) {

		for (Map resData in manifestResource.data['assets']) {
			Loader l = this._getCdnLoader();
			l.load(new Resource(resData['uri']))
				.then((Resource res) => this._saveResourceData(res, resData));
		}

		return Future.wait(this._cdnLoaders.map((Loader l) => l.wait()));
	}

	void _saveResourceData(Resource res, Map resData) {
		this._assets[resData['id']] = res.data;
	}
}