class apticron {
	define listchanges::email($email = false) {
		$t_email = $email ? {
			false   => "root",
			default => $email,
		}

		file { "$name":
			owner   => root,
			group   => root,
			mode    => 0644,
			content => template("apticron/common/etc/apt/listchanges.conf.erb"),
			require => Package["apt-listchanges"],
		}
	 }

	 define apticron::email($email = false) {
		$t_email = $email ? {
			false   => "root",
			default => $email,
		}

		file { "$name":
			owner   => root,
			group   => root,
			mode    => 0644,
			alias   => "apticron.conf",
			content => template("apticron/$lsbdistcodename/etc/apticron/apticron.conf.erb"),
			require => Package["apticron"],
		}
	}

	listchanges::email { "/etc/apt/listchanges.conf":
		email => "listchanges@${domain}",
	}

	apticron::email { "/etc/apticron/apticron.conf":
		email => "apticron@${domain}",
	}

	file { "/etc/cron.d/apticron":
		owner   => root,
		group   => root,
		mode    => 0644,
		source  => "puppet:///modules/apticron/common/etc/cron.d/apticron",
		require => [
			File["apticron.conf"],
			Package["apticron"]
		],
	}

	file { "/etc/cron.daily/apticron":
		ensure => absent,
	}

	package { [
		"apticron",
		"apt-listchanges" ]:
		ensure => present,
	}
}

# vim: tabstop=3