<?php

include '../server/init.php';

function cdnHost() {
	$cdnHosts = Config::get('cdn_hosts');
	return $cdnHosts[array_rand($cdnHosts)];
}

function assetsVersion() {
	return Config::get('assets_version');
}

function assetPath() {
	$cdnHost = cdnHost();
	$assetsPath = Config::get('assets_path').assetsVersion().'/';
	return 'https://'.$cdnHost.$assetsPath;
}

?>

<!DOCTYPE html>

<html>
<head>
<meta charset="utf-8">
<title>BeerRun</title>
<link rel="stylesheet" type="text/css" href="beer_run.css"></link>
</head>
<body>
  <div class="container">
    <div class="left padded">
      <span><h1>BeerRun</h1></span>
      <div>a game by Kyle Racette</div>
    </div>
    <div class="left padded">
      <h3>CREDITS</h3>
      <ul>
        <li>music by Mark Racette</li>
        <li>Select art taken from <a href="http://opengameart.org">Open
            Game Art</a> and licensed under CC-BY-SA 3.0
        </li>
        <li>Testers: Scott Racette, Mark Racette</li>
      </ul>
      <p>
        Complete source code: <a
          href="https://github.com/morendi/BeerRun">https://github.com/morendi/BeerRun</a>
        <br /> All art licensed under CC-BY-SA 3.0 and/or GPLv3 <br />
      </p>
    </div>
    <div class="clear"></div>
    <div class="left padded">Twitter: coming soon</div>
    <div class="left padded">Facebook: coming soon</div>
    <div class="clear"></div>
  </div>

  <div class="container left padded">
    <div id="debug_stats">
      <div>FPS:</div>
      <div id="fps"></div>
    </div>
    <div id="stats">
      <div id="duration"></div>
      <div id="health_stats">
        HP:
        <div id="health"></div>
      </div>
      <div id="beers_stats">
        Beers:
        <div id="beers"></div>
      </div>
      <div class="clear"></div>
    </div>
    <div class="no_padding container">

      <div>
        <div style="display: inline-block">
          <div style="font-weight: bold">Music</div>
          <div>
            on <input id="music_toggle_on" type="radio"
              name="music_toggle" value="100" />
          </div>
          <div>
            off <input id="music_toggle_off" type="radio"
              name="music_toggle" value="0" />
          </div>
        </div>
        <div style="display: inline-block">
          <div style="font-weight: bold">SFX</div>
          <div>
            on <input id="sound_toggle_on" type="radio"
              name="sound_toggle" value="100" />
          </div>
          <div>
            off <input id="sound_toggle_off" type="radio"
              name="sound_toggle" value="0" />
          </div>
        </div>
      </div>
      <canvas id="game_canvas"></canvas>

      <div class="ui notifications" id="notifications_root"></div>

      <div class="ui window" id="root_pane"></div>
    </div>
  </div>

  <div class="clear"></div>

  <script type="application/dart" src="<?=assetPath();?>beer_run.dart"></script>
  <script src="<?=assetPath();?>packages/browser/dart.js"></script>
</body>
</html>

