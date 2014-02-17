<?php

define('APPLICATION_DIR', '../server');
define('APP_ENV', getenv('APP_ENV'));
set_include_path(get_include_path().':'.APPLICATION_DIR);

function __autoload($className) {
	$fileName = strtolower($className);
	require APPLICATION_DIR."/{$fileName}.php";
}

global $config;
$config = new Config(APP_ENV);
