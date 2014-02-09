part of audio;

class AudioToggle extends AudioControl {

  bool _isMusic;
  InputElement _toggleOn;
  InputElement _toggleOff;

  AudioToggle(this._isMusic, this._toggleOn, this._toggleOff) {

    var self = this;
    this._toggleOn.onClick.listen(this.onClick);
    this._toggleOff.onClick.listen(this.onClick);
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

    this._setVolume(vol);
  }

  void _setVolume(double vol) {
    if (this._isMusic) {
      this.changeMusicVolume(vol);
    } else {
      this.changeSoundVolume(vol);
    }
  }
}