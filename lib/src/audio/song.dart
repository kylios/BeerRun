part of audio;

class Song {

  AudioManager _mgr;
  AudioBufferSourceNode _source;

  Song.fromSource(this._mgr, this._source);

  void play() {
    this._source.start(0);
  }

  void loop([int num]) {
    this._source.loop = true;
    this._source.start(0);
  }
}
