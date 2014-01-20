<?php

class Config {

	protected static $config = array(

		'assets_version' => 1,
	
		'assets_path' => '/beerrun/assets/',
	
		'cdn_hosts' => array(
      		's3-us-west-1.amazonaws.com',
		),
	);
	
	public static function get($name = NULL) {
		if (NULL === $name || ! isset(self::$config[$name])) {
			return self::$config;
		}
		return self::$config[$name];
	}
}
