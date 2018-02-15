# service-config

[![Build Status](https://travis-ci.org/pli01/docker-service-config.svg?branch=master)](https://travis-ci.org/pli01/docker-service-config)


This service will configure (nexus,gitlab) via there REST API
  * it use ansible
  * roles nexus3-oss
  * roles gitlab-config
  * define the configuration of gitlab and nexus in a group_vars file

* Build Args
  * you can change the DEB mirror and point to your internal repo
* Run Args
  * define proxy vars
  * define Shell var parsed by ansible (if needed)
  * To define your own config (group_vars) create a file with all yaml config, and mount this file as a volume
```
 # docker-compose.ENV.yml
    env_file:
      - ./ENV-config.env
    volumes:
      - ./ENV.config:/opt/ansible/config/group_vars/all:ro
```

# Build/Publish

## build

```
 make build test
```

## package
```
 make package
```
## publish
2 steps
  * publish: save and publish the packagename (build dir) in nexus registry
    * The url of the packagename can then be used in build.context of docker-compose
  * push: publish image in private registry


  * set shell env before
```
REPOSITORY_URL=http://private-nexus/nexus/repository/store-docker-build/
REPOSITORY_USERNAME=user
REPOSITORY_PASSWORD=password
REGISTRY_URL=private-docker-registry:80
REGISTRY_USERNAME=user
REGISTRY_PASSWORD=password
```

```
 make publish
 make push
```

## build test publish

```
make rmi build test publish push clean-image
```
