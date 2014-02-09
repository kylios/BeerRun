part of audio;

class AudioManager implements AudioEventListener {

  AudioContext _ctx = new AudioContext();
  Map<String, String> _musicPaths = new Map<String, String>();
  Map<String, String> _soundPaths = new Map<String, String>();
  Map<String, Song> _sounds = new Map<String, Song>();

  GainNode _musicGain;
  GainNode _soundGain;

  AudioManager() {
    this._musicGain = this._ctx.createGain();
    this._soundGain = this._ctx.createGain();
  }

  void addMusic(String id, String url) {
    this._musicPaths[id] = url;
  }
  void addSound(String id, String url) {
    this._soundPaths[id] = url;
  }

  Future _loadAndDecodeInternal(Map<String, String> sounds, GainNode gain) {

    Completer c = new Completer();

    int count = sounds.keys.length;
    if (count == 0) {
      Timer.run(() => c.complete() );
    }

    for (String id in sounds.keys) {
      String url = sounds[id];
      window.console.log("Loading song: ${id}: ${url}");

      HttpRequest.request(url, method: 'GET', responseType: 'arraybuffer').then((request) {

          window.console.log("loaded audio: $id");
          ByteBuffer data = request.response;

          AudioBufferSourceNode source;
          this._ctx.decodeAudioData(data)
            .then((AudioBuffer buffer) {
              source = this._ctx.createBufferSource();
              source.connectNode(gain, 0, 0);
              gain.connectNode(this._ctx.destination, 0, 0);
              source.buffer = buffer;

              Song s = new Song.fromSource(this, source);

              // Save the newly constructed song and decrement the counter
              this._sounds[id] = s;
              count--;

              // If they've all been loaded, complete the future
              if (count == 0) {
                c.complete();
              }
            });
          });
    }

    return c.future;
  }

  Future loadAndDecode() {

    Completer c = new Completer();

    Future f1 = this._loadAndDecodeInternal(this._musicPaths, this._musicGain);
    Future f2 = this._loadAndDecodeInternal(this._soundPaths, this._soundGain);

    f1.then((var _) => f2.then((var _) => c.complete() ) );

    return c.future;
  }

  Song getSong(String id) {
    return this._sounds[id];
  }

  void _setVolume(double percent, GainNode gain) {
    double newVal = gain.gain.maxValue * percent;
    window.console.log("new vol: $newVal");
    gain.gain.value = newVal;
  }

  void setMusicVolume(double percent) {
    this._setVolume(percent, this._musicGain);
  }

  void setSoundVolume(double percent) {
    this._setVolume(percent, this._soundGain);
  }

  /**
   * Inherited from AudioEventListener
   */
  void onMusicVolumeChange(double percent) {
    this.setMusicVolume(percent);
  }
  void onSoundVolumeChange(double percent) {
    this.setSoundVolume(percent);
  }
}
