# Class: mcafee-epo
#
class mcafee-epo (
  $class_enabled          = true,
  $agent_install_type     = 'script',
  $agent_install_script   = 'puppet:///modules/mcafee-epo/installer.sh',
  $agent_install_options  = '-i',
  $agent_service_name     = 'cma',
  $agent_service_ensure   = 'running',
  $agent_service_enable   = true,
  $agent_service_provider = 'init',
  $nails_service_name     = 'nails',
  $nails_service_ensure   = 'running,
  $nails_service_enable   = true,
  $nails_service_provider = 'init',
) {
  # Verify if target host is Linux
  if $::kernel == 'Linux' {
    # Perform Validations
    if is_string($class_enabled) {
      $class_enabled_real = str2bool($class_enabled)
    } else {
      $class_enabled_real = $class_enabled
    }
    if ! is_string($agent_install_script) {
      fail( 'agent_install_script variable is not a string')
    }
    if ! is_string($agent_install_type) {
      fail( 'agent_install_type variable is not a string')
    }
    if $agent_install_type.match(/(script|repository)/) == undef {
      fail('agent_install_type must be: script/repository')
    }
    if ! is_string($agent_install_options) {
      fail( 'agent_install_options variable is not a string')
    }
    if ! is_string($agent_service_name) {
      fail( 'agent_service_name variable is not a string')
    }
    if ! is_string($agent_service_ensure) {
      fail( 'agent_service_ensure variable is not a string')
    }
    if is_string($agent_service_enable) {
      $agent_service_enable_real = str2bool($agent_service_enable)
    } else {
      $agent_service_enable_real = $agent_service_enable
    }
    if ! is_string($agent_service_provider) {
      fail( 'agent_service_provider variable is not a string')
    }
    if ! is_string($nails_service_name) {
      fail( 'nails_service_name variable is not a string')
    }
    if ! is_string($nails_service_ensure) {
      fail( 'nails_service_ensure variable is not a string')
    }
    if is_string($nails_service_enable) {
      $nails_service_enable_real = str2bool($nails_service_enable)
    } else {
      $nails_service_enable_real = $nails_service_enable
    }
    if ! is_string($nails_service_provider) {
      fail( 'nails_service_provider variable is not a string')
    }

    # Check if Class is disabled (Helps to disable some hosts within Foreman/Satellite)
    if $class_enabled_real == true {
      case $agent_install_type {
        'script': {
        }
        'repository': {
          package{ $agent_service_name:
            install_options => 
          }
        }
      }
      service{ $agent_service_name:
        ensure => $agent_service_ensure,
        enable => $agent_service_enable_real,
      }
      service{ $nails_service_name:
        ensure => $nails_service_ensure,
        enable => $nails_service_enable_real,
      }
#      $command_string = "/usr/local/avamar/etc/avagent.d register ${admin_server} ${server_domain}"
#      exec { 'AVRegister':
#        command => $command_string,
#        user    => root,
#        onlyif  => '/usr/bin/test ! -f /usr/local/avamar/var/avagent.cfg',
#        path    => ['/usr/bin','/sbin'],
#      }
    } else {
      notice('Class disabled.')
    }
  } else {
    notice('System is not Linux based.')
  }
}