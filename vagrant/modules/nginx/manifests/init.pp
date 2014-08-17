class nginx {
	include nginx::install, nginx::config, nginx::service
}

class nginx::install {
	package { 'nginx':
		ensure => present
	}
}

class nginx::config {
	file { "/etc/nginx":
		ensure => directory,
		recurse => true,
		purge => true,
		source => "/vagrant/modules/nginx/files/nginx",
		owner => "www-data",
		group => "www-data",
		mode => 0755,
		require => Package['nginx'],
		notify => Service["nginx"],
	}

}

class nginx::service {
	service {'nginx':
		require => Class["php5"],
		ensure => running,
		enable => true,
	}
}

Class["nginx::config"] -> Class["nginx::install"] -> Class["nginx::service"]

