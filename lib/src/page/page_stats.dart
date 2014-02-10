part of page;

class PageStats {

	static const MOVING_AVERAGE_POOL_SIZE = 100;

	DivElement _container;
	
	Map<String, Element> _statElements;
	Map<String, dynamic> _stats;
	Map<String, int> _timers;
	Map<String, Queue<num>> _averages;
	Map<String, num> _averageSums;

	PageStats(this._container) : 
		this._statElements = new Map<String, Element>(),
		this._stats = new Map<String, dynamic>(),
		this._timers = new Map<String, int>(),
		this._averages = new Map<String, Queue<num>>(),
		this._averageSums = new Map<String, num>();

	Future setStat(String statName, var statValue) {

		if (this._averages[statName] != null) {
			statValue = this._advanceAverage(statName, statValue);
		} 
		this._stats[statName] = statValue;

		Completer c = new Completer();
		Timer.run(() {
			if (null == this._statElements[statName]) {
				Element el = this._container.querySelector("#$statName");
				if (null == el) {
					el = this._createStatElement(statName);
					this._container.append(el);
				}
				//el.setAttribute("value", statValue);
				this._statElements[statName] = el.querySelector('input');
			}
			c.complete();
		});

		return c.future;
	}

	Element _createStatElement(String statName) {
		Element inputEl = new Element.tag('input');
		inputEl.setAttribute("readonly", "readonly");
		inputEl.setAttribute("type", "text");
		inputEl.id = statName;

		Element container = new Element.div();
		container.appendHtml(statName);
		container.append(inputEl);

		return container;
	}

	void startTimer(String statName) {
		this._timers[statName] = new DateTime.now().millisecondsSinceEpoch;
	}

	Future stopTimer(String statName) {
		int time = new DateTime.now().millisecondsSinceEpoch;
		int elapsed = time - this._timers[statName];
		return this.setStat(statName, elapsed);
	}

	void startMovingAverage(String statName) {
		this._averages[statName] = new Queue<num>();
		this._averageSums[statName] = 0;
	}

	num _advanceAverage(statName, statValue) {
		if (this._averages[statName].length >= PageStats.MOVING_AVERAGE_POOL_SIZE) {
			num n = this._averages[statName].removeLast();
			this._averageSums[statName] -= n;
		}

		this._averages[statName].addFirst(statValue);
		this._averageSums[statName] += statValue;

		return this._averageSums[statName] / this._averages[statName].length;
	}

	// Return future is an option if we must...
	void writeAll() {

		this._stats.forEach((String key, var value) {
			this.writeStat(key);
		});
	}

	void writeStat(String statName) {
		Element el = this._statElements[statName];
		num value = this._stats[statName];
		if (null != el) {
			el.setAttribute("value", value.toString());
		}
	}
}