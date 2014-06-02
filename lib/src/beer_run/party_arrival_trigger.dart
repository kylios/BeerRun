part of beer_run;

class PartyArrivalTrigger extends Trigger {

    bool _isTriggered = false;

	PartyArrivalTrigger(GameEvent e, int row, int col) :
		super(e, row, col);

	GameEvent trigger(GameObject o) {
	    if ( ! this.isTriggered) {
	        this._isTriggered = true;
	        return this.event;
	    }
		return null;
	}

	bool get isTriggered => this._isTriggered;
}