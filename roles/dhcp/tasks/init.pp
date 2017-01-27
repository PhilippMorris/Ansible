#
# The basic system components of a referesh stattion.
#

class dhcp($lan_interface="eth1", $wifi_interface="wlan0") {
	package { "isc-dhcp-server": ensure => "latest" }

	#file { '/etc/init/wifi-restart-dhcp.conf':
	#	ensure => present,
	#	owner => 'root',
	#	group => 'root',	
	#	mode => 644,
	#	content => template('dhcp/wifi-restart-dhcp.conf')
	#}

	file { '/etc/dhcp/dhcpd.conf':
		ensure => present,
		owner => 'root',
		group => 'root',
		mode => 644,
		source => [ "puppet:///modules/dhcp/dhcpd.conf"	],
		require => Package["isc-dhcp-server"],
		notify => Service["isc-dhcp-server"],
	}

	file { '/etc/default/isc-dhcp-server':
		ensure => present,
		owner => 'root',
		group => 'root',
		mode => 644,
		content => template("dhcp/isc-dhcp-server.erb"),
		require => Package["isc-dhcp-server"],
		notify => Service["isc-dhcp-server"],
	}

	service { "isc-dhcp-server":
		ensure => "running",
		require => Package["isc-dhcp-server"]}

	#service { 'wifi-restart-dhcp':
	#	ensure => running,
	#}

	#Service["networking"] ~> Service["isc-dhcp-server"]
	
	# Fix for bug in old Puppet versions. Needed for cleanup.
	exec { "Remove isc-dhcp-server SysV links":
		command => '/bin/rm /etc/rc*.d/*20isc-dhcp-server',
		onlyif => '/usr/bin/test "$(/usr/bin/find /etc/rc*.d -name *20isc-dhcp-server)"'
	}
}
