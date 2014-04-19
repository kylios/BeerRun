part of async_extended;

class Synchronizer<T> {
	
	Completer<T> _c;
	int _counter;

	Future<T> _curFuture;
	int _curCount;

	Synchronizer() : 
		  this._c = new Completer<T>()
		, this._counter = 0
		, this._curCount = 0
		;

	Synchronizer<T> add(synchronousFunction func) {

		Completer<T> addCompleter = new Completer<T>();
		this._curFuture = addCompleter.future;
		Future f = Future.delayed(0)
			.then(func)
			.then((T data) {
				this._curCount--;

				if (0 == this._curCount) {
					this._c.complete(data);
				}

				return addCompleter.complete(data);
			});

		this._curCount++;

		return this;
	}

	Synchronizer<T> chain(synchronousFunction func) {

		this._curCount++;
		this._curFuture	.then(func)
						.then((T) {
							this._curCount--;
							if (this._curCount == 0) {
								this._c.complete(T);
							}
						});
		return this;
	}

	Future<T> wait() {
		return this._c.future;
	}
}