part of audio;

class AudioManager {

  Loader _assetsLoader;

  AudioContext _ctx = new AudioContext();
  Map<String, String> _musicPaths = new Map<String, String>();
  Map<String, String> _soundPaths = new Map<String, String>();
  Map<String, Song> _sfx = new Map<String, Song>();

  Map<String, AudioTrack> _tracks = new Map<String, AudioTrack>();

  Map<String, List<Map<String, Map>>> _audioConfig = new Map<String, List<Map<String, Map>>>();

  AudioManager.fromConfig(this._assetsLoader, this._audioConfig);

  Future loadAndDecode() {

    Completer completer = new Completer();

    int count = 0;
    this._audioConfig.forEach((String trackName, List<Map<String, Map>> trackConfig) {

      if (this._tracks[trackName] == null) {
        GainNode gain = this._ctx.createGain();
        AudioTrack track = new AudioTrack(trackName, gain, off);
        this._tracks[trackName] = track;


        trackConfig.forEach((Map<String, dynamic> songConfig) {
          String songName = songConfig['name'];
          String songPath = songConfig['path'];

          count++;

          // TODO: Use the loader.  It currently only supports json files.
          HttpRequest.request(songPath, method: 'GET', responseType: 'arraybuffer').then((request) {

            window.console.log("loaded audio: $songName");
            ByteBuffer data = request.response;

            AudioBufferSourceNode source;
            this._ctx.decodeAudioData(data)
              .then((AudioBuffer buffer) {
                source = this._ctx.createBufferSource();
                source.connectNode(gain, 0, 0);
                gain.connectNode(this._ctx.destination, 0, 0);
                source.buffer = buffer;


                Song s = new Song.fromSource(this, source, track);

                this._sfx[songName] = s;

                if (--count == 0) {
                  completer.complete();
                }
              });
          });
        });
      }
    });

    if (count == 0) {
      Timer.run(() => completer.complete());
    }
    return completer.future;
  }

  AudioTrack getTrack(String trackName) {
    return this._tracks[trackName];
  }

  Song getSong(String sfxName) {
    return this._sfx[sfxName];
  }
}
