part of audio;

class AudioState {
	final String state;

	const AudioState(this.state);

	operator ==(AudioState state) => state.state == this.state;

	int get hashCode => this.state.hashCode;

	String toString() => "state:${this.state}";
	
}
