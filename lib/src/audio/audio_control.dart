part of audio;

abstract class AudioControl {

  List<AudioEventListener> _listeners = new List<AudioEventListener>();

  void addListener(AudioEventListener l) {
    this._listeners.add(l);
  }

  void changeMusicVolume(double vol) {
    for (AudioEventListener l in this._listeners) {
      l.onMusicVolumeChange(vol);
    }
  }
  void changeSoundVolume(double vol) {
    for (AudioEventListener l in this._listeners) {
      l.onSoundVolumeChange(vol);
    }
  }
}