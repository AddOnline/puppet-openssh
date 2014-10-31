# Puppet module: openssh

This is a Puppet openssh module from the second generation of Example42 Puppet Modules.

Made by Alessandro Franceschi / Lab42

Official site: http://www.example42.com

Official git repository: http://github.com/example42/puppet-openssh

Released under the terms of Apache 2 License.

This module requires functions provided by the Example42 Puppi module.

For detailed info about the logic and usage patterns of Example42 modules read README.usage on Example42 main modules set.

## USAGE - Basic management

* Install openssh with default settings

        class { "openssh": }

* Disable openssh service.

        class { "openssh":
          disable => true
        }

* Disable openssh service at boot time, but don't stop if is running.

        class { "openssh":
          disableboot => true
        }

* Remove openssh package

        class { "openssh":
          absent => true
        }

* Enable auditing without without making changes on existing openssh configuration files

        class { "openssh":
          audit_only => true
        }


## USAGE - Create a SFTP account
In order to manage SFTP account the sshd\_config config file should be manage with concat. You have to enable like this :

        class { "openssh":
          source     => 'puppet:///modules/lab42/openssh/openssh.conf',
          use_concat => true,
        }

Now you can use the _openssh::sftp_chroot_ directive. The only mandatory option is _chroot\_directory_. Here we create a sftp account for user _user42_ chrooted in _/home/user42_ with _password42_ as password.

        # Compute password.
        $password_salt = 'SecuSalt'
        $user42_passwd = mkpasswd('password42', $password_salt)

        # Describe SFTP user
        user { 'user42':
          password => $user42_passwd,
        }
        openssh::sftpd_chroot { 'user42':
          chroot_directory => '/home/user42',
        }

Additionnal option are :

* __type__ : Default value is 'user' if you want to enable sftp chroot based on group set this to 'group'
* __allow\_tcp\_forwarding__ : Set to true to allow X11Forwarding (default : false)
* __command__ : SFTP command. (defautl : internal-sftp).


## USAGE - Overrides and Customizations
* Use custom sources for main config file

        class { "openssh":
          source => [ "puppet:///modules/lab42/openssh/openssh.conf-${hostname}" , "puppet:///modules/lab42/openssh/openssh.conf" ],
        }


* Use custom source directory for the whole configuration dir

        class { "openssh":
          source_dir       => "puppet:///modules/lab42/openssh/conf/",
          source_dir_purge => false, # Set to true to purge any existing file not present in $source_dir
        }

* Use custom template for main config file

        class { "openssh":
          template => "example42/openssh/openssh.conf.erb",
        }

* To manipulate options in your config using the options array you should use this syntax in your config
        UsePAM <%= scope.function_options_lookup(['UsePAM','no']) %>
        LogLevel <%= scope.function_options_lookup(['LogLevel','INFO']) %>
        ListenAddress <%= scope.function_options_lookup(['ListenAddress', '0.0.0.0']) %>

* Define custom options that can be used in a custom template without the
  need to add parameters to the openssh class

        class { "openssh":
          template => "example42/openssh/openssh.conf.erb",
          options  => {
            'LogLevel'      => 'INFO',
            'UsePAM'        => 'yes',
            'ListenAddress' => '0.0.0.0'
          },
        }

* Automaticallly include a custom subclass

        class { "openssh:"
          my_class => 'openssh::example42',
        }

== USAGE - Manage a user SSH keys:
* Use all defaults and place in the user's home directory ssh keys that are
  stored centrally on the puppet server.

        openssh::key { 'username': }


## USAGE - Example42 extensions management
* Activate puppi (recommended, but disabled by default)
  Note that this option requires the usage of Example42 puppi module

        class { "openssh":
          puppi    => true,
        }

* Activate puppi and use a custom puppi_helper template (to be provided separately with
  a puppi::helper define ) to customize the output of puppi commands

        class { "openssh":
          puppi        => true,
          puppi_helper => "myhelper",
        }

* Activate automatic monitoring (recommended, but disabled by default)
  This option requires the usage of Example42 monitor and relevant monitor tools modules

        class { "openssh":
          monitor      => true,
          monitor_tool => [ "nagios" , "monit" , "munin" ],
        }

* Activate automatic firewalling
  This option requires the usage of Example42 firewall and relevant firewall tools modules

        class { "openssh":
          firewall      => true,
          firewall_tool => "iptables",
          firewall_src  => "10.42.0.0/24",
          firewall_dst  => "$ipaddress_eth0",
        }


[![Build Status](https://travis-ci.org/example42/puppet-openssh.png?branch=master)](https://travis-ci.org/example42/puppet-openssh)
