class php5 {
	include php5::install, php5::config, php5::service
}

class php5::install {
	package { 'php5-fpm':
		ensure => present
	}
	package { 'php5-curl':
		ensure => present
	}
	package { 'php5-xdebug':
		ensure => present
	}
	package { 'php5-memcached':
		ensure => present
	}
	package { 'php5-mysql':
		ensure => present
	}
	Package["php5-fpm"] -> Package["php5-curl"] -> Package["php5-xdebug"] -> Package["php5-memcached"] -> Package["php5-mysql"]
}

class php5::config {
	file { "/etc/php5":
		ensure => directory,
		recurse => true,
		purge => true,
		source => "/vagrant/modules/php5/files/php5",
		owner => "root",
		group => "root",
		mode => 0644,
		notify => Service["php5-fpm"],
	}
}

class php5::service {
	service {'php5-fpm':
		require => Package["php5-fpm"],
		ensure => running,
		enable => true,
	}
}

Class["php5::config"] -> Class["php5::install"] -> Class["php5::service"]
