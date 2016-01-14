# mcafee_epo_agent

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the modules do and why it is useful](#module-description)
3. [Setup](#setup)
    * [Parameters](#parameters)
    * [Usage](#usage)
4. [License](#license)

## Overview

This module will allow management and installation of the McAfee EPO Agent.

## Module Description

This module will allow management and installation of the McAfee EPO Agent. Once installed and running, it will allow the EPO Management Console access to deploy remaining McAfee products remotely.

## Setup
### Parameters

```
[class_enabled]
  true/false
  This will enable this module for the given host
  This is helpful for Puppet ENC and Foreman/Satellite
[agent_install_type]
  script/repository
  Only two options availble for use. Whether EPO agent is found in
  a script or a repository
[agent_install_options]
  String
  Installation options for script being run.
[agent_service_name]
  String
  Name of the Agent Service
[agent_service_ensure]
  String
  Ensure the service is running, absent, etc... (Recommend Running)
[agent_service_enable]
  String
  Have the service startup at boot. (Recommend true)
[agent_service_provider]
  String
  Service provider for the agent. (Recommend init, unless Debian)
[agent_service_script]
  String
  Location of "init" script for Agent. (Debian would be different)
```

### Usage

```puppet
class { 'mcafee_epo_agent':
    class_enabled          => true,
    agent_install_type     => 'script',
    agent_install_options  => undef,
    agent_service_name     => 'cma',
    agent_service_ensure   => 'running',
    agent_service_enable   => true,
    agent_service_provider => 'init',
    agent_service_script   => '/etc/init.d/cma',
}
```


## License

Copyright 2015 Eric B

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
