part of audio;

class Song {

  AudioBufferSourceNode _source;
  AudioBuffer _buffer;
  AudioTrack _track;

  Song.fromSource(this._buffer, this._track);

  void play([int n = 0]) {
    // check state
    if (this._track.state == on) {
      this._source = this._track.getAudioSource(this._buffer);
      this._source.start(n);
    }
  }

  void loop([int n = 0]) {
    if (this._track.state == on) {
      this._source = this._track.getAudioSource(this._buffer);
      this._source.loop = true;
      this._source.start(n);
    }
    print("loop returning");
  }

  void stop([int n = 0]) {
    
    this._source.loop = false;

    if (null == this._source) {
      return;
    }
    this._source.stop(n);
  }
}
