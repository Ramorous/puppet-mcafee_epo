# Class: mcafee_epo_agent
#
# Provides puppet control module for McAfee EPO Agent
#
# === Parameters
#
# [class_enabled]
#   true/false
#   This will enable this module for the given host
#   This is helpful for Puppet ENC and Foreman/Satellite
#
# [agent_install_type]
#   script/repository
#   Only two options availble for use. Whether EPO agent is found in 
#   a script or a repository
#
# [agent_install_options]
#   String
#   Installation options for script being run.
#
# [agent_service_name]
#   String
#   Name of the Agent Service
#
# [agent_service_ensure]
#   String
#   Ensure the service is running, absent, etc... (Recommend Running)
#
# [agent_service_enable]
#   String
#   Have the service startup at boot. (Recommend true)
#
# [agent_service_provider]
#   String
#   Service provider for the agent. (Recommend init, unless Debian)
#
# [agent_service_script]
#   String
#   Location of "init" script for Agent. (Debian would be different)
#
class mcafee_epo_agent (
  $class_enabled          = true,
  $agent_install_type     = 'script',
  $agent_install_script   = 'puppet://moudules/files/install.sh',
  $agent_install_options  = undef,
  $agent_service_name     = 'cma',
  $agent_service_ensure   = 'running',
  $agent_service_enable   = true,
  $agent_service_provider = 'init',
  $agent_service_script   = '/etc/init.d/cma',
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
      fail( 'agent_install_script variable is not a string' )
    }
    if ! is_string($agent_install_type) {
      fail( 'agent_install_type variable is not a string' )
    }
    if ($agent_install_type != 'script') and ($agent_install_type != 'repository') {
      fail( 'agent_install_type must be: script/repository' )
    }
    if ! is_string($agent_install_options) {
      fail( 'agent_install_options variable is not a string' )
    }
    if ! is_string($agent_service_name) {
      fail( 'agent_service_name variable is not a string' )
    }
    if ! is_string($agent_service_ensure) {
      fail( 'agent_service_ensure variable is not a string' )
    }
    if is_string($agent_service_enable) {
      $agent_service_enable_real = str2bool($agent_service_enable)
    } else {
      $agent_service_enable_real = $agent_service_enable
    }
    if ! is_string($agent_service_provider) {
      fail( 'agent_service_provider variable is not a string' )
    }
    if ! is_string($agent_service_script) {
      fail( 'agent_service_script variable is not a string' )
    }

    # Check if Class is disabled (Helps to disable some hosts within Foreman/Satellite)
    if $class_enabled_real == true {
      case $agent_install_type {
        'script': {
          $agent_install_script_real = '/tmp/McAfee-Install.sh'
          file{ $agent_install_script:
            path   => $agent_install_script_real,
            ensure => present,
            source => $agent_install_script,
            mode   => '0700',
            owner  => 'root',
            group  => 'root',
          }
          exec{ $agent_install_script:
            command => "$agent_install_script_real $agent_install_options",
            onlyif  => "/usr/bin/test ! -f $agent_service_script",
            user    => root,
            path    => ['/usr/bin'],
          }
        }
        'repository': {
          package{ $agent_service_name:
            name => $agent_service_name,
            ensure => 'present',
          }
        }
      }
      service{ $agent_service_name:
        ensure   => $agent_service_ensure,
        enable   => $agent_service_enable_real,
        provider => $agent_service_provider,
      }
    } else {
      notice('Class disabled.')
    }
  } else {
    notice('System is not Linux based.')
  }
}
