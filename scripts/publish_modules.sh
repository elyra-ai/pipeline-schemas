#!/bin/bash
#
# Copyright 2017-2025 Elyra Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e

WORKING_DIR="$PWD"
MAIN="main"
SKIP_CI="[skip ci]"

git config --global user.email "elyra-pipeline-schemas@users.noreply.github.com"
git config --global user.name "Automated build"

# Update package.json version on main

echo "Update patch version of pipeline-schemas"
npm version patch -m "Update package.json version ${SKIP_CI}"
MAIN_BUILD=`node -p "require('./package.json').version"`
echo "Main build $MAIN_BUILD"
git push

MAIN_NUM=$(echo $MAIN_BUILD | cut -d'.' -f1-2)
# Tag release build
cd ./scripts
./tagBuild.sh "${MAIN}_${MAIN_BUILD}"
cd $WORKING_DIR

echo "Main major.minor build ${MAIN_NUM}"
echo "Publishing pipeline schemas to Artifactory NPM"
echo "//registry.npmjs.org/:_authToken=${NPM_AUTH_TOKEN}" > .npmrc
npm publish
