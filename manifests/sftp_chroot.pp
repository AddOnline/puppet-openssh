# Class:: openssh::sftp_chroot
#
#
define openssh::sftp_chroot(
  $chroot_directory,
  $login                = $name,
  $group                = $name,
  $type                 = 'user',
  $allow_tcp_forwarding = false,
  $x11_forwarding       = false,
  $command              = 'internal-sftp',
  $template             = 'openssh/sftp_chroot.erb'
){
  
  include openssh

  $bool_allow_tcp_forwarding = any2bool($allow_tcp_forwarding)
  $bool_x11_forwarding = any2bool($x11_forwarding)

  if $openssh::use_concat == false {
    fail("In order to user openssh::sftp_chroot you have to enable [*use_concat*].")
  } else {
    concat::fragment{"openssh-sftp-chroot-$name":
      target  => $openssh::config_file,
      content => template($template),
      order   => '50',
    }

    file { "openssh-sftp-chroot-$name":
      path   => $chroot_directory,
      ensure => directory,
      owner  => 'root',
      group  => 'root',
    }
  }

} # Class:: openssh::sftp_chroot
