part of audio;

class Song {

  AudioManager _mgr;
  AudioBufferSourceNode _source;
  AudioTrack _track;

  Song.fromSource(this._mgr, this._source, this._track);

  void play([int n = 0]) {
    // check state
    this._source.start(n);
  }

  void loop([int n = 0]) {
    this._source.loop = true;
    this._source.start(n);
  }

  void stop([int n = 0]) {
    this._source.loop = false;
    this._source.stop(n);
  }
}
