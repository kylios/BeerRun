class vim {
	include vim::install
}

class vim::install {
	package { 'vim':
		ensure => present
	}
}
