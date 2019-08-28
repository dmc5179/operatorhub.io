#!/bin/bash

# If the pod is run with a different repo and command
# change them before starting the server
if [[ ! -z $OLM_REPO ]]
then
  sed -i "s|const olmRepo =.*|const olmRepo = '$OLM_REPO';|" 'frontend/src/components/InstallModal.js'
fi

if [[ ! -z $INSTALL_OLM_PATH ]]
then
  sed -i "s|const INSTALL_OLM_COMMAND =.*|const INSTALL_OLM_COMMAND = \`curl -sL \$\{olmRepo\}/${INSTALL_OLM_PATH} \| bash -s install.sh\`;|" 'frontend/src/components/InstallModal.js'
fi

pushd server
npm run-script server
