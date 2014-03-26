part of audio;

class Song {

  AudioBufferSourceNode _source;
  AudioBuffer _buffer;
  AudioTrack _track;
  bool _started;

  Song.fromSource(this._buffer, this._track) : this._started = false {
      this._source = this._track.getAudioSource(this._buffer);
  }

  void play([int n = 0]) {
    // check state
    if (this._track.state == on) {
      this._source.loop = false;
      this._source.start(n);
      this._started = true;
    }
  }

  void loop([int n = 0]) {
    if (this._track.state == on) {
      this._source.loop = true;
      this._source.start(n);
      this._started = true;
    }
    print("loop returning");
  }

  void stop([int n = 0]) {

    this._source.loop = false;

    if (null == this._source) {
      return;
    }
    if (this._started) {
      this._source.stop(n);
      this._started = false;
    }
  }
}
