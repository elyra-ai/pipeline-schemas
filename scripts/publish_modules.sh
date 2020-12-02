#!/bin/bash
#
# Copyright 2017-2020 Elyra Authors
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
MASTER="master"
SKIP_CI="[skip ci]"

checkout_branch()
{
	echo "Checkout $1"
	git checkout $1
	git fetch origin
	git pull
}

push_changes()
{
	git status
	echo "Push changes to $1"
	git push https://$GIT_TOKEN@github.com/${GITHUB_REPOSITORY} $1
}

# Update package.json version on master
checkout_branch ${MASTER}

echo "Update patch version of pipeline-schemas"
npm version patch -m "Update version to ${MASTER_BUILD} ${SKIP_CI}"
MASTER_BUILD=`node -p "require('./package.json').version"`
echo "Master build $MASTER_BUILD"

push_changes ${MASTER}
MASTER_NUM=$(echo $MASTER_BUILD | cut -d'.' -f1-2)
# Tag release build
cd ./scripts
./tagBuild.sh "${MASTER}_${MASTER_BUILD}"
cd $WORKING_DIR

echo "Master major.minor build ${MASTER_NUM}"
echo "Publishing pipeline schemas to Artifactory NPM"
echo "//registry.npmjs.org/:_authToken=${NPM_AUTH_TOKEN}" > .npmrc
#npm publish
cd $WORKING_DIR
