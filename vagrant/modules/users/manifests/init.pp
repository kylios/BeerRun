class users {
	user { ubuntu:
		ensure => 'present',
		groups => ['sudo'],
		home => '/home/ubuntu',
		managehome => true,
		shell => '/bin/bash',
	}
}
