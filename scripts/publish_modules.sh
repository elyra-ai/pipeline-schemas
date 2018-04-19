#!/bin/bash

#-------------------------------------------------------------
# IBM Confidential
# OCO Source Materials

# (C) Copyright IBM Corp. 2018
# The source code for this program is not published or
# otherwise divested of its trade secrets, irrespective of
# what has been deposited with the U.S. Copyright Office.
#-------------------------------------------------------------

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
	git push origin $1
}

# Update package.json version on master
	checkout_branch ${MASTER}

	echo "Update patch version of pipeline-schemas"
	npm version patch -m "Update version to ${MASTER_BUILD} ${SKIP_CI}"
	MASTER_BUILD=`node -p "require('./package.json').version"`
	echo "Master build $MASTER_BUILD"

	push_changes ${MASTER} 
	MASTER_NUM=$(echo $MASTER_BUILD | cut -d'.' -f1-2)

	echo "Master major.minor build ${MASTER_NUM}"

	echo "Publishing pipeline schemas to Artifactory NPM"
	npm publish
	cd $WORKING_DIR
