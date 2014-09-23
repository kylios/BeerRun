part of audio;

class AudioManager {

    CdnLoader _cdnLoader;

    AudioContext _ctx = new AudioContext();
    Map<String, String> _musicPaths = new Map<String, String>();
    Map<String, String> _soundPaths = new Map<String, String>();
    Map<String, Song> _sfx = new Map<String, Song>();

    Map<String, AudioTrack> _tracks = new Map<String, AudioTrack>();

    Map<String, List<Map<String, Map>>> _audioConfig = new Map<String,
            List<Map<String, Map>>>();

    AudioManager.fromConfig(this._cdnLoader, this._audioConfig);

    AudioTrack _createTrack(String trackName, double volume) {
        GainNode gain = this._ctx.createGain();
        AudioTrack track = new AudioTrack(trackName, this._ctx, gain, on);
        track.setVolume(volume);
        return track;
    }

    Future loadAndDecode() {

        return Future.forEach(this._audioConfig['sfx'], (Map sfxConfigData) {

            String id = sfxConfigData['id'];
            String name = sfxConfigData['name'];
            String trackName = sfxConfigData['track'];
            ByteBuffer data = this._cdnLoader.getAsset(id);

            if (this._tracks[trackName] == null) {
                this._tracks[trackName] = this._createTrack(trackName, 1.0);
            }

            AudioBufferSourceNode source;
            return this._ctx.decodeAudioData(data).then((AudioBuffer buffer) {
                AudioTrack track = this._tracks[trackName];

                Song s = new Song.fromSource(buffer, track);
                track.addSong(s);

                this._sfx[name] = s;

                return new Future.delayed(new Duration());
            });
        });
    }

    AudioTrack getTrack(String trackName) {
        return this._tracks[trackName];
    }

    Song getSong(String sfxName) {
        return this._sfx[sfxName];
    }
}
