part of audio;

class AudioTrack {
	
	final String name;
	final GainNode gain;
	AudioState state;

	AudioTrack(this.name, this.gain, AudioState this.state);

	void setVolume(double percent) {
		double newVal = this.gain.gain.maxValue * percent;
		window.console.log("new vol: $newVal");
		this.gain.gain.value = newVal;
	}
}