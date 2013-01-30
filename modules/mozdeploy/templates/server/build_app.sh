#!/bin/bash

VERSION=$1

/usr/bin/mozdeploy-build-app --hostroot "/data/mozdeployserver/<%= cluster %>" --build_dir "/data/<%= cluster %>/.mozdeploybuild" --app "<%= app_name %>" --command "<%= build_command %>" --version "$VERSION"
