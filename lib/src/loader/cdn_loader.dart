part of loader;

class CdnLoader {

    bool _loaded = false;

	List<String> _cdnHosts;
	String _assetsPath = '/';
	int _version;

	List<Loader> _cdnLoaders;
	Map<String, dynamic> _assets;

	StreamController<int> _loadQueueProgressStream;
	StreamController<int> _loadQueueResizeStream;

	String _manifestFileName = 'manifest.json';

	CdnLoader(this._cdnHosts, this._version) {

	    this._assets = new Map<String, dynamic>();

	    this._loadQueueResizeStream = new StreamController<int>();
	    this._loadQueueProgressStream = new StreamController<int>();

		this._initCdnLoaders();
	}

	Stream get loadQueueResizeStream => this._loadQueueResizeStream.stream;
	Stream get loadQueueProgressStream => this._loadQueueProgressStream.stream;

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

		this._loadQueueResizeStream.add(1);

		JsonResource manifestResource = new JsonResource("/assets/${this._manifestFileName}");
		return l.load(manifestResource)
			.then(this._loadManifestAssets)
			.then((var _) {
                this._loaded = true;
                return new Future.delayed(new Duration());
            });
	}

	Future _loadManifestAssets(JsonResource manifestResource) {

		Future f = Future.forEach(manifestResource.data['assets'], (Map resData) {
            
			this._loadQueueResizeStream.add(1);

            Loader l = this._getCdnLoader();
            Resource res = new Resource.fromType(resData['type'], resData['uri']);
            Future f = l.load(res)
                    .then((Resource r) {
                    	this._saveResourceData(r, resData);
                    	this._loadQueueProgressStream.add(1);
                    });
            return f;
		});

		this._loadQueueProgressStream.add(1);

		return f;
	}

	void _saveResourceData(Resource res, Map resData) {
		this._assets[resData['id']] = res.data;
	}

	getAsset(String id) {

		return this._assets[id];
	}
}