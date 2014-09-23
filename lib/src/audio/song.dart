part of audio;

class Song {

    AudioBufferSourceNode _source;
    AudioBuffer _buffer;
    AudioTrack _track;
    bool _started;

    Song.fromSource(this._buffer, this._track) : this._started = false;

    void play([int n = 0]) {

        this._source = this._track.getAudioSource(this._buffer);

        // check state
        if (this._track.state == on) {
            this._source.loop = false;
            this._source.start(n);
            this._started = true;
        }
    }

    void loop([int n = 0]) {
        this._source = this._track.getAudioSource(this._buffer);

        if (this._track.state == on) {
            this._source.loop = true;
            this._source.start(n);
            this._started = true;
        }
        print("loop returning");
    }

    void stop([int n = 0]) {

        if (null == this._source) {
            return;
        }

        this._source.loop = false;

        if (this._started) {
            this._source.stop(n);
            this._started = false;
        }
    }
}
