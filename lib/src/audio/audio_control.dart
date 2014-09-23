part of audio;

class AudioControl {

    AudioTrack _track;
    InputElement _toggleOn;
    InputElement _toggleOff;

    AudioControl(this._toggleOn, this._toggleOff) {

        var self = this;
        this._toggleOn.onClick.listen(this.onClick);
        this._toggleOff.onClick.listen(this.onClick);
    }

    void setTrack(AudioTrack track) {
        this._track = track;
    }

    void toggleOn() {
        this._toggleOn.click();
    }
    void toggleOff() {
        this._toggleOff.click();
    }

    void onClick(Event e) {
        InputElement clicked = e.target;
        double vol = int.parse(clicked.value) / 100;

        window.console.log("Element clicked: $vol");

        this._track.setVolume(vol);
    }
}
