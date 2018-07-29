
## Usage
To use this buildpack specify the URI of the repository when pushing an application to Cloud Foundry:

# clone this repo and edit
https://github.com/myminseok/java-pinpoint-buildpack/blob/master/config/pinpoint_agent.yml
https://github.com/myminseok/java-pinpoint-buildpack/blob/master/lib/java_buildpack/framework/pinpoint_agent.rb


# clone config repo
https://github.com/myminseok/pinpoint_agent_repo/blob/master/pinpoint.config


```bash
cf create-user-provided-service pinpoint -p '{"collector_ip":"10.10.10.10", "collector_port":"9999"}’   

$ cf push <APP-NAME> -p <ARTIFACT> -b https://github.com/myminseok/java-pinpoint-buildpack/edit/master/README.md

```

