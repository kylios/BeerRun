/*

Game Loads
	|
	|	<- *synchronous*
	v
read config data from page
	|
	|
	v
download manifest
	|
	|
	v
download, validate and decode assets in manifest
	|
	|	[download levels]		[download sprites]
	|				*asynchronous*
	|		[decode audio]		[instantiate levels]
	|
	|	<- *synchronous*
	V
instantiate levels
	|
	|	[level1]	[level2]	[level3]	[level4]
	|
	|	<- *synchronous*
	V
start game






*/

/*
abstract class Resource {

	final String uri;
	String method = 'GET';
	List<String> headers = new List<String>();
	final ResourceLoadedCallback callback;

	Resource({this.uri, this.callback, [this.errorCallback]});


}
*/

/**
 * Represents a job that should be run asynchronously inside of
 * a JobCollection.  A JobCollection is a pool of LoaderJob
 * instances that is itself synchronous with other JobCollection
 * instances, but which lets the pool add additional LoaderJob
 * instances to run within the collection.
 *
 *
 *
 *
 */

/*
typedef Future LoaderJobFunc(JobCollection collection, var data);

class LoaderJob {

	LoaderJobFunc _func;
	var _data;

	LoaderJob(this._func, [this._data = null]);

	Future run(JobCollection collection) {
		return this._func(collection, data);
	}
}

abstract class HttpRequestJob extends LoaderJob {

	Resource _resource;
	HttpRequestCallback _successCallback;
	HttpRequestCallback _errorCallback;

	HttpRequestJob(this._resource, this._successCallback, [this._errorCallback]);

	Future run(JobCollection collection) {

		Completer c = new Completer();
		HttpRequest.requestCrossOrigin(this._resource.url,
			method: this._resource.method
		).then((String res) {

			/*
			TODO: read status code
			*/

			Map json = JSON.decode(res);

			LoaderJob decodeResource = new LoaderJob((JobCollection collection, var json) {
				this.decodeResourceData(json);
			});

			c.complete(json);
		});

		return c.future;
	}

	/**
	 * abstract async function.
	 */
	Future decodeResourceData(Map data);
}

class JobCollection {

	Completer<JobCollection> _completer;

	List<LoaderJob> _jobs = new List<LoaderJob>();

	JobCollection();

	void addJob(LoaderJob job) {
		if (this._completer == null) {
			this._jobs.add(job);
		} else {
			this._startJob(job);
		}
	}

	Future<JobCollection> run() {
		if (this._completer == null) {
			this._completer = new Completer<JobCollection>();

    		this._jobs.forEach((LoaderJob job) => this._startJob(job));
		}

		return this._completer.future;
	}

	void _startJob(LoaderJob job) {
		this._runningJobs++;
		job.run(this).then((var _) {
			if (--this._runningJobs <= 0) {
				this._completer.complete();
			}
		});
	}
}

class Loader {

	List<JobCollection> _collections = new List<JobCollection>();

	Loader();

	void addJobCollection(JobCollection collection) {
		this._collections.add(collection);
	}

	Future run() {

		Future f = new Future(() => null);
		this._collections.foreach((JobCollection collection) {
			f = f.then((var _) => collection.run());
		});

		return f;
	}
}

// download manifest

Loader l = new Loader();

JobCollection downloadManifestCollection = new JobCollection();
LoaderJob downloadManifestJob = new HttpRequestJob(new JsonResource(uri: '/manifest.json'));












loader.load(new JsonResource(uri: "/manifest.json", callback: processManifest));

processManifest(Loader loader, Resource resource) {

	Response response = resource.response;

	ASSERT(response.isComplete);

	Map manifestResources = requireKey(response, 'resources');
	manifestResources.foreach(String key, Map manifestResource) {

		String uri = requireKey(manifestResource, 'uri');
		String md5sum = requireKey(manifestResource, 'md5sum');

		loader.load(new JsonResource(uri: uri, callback: (Loader _, Resource resourceData) {
			addManifestResource(1, md5sum, key, resourceData);
		}));

	}
}

addManifestResource(int tries, String md5sum, String name, Resource resource) {

	// Make sure it downloaded ok
	if (md5sum != resource.md5sum) {
		if (tries >= MAX_DOWNLOAD_TRIES && ) {
			throw new Exception();
		} else {
			// retry
		}

		loader.load(resource, callback: () /* TODO */);
	}

	// Add to our global resource manager
	addResourceData(name, resource.data);
}

*/