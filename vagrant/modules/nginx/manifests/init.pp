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

	file { "/etc/nginx/sites-enabled":
		ensure => directory,
		owner => "www-data",
		group => "www-data",
		mode => 0755,
		require => File['/etc/nginx']
	}

	file { "/etc/nginx/sites-enabled/${app_hostname}.conf":
		ensure => file,
		content => template("nginx/nginx-vhost.conf.erb"),
		owner => "www-data",
		group => "www-data",
		mode => 0755,
		require => File['/etc/nginx/sites-enabled']
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

