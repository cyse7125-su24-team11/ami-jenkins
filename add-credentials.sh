#!/bin/bash

echo "
credentials:
  system:
    domainCredentials:
    - credentials:
      - usernamePassword:
          scope: GLOBAL
          id: \"GH_CRED\"
          username: \"maheshpoojaryneu\"
          password: \"${GH_TOKEN}\"
    - credentials:
      - usernamePassword:
          scope: GLOBAL
          id: \"DOCKER_CRED\"
          username: \"maheshpoojaryneu\"
          password: \"${DOCKER_TOKEN}\"
" >> /tmp/jenkins-config/jenkins.yaml
