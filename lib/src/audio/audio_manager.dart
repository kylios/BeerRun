part of audio;

class AudioManager {

  AudioContext _ctx = new AudioContext();
  Map<String, String> _soundPaths = new Map<String, String>();
  Map<String, Song> _sounds = new Map<String, Song>();

  AudioManager();

  void addSound(String id, String url) {
    this._soundPaths[id] = url;
  }

  Future loadAndDecode() {

    Completer c = new Completer();

    int count = this._soundPaths.keys.length;
    for (String id in this._soundPaths.keys) {

      String url = this._soundPaths[id];
      window.console.log("Loading song: ${id}: ${url}");

      // Fetch the asset
      /*HttpRequest request = new HttpRequest();
      request.open('GET', url, async: true);
      request.responseType = 'arraybuffer';
      request.onLoad.listen((ProgressEvent e) {*/

      HttpRequest.request(url, method: 'GET', responseType: 'arraybuffer')
        .then((request) {
        // Only enter if we've loaded all the bytes
        //window.console.log("Loading audio: ${e.loaded} / ${e.total}");
        //if (e.loaded == e.total) {

          window.console.log("loaded audio: $id");
          ByteBuffer data = request.response;

          // TODO: gain node should probably be shared.  There should be two:
          // one for music, one for effects
          GainNode gainNode = this._ctx.createGainNode();

          AudioBufferSourceNode source;
          this._ctx.decodeAudioData(data)
            .then((AudioBuffer buffer) {
              source = this._ctx.createBufferSource();
              source.connectNode(gainNode, 0, 0);
              gainNode.connectNode(this._ctx.destination, 0, 0);
              source.buffer = buffer;

              Song s = new Song.fromSource(this, source);

              // Save the newly constructed song and decrement the counter
              this._sounds[id] = s;
              count--;

              // If they've all been loaded, complete the future
              if (count == 0) {
                c.complete();
              }
              //}
            });
      });
      //request.send();
    }

    return c.future;
  }

  Song getSong(String id) {
    return this._sounds[id];
  }
}
