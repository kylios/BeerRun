class heira {
	include heira::install
}

class heira::install {
	package { 'heira':
		ensure => present
	}
}
