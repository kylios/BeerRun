<?php

class Config {

	protected static $config = array(

		'assets_version' => 1,
	
		'assets_host' => '',//'https://s3-us-west-1.amazon.aws.com',
		'assets_path' => '',//'/beerrun/assets/',
	
		'use_cdn' => false,
		'cdn_hosts' => array(
      		//'beerrun.s3-website-us-west-1.amazonaws.com',
			//'s3-us-west-1.amazonaws.com',
			//'localhost:8443',
		),
	);
	
	public static function get($name = NULL) {
		if (NULL === $name || ! isset(self::$config[$name])) {
			return self::$config;
		}
		return self::$config[$name];
	}

	public static function exportVars() {

		foreach (self::$config as $key => $value) {
			global $$key;
			$$key = $value;
		}
	}

	public static function asJsonString() {

		return json_encode(self::$config);
	}
}
 