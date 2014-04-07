part of audio;

class AudioTrack {
	
	final String name;
	AudioContext _ctx;
	final GainNode gain;
	AudioState _state;
	List<Song> _songs = new List<Song>();

	AudioTrack(this.name, this._ctx, this.gain, this._state);

	AudioState get state => this._state;

	void set state(AudioState state) {
		print("Setting state: $state");
		this._state = state;
		if (this._state == off) {
			this._songs.forEach((Song s) => s.stop());
		};
	}

	AudioBufferSourceNode getAudioSource(AudioBuffer buffer) {

		AudioBufferSourceNode source = this._ctx.createBufferSource();
        source.connectNode(this.gain, 0, 0);
        gain.connectNode(this._ctx.destination, 0, 0);
        source.buffer = buffer;

        return source;
	}

	void setVolume(double percent) {
		if (null == this.gain.gain.maxValue) {
			return;
		}
		double newVal = this.gain.gain.maxValue * percent;
		window.console.log("new vol: $newVal");
		this.gain.gain.value = newVal;
	}

	void addSong(Song song) {
		this._songs.add(song);
		song._track = this;
	}
}