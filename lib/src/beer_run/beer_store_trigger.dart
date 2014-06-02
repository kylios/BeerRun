part of beer_run;

class BeerStoreTrigger extends Trigger {

	bool _isTriggered = false;
	
	BeerStoreTrigger(int numBeers, int row, int col) :
		super(new GameEvent(GameEvent.BEER_STORE_EVENT, numBeers), row, col);

	GameEvent trigger(GameObject o) {
		this._isTriggered = true;
		return super.event;
	}

	bool get isTriggered => this._isTriggered;
}