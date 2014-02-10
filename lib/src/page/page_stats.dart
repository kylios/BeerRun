part of page;

class PageStats {

	DivElement _container;
	
	Map<String, Element> _statElements;
	Map<String, dynamic> _stats;
	Map<String, int> _timers;

	PageStats(this._container) : 
		this._statElements = new Map<String, Element>(),
		this._stats = new Map<String, dynamic>(),
		this._timers = new Map<String, int>();

	Future setStat(String statName, var statValue) {
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

	// Return future is an option if we must...
	void writeAll() {

		this._stats.forEach((String key, var value) {
			Element el = this._statElements[key];
			if (null != el) {
				el.setAttribute("value", value.toString());
			}
		});
	}
}