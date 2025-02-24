#!/bin/bash
set -ex

# Validate required parameters
if [ -z "$release_channel" ]; then
    echo "Error: release_channel parameter is required"
    exit 1
fi

if [ -z "$api_key" ]; then
    echo "Error: api_key parameter is required"
    exit 1
fi

if which appzung > /dev/null; then
  echo "AppZung CLI already installed."
else
  echo "Installing AppZung CLI..."
  npm install -g @appzung/cli@1
fi

# Build the base command
DEPLOY_CMD="appzung releases deploy-react-native --release-channel \"$release_channel\" --api-key \"$api_key\""

if [ "$mandatory" == "yes" ]; then
    DEPLOY_CMD="$DEPLOY_CMD --mandatory"
fi

if [ ! -z "$rollout" ]; then
    DEPLOY_CMD="$DEPLOY_CMD --rollout $rollout"
fi

if [ ! -z "$target_binary_version" ]; then
    DEPLOY_CMD="$DEPLOY_CMD --target-binary-version \"$target_binary_version\""
fi

if [ ! -z "$private_key_path" ]; then
    DEPLOY_CMD="$DEPLOY_CMD --private-key-path \"$private_key_path\""
fi

if [ "$description_from_git" == "yes" ]; then
    DEPLOY_CMD="$DEPLOY_CMD --description-from-current-git-commit"
fi

if [ ! -z "$extra_flags" ]; then
    DEPLOY_CMD="$DEPLOY_CMD $extra_flags"
fi

echo "Executing deploy command..."
echo "$DEPLOY_CMD"

eval "$DEPLOY_CMD"
