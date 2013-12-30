part of audio;

class Song {

  AudioManager _mgr;
  AudioBufferSourceNode _source;

  Song.fromSource(this._mgr, this._source);

  void play() {
    this._source.noteOn(0);
  }

  void loop() {
    this.play();
  }
}
