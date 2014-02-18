<?php

include '../server/init.php';

function cdnHost() {
  global $config;
	$cdnHosts = $config->get('cdn_hosts');
  if (empty($cdnHosts))
    return NULL;
	return $cdnHosts[array_rand($cdnHosts)];
}

function assetsVersion() {
  global $config;
	return $config->get('assets_version');
}

function assetPath() {
  global $config;
	$cdnHost = cdnHost();
  if (NULL === $cdnHost)
    return '';
	$assetsPath = $config->get('assets_path').assetsVersion().'/';
	return 'https://'.$cdnHost.$assetsPath;
}

$config->exportVars();

?>

<!DOCTYPE html>

<html>
<head>
<meta charset="utf-8">
<title>BeerRun</title>
<link rel="stylesheet" type="text/css" href="<?=assetPath();?>beer_run.css"></link>
</head>
<body>
  <div class="container left padded">
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
    <div class="no_padding container" style="width: 640px;">
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
            on <input id="sfx_toggle_on" type="radio"
              name="sfx_toggle" value="100" />
          </div>
          <div>
            off <input id="sfx_toggle_off" type="radio"
              name="sfx_toggle" value="0" />
          </div>
        </div>
      </div>
      <canvas id="game_canvas"></canvas>

      <div class="ui notifications" id="notifications_root"></div>

      <div class="ui window" id="root_pane"></div>
    </div>
  </div>


  <div class="container left padded" style="width: 260px;" id="debug_stats">
  </div>

  <div class="container left padded" style="width: 260px;">
    <div class="padded">
      <span><h1>BeerRun</h1></span>
      <div>a game by Kyle Racette</div>
    </div>
    <div class="padded">
      <div class="bold">Credits</div>
      <div>
        <div class="padded">
          <div class="bold">Music</div>
          <div>Mark Racette</div>
        </div>
        <div class="padded">
          <div class="bold">Art</div>
          <div>Kyle Racette</div>
          <div>Kind contributors from <a href="http://opengameart.org">Open Game Art</a></div>
          <div>licensed under CC-BY-SA 3.0</div>
        </div>
        <div class="padded">
          <div class="bold">Programming</div>
          <div>Kyle Racette</div>
        </div>
        <div class="padded">
          <div class="bold">Testers</div>
          <div>Ryan Scott</div>
          <div>Scott Racette</div>
          <div>Mark Racette</div>
          <div>Amber Larkins</div>
        </div>
        <div class="padded">
          <div class="bold">Source Code</div>
          <div><a href="https://github.com/morendi/BeerRun">github</a></div>
          <div>licensed under GPLv3</div>
        </div>
      </div>
      <div class="bold">Follow</div>
      <div>
        <div class="padded">
          <div>Twitter</div>
          <div><a href="https://twitter.com/beerrungame">@beerrungame</a></div>
        </div>
        <div class="padded">
          <div>Facebook</div>
          <div>coming soon</div>
        </div>
      </div>
      <div class="bold">Contact</div>
      <div>
        <div class="padded">
          <div>beerungame (at) gmail (dot) com</div>
      </div>
    </div>
  </div>

  <div class="clear"></div>

  <script type="application/dart" src="<?=assetPath();?>beer_run.dart"></script>
  <script src="<?=assetPath();?>packages/browser/dart.js"></script>
</body>
</html>

