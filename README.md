
# JAVA BUILDPACK using Pinpoint

## Usage
To use this buildpack specify the URI of the repository when pushing an application to Cloud Foundry:

### prepare pinpoint.config on your git repo.

```
git clone https://github.com/myminseok/pinpoint_agent_repo

cf create-user-provided-service pinpoint -p '{"pinpoint.config.uri":"https://raw.githubusercontent.com/myminseok/pinpoint_agent_repo/master/pinpoint.config"}'

```


### push your app  with pinpoint service and java-pinpoint-buildpack


```bash
---
applications:
- name: articulate
  memory: 1G 
  instances: 1
  path: target/articulate-0.0.1-SNAPSHOT.jar
  buildpack: https://github.com/myminseok/java-pinpoint-buildpack
  services:
  - pinpoint

```

### you may change pinpoint_agent_repo in java-pinpoint-buildpack
https://github.com/myminseok/java-pinpoint-buildpack/blob/master/config/pinpoint_agent.yml
```
---
version: 1.+
repository_root: https://raw.githubusercontent.com/myminseok/pinpoint_agent_repo/master
```