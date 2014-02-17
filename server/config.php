<?php

class Config {

	protected $_appEnv;
	protected $_config;

	public function __construct($appEnv) {
		$this->_appEnv = $appEnv;

		$this->_config = $this->_loadConfig();
	}

	protected function _loadConfig() {
		$contents = file_get_contents("../config/{$this->_appEnv}.json");
		return json_decode($contents);
	}

	public function get($name = NULL) {
		if (NULL === $name) {
			return $this->_config;
		}
		return isset($this->_config->$name) ?: NULL;
	}

	public function exportVars() {
		foreach ($this->get() as $key => $value) {
			global $$key;
			$$key = $value;
		}
	}

	public function cleanupVars() {
		foreach ($this->get() as $key => $value) {
			global $$key;
			unset($$key);
		}
	}

	public function asJsonString() {
		return json_encode($this->get());
	}
}

/*
class Config {

	protected static $config = //NULL;
	array(

		'assets_version' => 1,
	
		'assets_host' => '',//'https://s3-us-west-1.amazon.aws.com',
		'assets_path' => '/beer_run/web',//'/beerrun/assets/',
	
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
*/
 
