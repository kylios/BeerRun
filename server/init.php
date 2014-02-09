<?php

define('APPLICATION_DIR', '../server');
set_include_path(get_include_path().':'.APPLICATION_DIR);

function __autoload($className) {
	$fileName = strtolower($className);
	require APPLICATION_DIR."/{$fileName}.php";
}
